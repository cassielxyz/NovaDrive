import 'dart:async';
import 'dart:collection';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/telegram_storage_service.dart';
import '../services/nova_logger.dart';
import 'backend_coordinator_provider.dart';

/// Manages lazy thumbnail download requests.
/// Implements a strict concurrency limit via BackendCoordinator.
class ThumbnailManager {
  final TelegramStorageService _storage;
  final BackendCoordinator _coordinator;
  
  final Set<int> _completedIds = {};
  final Set<int> _failedIds = {};
  final Set<int> _activeIds = {};
  final Queue<int> _pendingQueue = Queue<int>();
  
  Timer? _processTimer;

  ThumbnailManager(this._storage, this._coordinator);

  /// Request a thumbnail download if not already requested.
  void requestThumbnail(int telegramThumbnailId) {
    if (_completedIds.contains(telegramThumbnailId) || 
        _activeIds.contains(telegramThumbnailId) ||
        _pendingQueue.contains(telegramThumbnailId)) {
      return;
    }
    
    // We allow failed IDs to be requested again if the user scrolls back to them
    if (_failedIds.contains(telegramThumbnailId)) {
      _failedIds.remove(telegramThumbnailId);
    }
    
    _pendingQueue.add(telegramThumbnailId);
    _scheduleProcessing();
  }

  void _scheduleProcessing() {
    _processTimer?.cancel();
    // Delay slightly to batch rapidly scrolling requests and prevent main thread jank
    _processTimer = Timer(const Duration(milliseconds: 250), _processQueue);
  }

  void _processQueue() {
    if (_pendingQueue.isEmpty) return;
    
    // Attempt to start downloads until we hit the concurrent limit
    while (_pendingQueue.isNotEmpty && _coordinator.canDownloadThumbnail()) {
      final id = _pendingQueue.removeFirst();
      _activeIds.add(id);
      
      NovaLogger.file('Started thumbnail download: $id');
      _storage.downloadFile(id).catchError((e) {
        markFailed(id);
      });
    }
  }

  void markCompleted(int telegramThumbnailId) {
    if (_activeIds.remove(telegramThumbnailId)) {
      _coordinator.finishThumbnailDownload();
    }
    _completedIds.add(telegramThumbnailId);
    if (_completedIds.length > 500) {
      _completedIds.remove(_completedIds.first);
    }
    _scheduleProcessing(); // Check if we can start more
  }

  void markFailed(int telegramThumbnailId) {
    if (_activeIds.remove(telegramThumbnailId)) {
      _coordinator.finishThumbnailDownload();
    }
    _failedIds.add(telegramThumbnailId);
    if (_failedIds.length > 200) {
      _failedIds.remove(_failedIds.first);
    }
    _scheduleProcessing();
  }

  bool isRequested(int telegramThumbnailId) {
    return _activeIds.contains(telegramThumbnailId) || 
           _pendingQueue.contains(telegramThumbnailId) || 
           _completedIds.contains(telegramThumbnailId);
  }
}

final thumbnailManagerProvider = Provider<ThumbnailManager>((ref) {
  final storage = ref.watch(telegramStorageProvider);
  final coordinator = ref.read(backendCoordinatorProvider.notifier);
  return ThumbnailManager(storage, coordinator);
});
