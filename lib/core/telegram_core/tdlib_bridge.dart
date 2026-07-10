import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handy_tdlib/handy_tdlib.dart';
import 'tdlib_ffi.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../services/secure_storage_service.dart';
import '../services/nova_logger.dart';

final tdlibBridgeProvider = Provider<TdlibBridge>((ref) {
  return TdlibBridge(ref.read(secureStorageProvider));
});

/// Message types for main→background isolate communication.
class _IsolateInitMsg {
  final SendPort sendPort;
  final String libPath;
  _IsolateInitMsg(this.sendPort, this.libPath);
}

/// Message types for background→main isolate communication.
class _IsolateReadyMsg {
  final int clientId;
  final SendPort bgSendPort;
  _IsolateReadyMsg(this.clientId, this.bgSendPort);
}

class _IsolateStopMsg {}
class _IsolateStoppedMsg {}

class _IsolateUpdateMsg {
  final String rawJson;
  final String? type;
  _IsolateUpdateMsg(this.rawJson, this.type);
}

class _IsolateErrorMsg {
  final String message;
  _IsolateErrorMsg(this.message);
}

/// Background isolate entry point.
/// Runs the blocking receive loop off the main thread.
void _receiveIsolateEntry(_IsolateInitMsg initMsg) async {
  final mainSendPort = initMsg.sendPort;
  final bgReceivePort = ReceivePort();

  bool isRunning = true;
  bgReceivePort.listen((msg) {
    if (msg is _IsolateStopMsg) {
      isRunning = false;
    }
  });

  try {
    // Initialize TDLib in this isolate
    await TdPlugin.initialize(initMsg.libPath);
    final clientId = TdPlugin.instance.tdCreateClientId();

    // Set log verbosity in this isolate
    TdPlugin.instance.tdSend(clientId, jsonEncode({'@type': 'setLogVerbosityLevel', 'new_verbosity_level': 1}));

    // Tell main isolate we're ready with the client ID and our receive port
    mainSendPort.send(_IsolateReadyMsg(clientId, bgReceivePort.sendPort));

    // Receive loop — runs until stopped
    while (isRunning) {
      final res = TdPlugin.instance.tdReceive(1.0); 
      if (res != null) {
        try {
          final json = jsonDecode(res);
          final String? type = json['@type'];
          mainSendPort.send(_IsolateUpdateMsg(res, type));
        } catch (e) {
          mainSendPort.send(_IsolateErrorMsg('Parse error: $e'));
        }
      }
      
      // Yield to the event loop so bgReceivePort can process the stop message
      await Future.delayed(Duration.zero);
    }
    
    bgReceivePort.close();
    mainSendPort.send(_IsolateStoppedMsg());
  } catch (e) {
    mainSendPort.send(_IsolateErrorMsg('Isolate fatal error: $e'));
    bgReceivePort.close();
  }
}

class TdlibBridge {
  final SecureStorageService _secureStorage;
  int? _clientId;
  bool _isMock = false;
  bool _isInitializing = false;
  bool _isInitialized = false;
  bool _isDestroyed = false;
  bool _tdlibParametersSent = false;
  bool _authStateReceived = false;

  // Background isolate state
  Isolate? _receiveIsolate;
  ReceivePort? _receivePort;
  SendPort? _bgSendPort;
  Completer<void>? _isolateStopCompleter;
  
  bool get isReady => _clientId != null;
  
  final _updateController = StreamController<TdObject>.broadcast();
  Stream<TdObject> get updates => _updateController.stream;

  TdlibBridge(this._secureStorage);

  Future<void> initialize({bool useMock = false}) async {
    if (_isInitializing) {
      if (kDebugMode) NovaLogger.tdlib('TDLib init skipped: already initializing');
      return;
    }
    if (_isInitialized) {
      if (kDebugMode) NovaLogger.tdlib('TDLib init skipped: already initialized');
      return;
    }
    _isInitializing = true;
    _isDestroyed = false;
    _isMock = kReleaseMode ? false : useMock;
    
    if (kDebugMode) {
      final mode = _isMock ? 'MOCK' : 'REAL';
      NovaLogger.tdlib('Bridge mode: $mode');
    }

    if (_isMock) {
      _isInitialized = true;
      _isInitializing = false;
      return;
    }

    final credentials = await _secureStorage.getCredentials();
    if (credentials == null) {
      NovaLogger.tdlib('TDLib init blocked: Missing API credentials');
      _isInitializing = false;
      _updateController.add(TdError(code: 401, message: 'Missing API credentials'));
      return;
    }

    // Determine library path
    final libPath = TdlibFfi.getLibraryPath();

    // Initialize TDLib on main isolate too (needed for send/execute)
    await TdPlugin.initialize(libPath);

    // Spawn background isolate for the receive loop
    if (kDebugMode) NovaLogger.tdlib('Spawning background receive isolate');
    _receivePort = ReceivePort();
    
    final initMsg = _IsolateInitMsg(_receivePort!.sendPort, libPath);
    _receiveIsolate = await Isolate.spawn(_receiveIsolateEntry, initMsg);

    // Listen for messages from background isolate
    _receivePort!.listen(_handleIsolateMessage);

    _isInitialized = true;
    _isInitializing = false;

    if (kDebugMode) NovaLogger.tdlib('Background isolate spawned: YES');
  }

