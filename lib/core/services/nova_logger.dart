import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class NovaLogger {
  static void route(String message) {
    _log('NOVA_ROUTE', message);
  }

  static void tdlib(String message) {
    _log('NOVA_TDLIB', message);
  }

  static void upload(String message) {
    _log('NOVA_UPLOAD', message);
  }

  static void file(String message) {
    _log('NOVA_FILE', message);
  }

  static void sync(String message) {
    _log('NOVA_SYNC', message);
  }

  static void ui(String message) {
    _log('NOVA_UI', message);
  }

  static void db(String message) {
    _log('NOVA_DB', message);
  }

  static void security(String message) {
    _log('NOVA_SECURITY', message);
  }

  static void community(String message) {
    _log('NOVA_COMMUNITY', message);
  }

  static void perf(String message) {
    _log('NOVA_PERF', message);
  }

  static void error(String name, String message) {
    _log(name, 'ERROR: $message');
  }

  static final StreamController<Map<String, String>> _logStreamController = StreamController.broadcast();
  static Stream<Map<String, String>> get logStream => _logStreamController.stream;

  static void _log(String name, String message) {
    developer.log(message, name: name);

    if (kDebugMode) {
      debugPrint('[$name] $message');
    }
    
    // Broadcast to the ring buffer (throttled dev tools)
    _logStreamController.add({'tag': name, 'message': message});
  }

  /// Debug-only performance measurement for synchronous blocks.
  /// In release builds, just runs the block without timing.
  static T measureDebugTime<T>(String label, T Function() block) {
    if (kDebugMode) {
      final stopwatch = Stopwatch()..start();
      final result = block();
      stopwatch.stop();
      perf('$label took ${stopwatch.elapsedMilliseconds}ms');
      return result;
    } else {
      return block();
    }
  }

  /// Debug-only performance measurement for async blocks.
  static Future<T> measureDebugTimeAsync<T>(String label, Future<T> Function() block) async {
    if (kDebugMode) {
      final stopwatch = Stopwatch()..start();
      final result = await block();
      stopwatch.stop();
      perf('$label took ${stopwatch.elapsedMilliseconds}ms');
      return result;
    } else {
      return block();
    }
  }
}

