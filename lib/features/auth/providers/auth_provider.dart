
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handy_tdlib/handy_tdlib.dart';
import '../../../core/telegram_core/tdlib_bridge.dart';
import '../../../core/services/nova_logger.dart';
import '../../../core/services/secure_storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

enum AuthStep { loading, phone, code, password, ready, error }

class AuthState {
  final AuthStep step;
  final String? error;
  final bool isProcessing;

  AuthState({
    this.step = AuthStep.loading, 
    this.error,
    this.isProcessing = false,
  });

  AuthState copyWith({AuthStep? step, String? error, bool? isProcessing}) {
    return AuthState(
      step: step ?? this.step,
      error: error ?? this.error,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<AuthState> {
  late final TdlibBridge _bridge;
  StreamSubscription<TdObject>? _updateSub;

  @override
  AuthState build() {
    _bridge = ref.read(tdlibBridgeProvider);
    _updateSub?.cancel();
    _updateSub = _bridge.updates.listen(_onUpdate);
    
    ref.onDispose(() {
      _updateSub?.cancel();
      _updateSub = null;
    });
    
    // Request current auth state in case we missed the broadcast during bootstrap
    Future.microtask(() async {
      int attempts = 0;
      while (!_bridge.isReady && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }
      if (_bridge.isReady) {
        _bridge.send(GetAuthorizationState());
      }
    });
    
    // Loading timeout — if we're still in loading after 12s, something is wrong
    Future.delayed(const Duration(seconds: 12), () {
      if (state.step == AuthStep.loading) {
        NovaLogger.tdlib('Auth loading timeout — check credentials');
        state = AuthState(
          step: AuthStep.error,
          error: 'Could not connect to Telegram.\nPlease check your API credentials and network connection.',
          isProcessing: false,
        );
      }
    });
    
    return AuthState(step: AuthStep.loading);
  }

  void _onUpdate(TdObject object) {
    if (object is UpdateAuthorizationState) {
      final authState = object.authorizationState;
      
      if (authState is AuthorizationStateWaitPhoneNumber) {
        if (kDebugMode) NovaLogger.tdlib('Phone number requested');
        state = AuthState(step: AuthStep.phone, isProcessing: false);
      } else if (authState is AuthorizationStateWaitCode) {
        if (kDebugMode) NovaLogger.tdlib('Code requested');
        state = AuthState(step: AuthStep.code, isProcessing: false);
      } else if (authState is AuthorizationStateWaitPassword) {
        if (kDebugMode) NovaLogger.tdlib('Password requested');
        state = AuthState(step: AuthStep.password, isProcessing: false);
      } else if (authState is AuthorizationStateReady) {
        if (kDebugMode) NovaLogger.tdlib('Authorization ready');
        state = AuthState(step: AuthStep.ready, isProcessing: false);
      }
    } else if (object is AuthorizationState) {
      if (object is AuthorizationStateWaitPhoneNumber) {
        if (kDebugMode) NovaLogger.tdlib('Phone number requested');
        state = AuthState(step: AuthStep.phone, isProcessing: false);
      } else if (object is AuthorizationStateWaitCode) {
        if (kDebugMode) NovaLogger.tdlib('Code requested');
        state = AuthState(step: AuthStep.code, isProcessing: false);
      } else if (object is AuthorizationStateWaitPassword) {
        if (kDebugMode) NovaLogger.tdlib('Password requested');
        state = AuthState(step: AuthStep.password, isProcessing: false);
      } else if (object is AuthorizationStateReady) {
        if (kDebugMode) NovaLogger.tdlib('Authorization ready');
        state = AuthState(step: AuthStep.ready, isProcessing: false);
      }
    } else if (object is TdError) {
      if (object.code == 408) {
        state = AuthState(step: AuthStep.error, error: 'Could not start Telegram authorization.', isProcessing: false);
      } else {
        state = AuthState(step: AuthStep.error, error: object.message, isProcessing: false);
      }
    } else if (object is Ok) {
       // Do nothing, wait for UpdateAuthorizationState
    }
    // Ignore all other TDLib updates (UpdateOption, UpdateConnectionState, etc.)
    // They are not auth-related and must not interfere with auth flow.
  }

  void retryBootstrap() {
    NovaLogger.tdlib('Retry authorization bootstrap');
    state = AuthState(step: AuthStep.loading);
    _bridge.destroy().then((_) {
      _bridge.initialize();
    });
  }

  void resetSession() {
    NovaLogger.tdlib('Reset TDLib Session');
    state = AuthState(step: AuthStep.loading);
    _bridge.destroy().then((_) async {
      try {
        await ref.read(secureStorageProvider).clearDatabaseEncryptionKey();
        final docDir = await getApplicationDocumentsDirectory();
        final dbDir = Directory(p.join(docDir.path, 'tdlib'));
        if (dbDir.existsSync()) {
          dbDir.deleteSync(recursive: true);
        }
      } catch (e) {
        NovaLogger.tdlib('Error deleting TDLib database directory: $e');
      }
      _bridge.initialize();
    });
  }

  void sendPhoneNumber(String phoneNumber) {
    state = state.copyWith(error: null, isProcessing: true);
    _bridge.send(SetAuthenticationPhoneNumber(
      phoneNumber: phoneNumber,
      settings: PhoneNumberAuthenticationSettings(
        allowFlashCall: false,
        isCurrentPhoneNumber: false,
        allowSmsRetrieverApi: false,
        allowMissedCall: false,
        authenticationTokens: [],
        hasUnknownPhoneNumber: false,
      ),
    ));

    // Add a timeout to prevent infinite loading if the proxy is dead or network is blocked
    Future.delayed(const Duration(seconds: 8), () {
      if (state.isProcessing && state.step == AuthStep.phone) {
        state = state.copyWith(
          isProcessing: false,
          error: 'Connection timed out. Telegram is unreachable. Please check your network.',
        );
      }
    });
  }

  void sendCode(String code) {
    state = state.copyWith(error: null, isProcessing: true);
    _bridge.send(CheckAuthenticationCode(code: code));
  }

  void sendPassword(String password) {
    state = state.copyWith(error: null, isProcessing: true);
    _bridge.send(CheckAuthenticationPassword(password: password));
  }
}