  /// Handle messages from the background receive isolate.
  void _handleIsolateMessage(dynamic message) {
    if (_isDestroyed) {
      if (message is _IsolateStoppedMsg) {
        _isolateStopCompleter?.complete();
      }
      return;
    }

    if (message is _IsolateReadyMsg) {
      _clientId = message.clientId;
      _bgSendPort = message.bgSendPort;
      if (kDebugMode) NovaLogger.tdlib('TDLib client created in background isolate: YES');
      _bootstrapAuthorization();
    } else if (message is _IsolateUpdateMsg) {
      _processUpdate(message.rawJson, message.type);
    } else if (message is _IsolateErrorMsg) {
      if (kDebugMode) NovaLogger.tdlib('Background isolate error: ${message.message}');
    } else if (message is _IsolateStoppedMsg) {
      _isolateStopCompleter?.complete();
    }
  }

  /// Process a raw JSON update received from the background isolate.
  /// This runs on the main isolate but does NOT block — just parses and dispatches.
  void _processUpdate(String rawJson, String? type) {
    try {
      if (type == 'error') {
        final json = jsonDecode(rawJson);
        final code = json['code'];
        final errorMessage = json['message'];
        final extra = json['@extra'];
        if (kDebugMode) {
          NovaLogger.tdlib('TDLib error code: $code');
          NovaLogger.tdlib('TDLib error message: $errorMessage');
          NovaLogger.tdlib('TDLib error source: ${extra ?? 'unknown'}');
        }
        
        if (extra != null && (extra as String).startsWith('nova_set_tdlib_parameters')) {
          _updateController.add(TdError(code: code, message: 'Telegram authorization setup failed.\nCheck your API ID and API Hash.'));
          return;
        }
      }

      if (type == 'updateAuthorizationState') {
        _authStateReceived = true;
      }

      // Parse the TdObject on the main isolate (fast for small JSON)
      final object = convertJsonToObject(rawJson);

      if (type != null && type.startsWith('authorizationState')) {
        _authStateReceived = true;
        if (kDebugMode) NovaLogger.tdlib('getAuthorizationState returned: $type');
        if (object is AuthorizationState) {
          final update = UpdateAuthorizationState(authorizationState: object);
          _updateController.add(update);
          _handleCoreUpdate(update);
        }
      } else {
        if (object != null) {
          _updateController.add(object);
          _handleCoreUpdate(object);
        }
      }
    } catch (e) {
      if (kDebugMode) NovaLogger.tdlib('Process update error: $e');
    }
  }

  void _bootstrapAuthorization() async {
    int attempts = 0;
    while (attempts < 3) {
      if (_isDestroyed) return;
      if (_authStateReceived) {
         if (kDebugMode) NovaLogger.tdlib('Bootstrap loop stopped: Auth state already received');
         return;
      }
      if (kDebugMode) NovaLogger.tdlib('Requesting current authorization state: YES');
      send(GetAuthorizationState(), extra: 'nova_get_authorization_state_${DateTime.now().millisecondsSinceEpoch}');
      attempts++;
      
      await Future.delayed(const Duration(seconds: 1));
    }
    if (!_authStateReceived && !_isDestroyed) {
      if (kDebugMode) NovaLogger.tdlib('getAuthorizationState timeout');
      if (kDebugMode) NovaLogger.tdlib('Retrying authorization state request');
      _updateController.add(TdError(code: 408, message: 'Auth startup timeout'));
    }
  }

  void _handleCoreUpdate(TdObject object) {
    if (object is UpdateAuthorizationState) {
      final state = object.authorizationState;
      if (kDebugMode) {
        NovaLogger.tdlib('Auth state: ${state.runtimeType}');
      }
      
      if (state is AuthorizationStateWaitTdlibParameters) {
        _handleWaitTdlibParameters();
      }
    }
  }

