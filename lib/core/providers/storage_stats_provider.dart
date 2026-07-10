import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_provider.dart';

class StorageStats {
  final int totalBytes;
  final int usedBytes;
  final int fileCount;
  final int folderCount;
  
  final int imageBytes;
  final int videoBytes;
  final int documentBytes;
  final int audioBytes;
  final int archiveBytes;
  final int apkBytes;
  final int otherBytes;
  
  final int offlineBytes;
  final int cloudOnlyBytes;
  
  final int failedUploadCount;
  final int activeUploadCount;

  StorageStats({
    this.totalBytes = 15 * 1024 * 1024 * 1024, // 15GB
    this.usedBytes = 0,
    this.fileCount = 0,
    this.folderCount = 0,
    this.imageBytes = 0,
    this.videoBytes = 0,
    this.documentBytes = 0,
    this.audioBytes = 0,
    this.archiveBytes = 0,
    this.apkBytes = 0,
    this.otherBytes = 0,
    this.offlineBytes = 0,
    this.cloudOnlyBytes = 0,
    this.failedUploadCount = 0,
    this.activeUploadCount = 0,
  });
}

/// Uses SQL-aggregated stats instead of loading all file rows into Dart.
/// This avoids O(n) iteration over every file on every DB change.
final storageStatsProvider = StreamProvider<StorageStats>((ref) {
  final dao = ref.watch(daoProvider);
  
  return dao.watchStorageStatsAggregated().map((row) {
    final categorizedTotal = row.imageBytes + row.videoBytes + row.audioBytes + 
        row.docBytes + row.archiveBytes + row.apkBytes;
    final otherBytes = row.totalBytes > categorizedTotal ? row.totalBytes - categorizedTotal : 0;

    return StorageStats(
      usedBytes: row.totalBytes,
      fileCount: row.activeCount,
      folderCount: row.folderCount,
      imageBytes: row.imageBytes,
      videoBytes: row.videoBytes,
      documentBytes: row.docBytes,
      audioBytes: row.audioBytes,
      archiveBytes: row.archiveBytes,
      apkBytes: row.apkBytes,
      otherBytes: otherBytes,
      offlineBytes: row.offlineBytes,
      cloudOnlyBytes: row.cloudOnlyBytes,
      failedUploadCount: row.failedCount,
      activeUploadCount: row.activeUploadCount,
    );
  });
});
