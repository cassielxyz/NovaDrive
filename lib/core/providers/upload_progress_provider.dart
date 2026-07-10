import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FileProgressState {
  final bool isUploading;
  final bool isDownloading;
  final bool isFailed;
  final int progress;

  const FileProgressState({
    this.isUploading = false,
    this.isDownloading = false,
    this.isFailed = false,
    this.progress = 0,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FileProgressState &&
      other.isUploading == isUploading &&
      other.isDownloading == isDownloading &&
      other.isFailed == isFailed &&
      other.progress == progress;
  }

  @override
  int get hashCode => Object.hash(isUploading, isDownloading, isFailed, progress);

  FileProgressState copyWith({
    bool? isUploading,
    bool? isDownloading,
    bool? isFailed,
    int? progress,
  }) {
    return FileProgressState(
      isUploading: isUploading ?? this.isUploading,
      isDownloading: isDownloading ?? this.isDownloading,
      isFailed: isFailed ?? this.isFailed,
      progress: progress ?? this.progress,
    );
  }
}

class UploadProgressManager {
  final Map<String, ValueNotifier<FileProgressState>> _states = {};

  ValueNotifier<FileProgressState> getState(String id) {
    return _states.putIfAbsent(id, () => ValueNotifier(const FileProgressState()));
  }

  void updateState(String id, FileProgressState Function(FileProgressState) cb) {
    final notifier = getState(id);
    final newState = cb(notifier.value);
    if (notifier.value != newState) {
      notifier.value = newState;
    }
  }
}

final uploadProgressManagerProvider = Provider<UploadProgressManager>((ref) {
  return UploadProgressManager();
});
