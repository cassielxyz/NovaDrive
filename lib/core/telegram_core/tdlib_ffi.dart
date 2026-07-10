import 'dart:io';
import '../services/nova_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:handy_tdlib/handy_tdlib.dart';

class TdlibFfi {
  bool _isLoaded = false;
  
  bool get isLoaded => _isLoaded;

  /// Returns the platform-appropriate TDLib native library path.
  static String getLibraryPath() {
    if (Platform.isWindows) {
      return 'tdjson.dll';
    } else if (Platform.isAndroid || Platform.isLinux) {
      return 'libtdjson.so';
    } else if (Platform.isMacOS || Platform.isIOS) {
      return 'libtdjson.dylib';
    }
    return 'libtdjson.so'; // fallback
  }

  Future<void> initialize() async {
    if (_isLoaded) return;
    
    try {
      final libPath = getLibraryPath();
      await TdPlugin.initialize(libPath);
      _isLoaded = true;
      if (kDebugMode) {
        NovaLogger.tdlib('Native library loaded: YES');
      }
    } catch (e) {
      if (kDebugMode) {
        NovaLogger.tdlib('Native library loaded: NO');
        NovaLogger.tdlib('Failed to load TDLib native library: $e');
      }
      rethrow;
    }
  }

  int createClientId() {
    if (!_isLoaded) {
      throw StateError('TDLib is not initialized');
    }
    return TdPlugin.instance.tdCreateClientId();
  }

  void send(int clientId, String request) {
    TdPlugin.instance.tdSend(clientId, request);
  }

  String? receive([double timeout = 1.0]) {
    return TdPlugin.instance.tdReceive(timeout);
  }

  String? execute(String request) {
    return TdPlugin.instance.tdExecute(request);
  }
}