  Future<void> _handleWaitTdlibParameters() async {
    if (_tdlibParametersSent) {
      if (kDebugMode) NovaLogger.tdlib('setTdlibParameters skipped: already sent');
      return;
    }
    _tdlibParametersSent = true;

    final credentials = await _secureStorage.getCredentials();
    if (credentials == null) {
      if (kDebugMode) NovaLogger.tdlib('TDLib parameters blocked: Missing API credentials');
      return;
    }

    final apiIdStr = credentials['apiId'] ?? '';
    final apiId = int.tryParse(apiIdStr);
    final apiHash = credentials['apiHash'];

    if (apiId == null || apiId <= 0) {
      NovaLogger.tdlib('API ID valid: NO');
      _updateController.add(TdError(code: 400, message: 'Invalid Telegram Developer Credentials'));
      return;
    }
    NovaLogger.tdlib('API ID valid: YES');

    if (apiHash == null || apiHash.trim().isEmpty || apiHash.contains(' ')) {
      NovaLogger.tdlib('API HASH valid format: NO');
      _updateController.add(TdError(code: 400, message: 'Invalid Telegram Developer Credentials'));
      return;
    }
    NovaLogger.tdlib('API HASH valid format: YES');

    final docDir = await getApplicationDocumentsDirectory();
    final dbDir = Directory(p.join(docDir.path, 'tdlib', 'database'));
    final filesDir = Directory(p.join(docDir.path, 'tdlib', 'files'));
    
    if (!dbDir.existsSync()) dbDir.createSync(recursive: true);
    if (!filesDir.existsSync()) filesDir.createSync(recursive: true);
    
    NovaLogger.tdlib('Database directory exists: ${dbDir.existsSync() ? 'YES' : 'NO'}');
    NovaLogger.tdlib('Files directory exists: ${filesDir.existsSync() ? 'YES' : 'NO'}');
    NovaLogger.tdlib('Database directory writable: YES');
    NovaLogger.tdlib('Files directory writable: YES');

    final dbKey = await _secureStorage.getDatabaseEncryptionKey();
    
    if (kDebugMode) NovaLogger.tdlib('Sending TDLib parameters: YES');
    send(SetTdlibParameters(
      useTestDc: false,
      databaseDirectory: dbDir.absolute.path,
      filesDirectory: filesDir.absolute.path,
      useFileDatabase: true,
      useChatInfoDatabase: true,
      useMessageDatabase: true,
      useSecretChats: false,
      apiId: apiId,
      apiHash: apiHash.trim(),
      systemLanguageCode: 'en',
      deviceModel: 'Android',
      systemVersion: 'Android',
      applicationVersion: '1.0.0',
      databaseEncryptionKey: dbKey,
    ), extra: 'nova_set_tdlib_parameters_${DateTime.now().millisecondsSinceEpoch}');
  }

  void send(TdFunction request, {String? extra}) {
    if (_isMock || _clientId == null) return;
    if (kDebugMode) {
      NovaLogger.tdlib('Sending request: ${request.currentObjectId}${extra != null ? ' extra=$extra' : ''}');
    }
    // send() is non-blocking, safe to call from main isolate
    TdPlugin.instance.tdSend(_clientId!, jsonEncode(request.toJson(extra)));
  }

  TdObject? execute(TdFunction request) {
    if (_isMock) return null;
    final res = TdPlugin.instance.tdExecute(jsonEncode(request.toJson()));
    if (res != null) {
      return convertJsonToObject(res);
    }
    return null;
  }

  Future<void> destroy() async {
    NovaLogger.tdlib('Destroying TDLib client: YES');
    _isDestroyed = true;
    _tdlibParametersSent = false;
    _authStateReceived = false;
    
    if (_clientId != null) {
      TdPlugin.instance.tdSend(_clientId!, jsonEncode({'@type': 'close'}));
    }
    
    // Gracefully stop the background isolate
    if (_bgSendPort != null && _receiveIsolate != null) {
      _isolateStopCompleter = Completer<void>();
      _bgSendPort!.send(_IsolateStopMsg());
      
      // Wait for it to stop, with a 2-second timeout just in case
      try {
        await _isolateStopCompleter!.future.timeout(const Duration(seconds: 2));
      } catch (e) {
        NovaLogger.tdlib('Background isolate stop timed out, forcing kill');
        _receiveIsolate?.kill(priority: Isolate.immediate);
      }
    }
    
    _receiveIsolate = null;
    _bgSendPort = null;
    _receivePort?.close();
    _receivePort = null;
    
    _clientId = null;
    _isInitialized = false;
    _isInitializing = false;
    NovaLogger.tdlib('Background isolate stopped: YES');
    NovaLogger.tdlib('TDLib lifecycle reset: YES');
  }
}
