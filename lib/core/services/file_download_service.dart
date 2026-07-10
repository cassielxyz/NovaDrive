import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'telegram_storage_service.dart';
import 'nova_logger.dart';

final fileDownloadProvider = Provider<FileDownloadService>((ref) {
  return FileDownloadService(
    ref.watch(telegramStorageProvider),
  );
});

class FileDownloadService {
  final TelegramStorageService _storage;

  FileDownloadService(this._storage);

  Future<void> downloadAndOpenFile({
    required int telegramFileId,
    required String localPath,
  }) async {
    NovaLogger.file('File tapped: YES');
    final file = File(localPath);
    if (file.existsSync()) {
      NovaLogger.file('Local file exists: YES');
      NovaLogger.file('Opening file: YES');
      final result = await OpenFilex.open(localPath);
      NovaLogger.file('Open result: ${result.type == ResultType.done ? "success" : "failed"}');
    } else {
      NovaLogger.file('Local file exists: NO');
      NovaLogger.file('Starting TDLib download: YES');
      await _storage.downloadFile(telegramFileId);
      // The updateFile listener in TelegramSyncService will handle progress
      // and update the drift database when downloading is finished.
    }
  }
}
