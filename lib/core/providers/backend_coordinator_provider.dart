import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/nova_logger.dart';
import '../services/telegram_sync_service.dart';

enum BackendWorkPhase {
  idle,
  syncing,
  uploading,
  downloadingThumbnails,
  cleaningTrash,
  error,
}

class BackendStatus {
  final bool isSyncing;
  final bool isUploading;
  final bool isThumbnailLoading;
  final bool isTrashCleaning;
  final int uploadQueueCount;
  final int thumbnailQueueCount;
  final String? currentOperationLabel;
  final String? errorMessage;

  const BackendStatus({
    this.isSyncing = false,
    this.isUploading = false,
    this.isThumbnailLoading = false,
    this.isTrashCleaning = false,
    this.uploadQueueCount = 0,
    this.thumbnailQueueCount = 0,
    this.currentOperationLabel,
    this.errorMessage,
  });

  BackendStatus copyWith({
    bool? isSyncing,
    bool? isUploading,
    bool? isThumbnailLoading,
    bool? isTrashCleaning,
    int? uploadQueueCount,
    int? thumbnailQueueCount,
    String? currentOperationLabel,
    String? errorMessage,
  }) {
    return BackendStatus(
      isSyncing: isSyncing ?? this.isSyncing,
      isUploading: isUploading ?? this.isUploading,
      isThumbnailLoading: isThumbnailLoading ?? this.isThumbnailLoading,
      isTrashCleaning: isTrashCleaning ?? this.isTrashCleaning,
      uploadQueueCount: uploadQueueCount ?? this.uploadQueueCount,
      thumbnailQueueCount: thumbnailQueueCount ?? this.thumbnailQueueCount,
      currentOperationLabel: currentOperationLabel ?? this.currentOperationLabel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BackendStatus &&
        other.isSyncing == isSyncing &&
        other.isUploading == isUploading &&
        other.isThumbnailLoading == isThumbnailLoading &&
        other.isTrashCleaning == isTrashCleaning &&
        other.uploadQueueCount == uploadQueueCount &&
        other.thumbnailQueueCount == thumbnailQueueCount &&
        other.currentOperationLabel == currentOperationLabel &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(
        isSyncing,
        isUploading,
        isThumbnailLoading,
        isTrashCleaning,
        uploadQueueCount,
        thumbnailQueueCount,
        currentOperationLabel,
        errorMessage,
      );
}

class BackendCoordinator extends Notifier<BackendStatus> {
  int _activeTdlibListeners = 0;
  int _activeThumbnailDownloads = 0;
  DateTime? _lastSyncStartedAt;
  Timer? _statusUpdateTimer;
  BackendStatus _pendingStatus = const BackendStatus();

  static const int maxConcurrentThumbnails = 2;
  static const Duration minimumSyncInterval = Duration(seconds: 10);
  static const Duration _throttleDuration = Duration(milliseconds: 300);

  @override
  BackendStatus build() {
    NovaLogger.perf('BackendCoordinator initialized');
    ref.onDispose(() {
      _statusUpdateTimer?.cancel();
    });
    return const BackendStatus();
  }

  // --- Throttled Status Updates ---
  void _scheduleUpdate(BackendStatus newStatus) {
    _pendingStatus = newStatus;
    if (_statusUpdateTimer == null || !_statusUpdateTimer!.isActive) {
      _statusUpdateTimer = Timer(_throttleDuration, () {
        if (state != _pendingStatus) {
          state = _pendingStatus;
        }
      });
    }
  }

  void updateStatus({
    bool? isSyncing,
    bool? isUploading,
    bool? isThumbnailLoading,
    bool? isTrashCleaning,
    int? uploadQueueCount,
    int? thumbnailQueueCount,
    String? currentOperationLabel,
    String? errorMessage,
  }) {
    final newStatus = _pendingStatus.copyWith(
      isSyncing: isSyncing,
      isUploading: isUploading,
      isThumbnailLoading: isThumbnailLoading,
      isTrashCleaning: isTrashCleaning,
      uploadQueueCount: uploadQueueCount,
      thumbnailQueueCount: thumbnailQueueCount,
      currentOperationLabel: currentOperationLabel,
      errorMessage: errorMessage,
    );
    _scheduleUpdate(newStatus);
  }

  // --- Sync Guards ---
  bool canStartSync() {
    if (_pendingStatus.isSyncing) {
      NovaLogger.perf('Sync rejected: Already syncing');
      return false;
    }

    if (_lastSyncStartedAt != null) {
      final elapsed = DateTime.now().difference(_lastSyncStartedAt!);
      if (elapsed < minimumSyncInterval) {
        NovaLogger.perf('Sync rejected: Too soon since last sync');
        return false;
      }
    }

    updateStatus(isSyncing: true, currentOperationLabel: 'Syncing...');
    _lastSyncStartedAt = DateTime.now();
    return true;
  }

  void endSync() {
    updateStatus(isSyncing: false, currentOperationLabel: null);
  }

  void startBackgroundSync(int selfChatId, {bool clearLocal = false}) {
    // We get the telegram sync service through the provider
    ref.read(telegramSyncProvider).startRecoverySync(selfChatId, clearLocal: clearLocal);
  }

  // --- Thumbnail Guards ---
  bool canDownloadThumbnail() {
    if (_activeThumbnailDownloads >= maxConcurrentThumbnails) {
      return false;
    }
    _activeThumbnailDownloads++;
    updateStatus(
      isThumbnailLoading: true,
      thumbnailQueueCount: _pendingStatus.thumbnailQueueCount + 1,
    );
    return true;
  }

  void finishThumbnailDownload() {
    if (_activeThumbnailDownloads > 0) {
      _activeThumbnailDownloads--;
    }
    updateStatus(
      isThumbnailLoading: _activeThumbnailDownloads > 0,
      thumbnailQueueCount: (_pendingStatus.thumbnailQueueCount > 0) ? _pendingStatus.thumbnailQueueCount - 1 : 0,
    );
  }

  // --- Listener Guards ---
  bool registerTdlibListener() {
    if (_activeTdlibListeners > 0) {
      NovaLogger.perf('WARNING: Duplicate TDLib listener detected. Rejecting.');
      return false;
    }
    _activeTdlibListeners++;
    return true;
  }

  void unregisterTdlibListener() {
    if (_activeTdlibListeners > 0) {
      _activeTdlibListeners--;
    }
  }

  // --- Diagnostics ---
  Map<String, dynamic> getDiagnostics() {
    return {
      'isSyncing': _pendingStatus.isSyncing,
      'lastSync': _lastSyncStartedAt?.toIso8601String(),
      'activeThumbnails': _activeThumbnailDownloads,
      'activeListeners': _activeTdlibListeners,
    };
  }
}

final backendCoordinatorProvider = NotifierProvider<BackendCoordinator, BackendStatus>(() {
  return BackendCoordinator();
});
