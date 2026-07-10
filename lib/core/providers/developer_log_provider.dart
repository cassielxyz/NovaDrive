import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/nova_logger.dart';

class DeveloperLogEntry {
  final DateTime timestamp;
  final String tag;
  final String message;

  DeveloperLogEntry(this.tag, this.message) : timestamp = DateTime.now();
}

class DeveloperLogNotifier extends Notifier<List<DeveloperLogEntry>> {
  static const int maxLogs = 200;
  final List<DeveloperLogEntry> _buffer = [];
  Timer? _throttleTimer;
  bool _hasPendingUpdates = false;
  StreamSubscription? _logSub;

  @override
  List<DeveloperLogEntry> build() {
    ref.onDispose(() {
      _logSub?.cancel();
      _throttleTimer?.cancel();
    });
    
    _logSub = NovaLogger.logStream.listen((data) {
      addLog(data['tag']!, data['message']!);
    });
    return [];
  }

  void addLog(String tag, String message) {
    _buffer.insert(0, DeveloperLogEntry(tag, message));
    if (_buffer.length > maxLogs) {
      _buffer.removeLast();
    }
    
    _hasPendingUpdates = true;
    _scheduleUpdate();
  }

  void clearLogs() {
    _buffer.clear();
    state = [];
  }

  void _scheduleUpdate() {
    if (_throttleTimer != null && _throttleTimer!.isActive) {
      return;
    }
    // Throttle updates to max once per second
    _throttleTimer = Timer(const Duration(seconds: 1), () {
      if (_hasPendingUpdates) {
        state = List.from(_buffer);
        _hasPendingUpdates = false;
      }
    });
  }
}

// Global provider so it maintains state and buffer even if Dev screen is closed
final developerLogProvider = NotifierProvider<DeveloperLogNotifier, List<DeveloperLogEntry>>(() {
  return DeveloperLogNotifier();
});
