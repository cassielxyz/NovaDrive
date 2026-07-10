import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handy_tdlib/handy_tdlib.dart';
import '../telegram_core/tdlib_bridge.dart';
import '../database/database_provider.dart';
import 'nova_logger.dart';
import '../database/daos.dart';
import '../database/database.dart';
import '../providers/upload_progress_provider.dart';
import '../providers/backend_coordinator_provider.dart';
import '../providers/thumbnail_provider.dart';

Map<String, dynamic>? _parseMetadata(String text) {
  try {
    final lines = text.split('\n');
    if (lines.length > 1 && lines[0].trim() == '#novadrive') {
      final jsonStr = lines.sublist(1).join('\n');
      return jsonDecode(jsonStr);
    }
  } catch (_) {}
  return null;
}

List<Map<String, dynamic>?> _parseMetadataBatch(List<String> texts) {
  return texts.map((t) => _parseMetadata(t)).toList();
}

final telegramSyncProvider = Provider<TelegramSyncService>((ref) {
  final service = TelegramSyncService(
    ref.watch(tdlibBridgeProvider),
    ref.watch(daoProvider),
    ref.read(thumbnailManagerProvider),
    ref,
  );
  ref.onDispose(service.dispose);
  return service;
});

class TelegramSyncService {
  final TdlibBridge _bridge;
  late final AppDao _dao;
  final ThumbnailManager _thumbnailManager;
  final Ref _ref;
  StreamSubscription? _updateSub;

  // --- Progress throttling state ---
  // Tracks last written progress per file to avoid excessive DB writes.
  final Map<String, int> _lastWrittenProgress = {};
  final Map<String, DateTime> _lastProgressWriteTime = {};

  TelegramSyncService(this._bridge, AppDao dao, this._thumbnailManager, this._ref) {
    _dao = dao;
    _startListening();
  }

  void _startListening() {
    if (!_ref.read(backendCoordinatorProvider.notifier).registerTdlibListener()) {
      return;
    }
    _updateSub = _bridge.updates.listen((object) {
      if (object is UpdateNewMessage) {
        _handleNewMessage(object.message);
      } else if (object is UpdateMessageSendSucceeded) {
        _handleMessageSendSucceeded(object.message, object.oldMessageId);
      } else if (object is UpdateMessageSendFailed) {
        _handleMessageSendFailed(object.message, object.error);
      } else if (object is Messages) {
        _handleChatHistory(object.messages);
      } else if (object is UpdateDeleteMessages) {
        _handleMessagesDeleted(object.messageIds);
      } else if (object is UpdateFile) {
        _handleUpdateFile(object.file);
      }
    });
  }

  Future<void> startRecoverySync(int selfChatId, {bool clearLocal = false}) async {
    final coordinator = _ref.read(backendCoordinatorProvider.notifier);
    if (!coordinator.canStartSync()) {
      return;
    }
    try {
      NovaLogger.sync('Self chat resolved: YES');
      if (clearLocal) {
        NovaLogger.db('Rebuild index requested by user: YES');
        await _dao.deleteAllFiles();
        NovaLogger.db('Local Files table cleared: YES');
        await _dao.deleteAllUploadTasks();
        NovaLogger.db('Local UploadTasks table cleared: YES');
        NovaLogger.sync('Rebuilding Nova Drive index: YES');
      }

      NovaLogger.sync('GetChatHistory started: YES');
      _bridge.send(GetChatHistory(
        chatId: selfChatId,
        fromMessageId: 0,
        offset: 0,
        limit: 100,
        onlyLocal: false,
      ));
    } finally {
      // For now we release the lock after a safe delay
      Future.delayed(const Duration(seconds: 3), () {
        coordinator.endSync();
      });
    }
  }

  Future<void> _handleMessagesDeleted(List<int> messageIds) async {
    for (final id in messageIds) {
      final file = await _dao.getFileByTelegramMessageId(id);
      if (file != null) {
        NovaLogger.sync('Remote delete detected for message $id, creating tombstone');
        await _dao.insertTombstone(Tombstone(
          telegramMessageId: id,
          telegramChatId: null,
          telegramFileId: file.telegramFileId,
          telegramRemoteId: file.telegramRemoteId,
          deletedAt: DateTime.now(),
          deleteStatus: 'permanently_deleted',
        ));
        await _dao.deleteFile(file.id);
      }
    }
  }

  /// Extract file metadata from a message, shared between _handleChatHistory and _handleNewMessage.
  _MessageFileInfo? _extractFileInfo(Message msg) {
    String caption = '';
    File? telegramFile;
    String fileName = 'Unknown';
    int size = 0;
    String mimeType = 'application/octet-stream';
    Thumbnail? thumbnail;

    if (msg.content is MessageDocument) {
      final doc = msg.content as MessageDocument;
      caption = doc.caption.text;
      telegramFile = doc.document.document;
      fileName = doc.document.fileName;
      size = doc.document.document.size;
      mimeType = doc.document.mimeType;
      thumbnail = doc.document.thumbnail;
    } else if (msg.content is MessageVideo) {
      final video = msg.content as MessageVideo;
      caption = video.caption.text;
      telegramFile = video.video.video;
      fileName = video.video.fileName;
      size = video.video.video.size;
      mimeType = video.video.mimeType;
      thumbnail = video.video.thumbnail;
    } else if (msg.content is MessagePhoto) {
      final photo = msg.content as MessagePhoto;
      caption = photo.caption.text;
      final largest = photo.photo.sizes.reduce((a, b) => a.width > b.width ? a : b);
      final smallest = photo.photo.sizes.reduce((a, b) => a.width < b.width ? a : b);
      telegramFile = largest.photo;
      fileName = 'photo_${msg.id}.jpg';
      size = largest.photo.size;
      mimeType = 'image/jpeg';
      thumbnail = Thumbnail(
        format: const ThumbnailFormatJpeg(),
        width: smallest.width,
        height: smallest.height,
        file: smallest.photo,
      );
    } else {
      return null;
    }

    return _MessageFileInfo(
      caption: caption,
      telegramFile: telegramFile,
      fileName: fileName,
      size: size,
      mimeType: mimeType,
      thumbnail: thumbnail,
    );
  }

  Future<void> _handleChatHistory(List<Message> messages) async {
    // 1. Extract all text strings for batch parsing
    final textStrings = messages.map((m) {
      if (m.content is MessageText) return (m.content as MessageText).text.text;
      if (m.content is MessageDocument) return (m.content as MessageDocument).caption.text;
      if (m.content is MessagePhoto) return (m.content as MessagePhoto).caption.text;
      if (m.content is MessageVideo) return (m.content as MessageVideo).caption.text;
      return '';
    }).toList();

    // 2. Compute metadata batch in isolate
    final metadataBatch = await compute(_parseMetadataBatch, textStrings);

    for (int i = 0; i < messages.length; i++) {
      final msg = messages[i];
      final metadata = metadataBatch[i];

      if (msg.content is MessageText) {
        if (metadata != null && metadata['type'] == 'folder') {
          try {
            final existingFolder = await _dao.getFolderById(metadata['folderId']);
            await _dao.insertFolder(Folder(
              id: metadata['folderId'],
              accountId: msg.chatId,
              name: metadata['name'],
              parentFolderId: metadata['parentFolderId'],
              createdAt: DateTime.tryParse(metadata['createdAt'] ?? '') ?? DateTime.now(),
              updatedAt: DateTime.tryParse(metadata['updatedAt'] ?? '') ?? DateTime.now(),
              isDeleted: existingFolder?.isDeleted ?? false,
              deletedAt: existingFolder?.deletedAt,
              sortOrder: existingFolder?.sortOrder ?? 0,
              telegramMessageId: msg.id,
            ));
            NovaLogger.sync('Inserted/Updated Nova Drive folder in Drift: YES');
          } catch (_) {}
        }
      } else if (msg.content is MessageDocument || msg.content is MessageVideo || msg.content is MessagePhoto) {
        final info = _extractFileInfo(msg);
        if (info == null) continue;
        
        if (metadata == null && !info.caption.contains('#novadrive')) {
          NovaLogger.sync('Message ignored: missing #novadrive');
          continue;
        }

        final isTombstoned = await _dao.isTombstoned(msg.id);
        if (isTombstoned) {
          NovaLogger.sync('Skipping tombstoned file: ${info.fileName}');
          continue;
        }

        NovaLogger.sync('Nova Drive file found: YES');

        final localId = metadata?['localId'];
        
        StorageFile? existingFile;
        if (localId != null) {
          existingFile = await _dao.getFileById(localId);
        }
        existingFile ??= await _dao.getFileByTelegramMessageId(msg.id);

        final isDownloaded = info.telegramFile!.local.isDownloadingCompleted && info.telegramFile!.local.path.isNotEmpty;
        final newFile = StorageFile(
          id: existingFile?.id ?? msg.id.toString(),
          telegramMessageId: msg.id,
          telegramFileId: info.telegramFile!.id,
          telegramRemoteId: info.telegramFile!.remote.id,
          name: existingFile?.name ?? info.fileName,
          size: info.size,
          mimeType: info.mimeType,
          path: info.telegramFile!.local.path,
          localPath: isDownloaded ? info.telegramFile!.local.path : existingFile?.localPath,
          telegramThumbnailId: info.thumbnail?.file.id,
          thumbnailLocalPath: (info.thumbnail?.file.local.isDownloadingCompleted ?? false) && (info.thumbnail?.file.local.path.isNotEmpty ?? false)
              ? info.thumbnail?.file.local.path 
              : existingFile?.thumbnailLocalPath,
          createdAt: DateTime.fromMillisecondsSinceEpoch(msg.date * 1000),
          updatedAt: DateTime.fromMillisecondsSinceEpoch(msg.date * 1000),
          syncStatus: 'synced',
          downloadStatus: isDownloaded ? 'downloaded' : (existingFile?.downloadStatus ?? 'remoteOnly'),
          folderId: metadata?['folderId'] ?? existingFile?.folderId,
          isFavorite: existingFile?.isFavorite ?? false,
          isDeleted: existingFile?.isDeleted ?? false,
          lastOpenedAt: existingFile?.lastOpenedAt,
          deletedAt: existingFile?.deletedAt,
        );

        if (existingFile != null) {
          await _dao.updateFile(newFile);
          NovaLogger.sync('Updated existing Nova Drive file during sync: ${newFile.id}');
        } else {
          try {
            await _dao.insertFile(newFile);
            NovaLogger.sync('Inserted Nova Drive file into Drift: YES');
          } catch (_) {
            // Recover thumbnail if missing
            final existing = await _dao.getFileByTelegramMessageId(msg.id);
            if (existing != null && existing.telegramThumbnailId == null && info.thumbnail?.file.id != null) {
              await _dao.updateFile(existing.copyWith(
                telegramThumbnailId: drift.Value(info.thumbnail!.file.id),
                thumbnailLocalPath: (info.thumbnail!.file.local.isDownloadingCompleted) && info.thumbnail!.file.local.path.isNotEmpty 
                    ? drift.Value(info.thumbnail!.file.local.path)
                    : const drift.Value.absent(),
              ));
              NovaLogger.sync('Recovered thumbnail for existing file during sync: ${info.fileName}');
            }
          }
        }
      }
    }
    NovaLogger.sync('Sync completed: YES');
  }

  Future<void> _handleNewMessage(Message msg) async {
    if (msg.content is MessageText) {
      final text = (msg.content as MessageText).text.text;
      final metadata = _parseMetadata(text);
      if (metadata != null && metadata['type'] == 'folder') {
        try {
          final existingFolder = await _dao.getFolderById(metadata['folderId']);
          await _dao.insertFolder(Folder(
            id: metadata['folderId'],
            accountId: msg.chatId,
            name: metadata['name'],
            parentFolderId: metadata['parentFolderId'],
            createdAt: DateTime.tryParse(metadata['createdAt'] ?? '') ?? DateTime.now(),
            updatedAt: DateTime.tryParse(metadata['updatedAt'] ?? '') ?? DateTime.now(),
            isDeleted: existingFolder?.isDeleted ?? false,
            deletedAt: existingFolder?.deletedAt,
            sortOrder: existingFolder?.sortOrder ?? 0,
            telegramMessageId: msg.id,
          ));
          NovaLogger.sync('Inserted/Updated Nova Drive folder in Drift: YES');
        } catch (_) {}
      }
    } else if (msg.content is MessageDocument || msg.content is MessageVideo || msg.content is MessagePhoto) {
      final info = _extractFileInfo(msg);
      if (info == null) return;
      
      final metadata = _parseMetadata(info.caption);
      if (metadata == null && !info.caption.contains('#novadrive')) return;
      
      final isTombstoned = await _dao.isTombstoned(msg.id);
      if (isTombstoned) {
        NovaLogger.sync('Skipping tombstoned file: ${info.fileName}');
        return;
      }
      
      NovaLogger.tdlib('updateNewMessage received');
      
      final localId = metadata?['localId'];
      
      StorageFile? existingFile;
      if (localId != null) {
        existingFile = await _dao.getFileById(localId);
      }
      existingFile ??= await _dao.getFileByTelegramMessageId(msg.id);

      final isUploading = msg.sendingState != null;
      final isDownloaded = info.telegramFile!.local.isDownloadingCompleted && info.telegramFile!.local.path.isNotEmpty;
      
      final newFile = StorageFile(
        id: existingFile?.id ?? msg.id.toString(),
        telegramMessageId: msg.id,
        telegramFileId: info.telegramFile!.id,
        telegramRemoteId: info.telegramFile!.remote.id,
        name: existingFile?.name ?? info.fileName,
        size: info.size,
        mimeType: info.mimeType,
        path: info.telegramFile!.local.path,
        localPath: isDownloaded ? info.telegramFile!.local.path : existingFile?.localPath,
        telegramThumbnailId: info.thumbnail?.file.id,
        thumbnailLocalPath: (info.thumbnail?.file.local.isDownloadingCompleted ?? false) && (info.thumbnail?.file.local.path.isNotEmpty ?? false)
            ? info.thumbnail?.file.local.path 
            : existingFile?.thumbnailLocalPath,
        createdAt: DateTime.fromMillisecondsSinceEpoch(msg.date * 1000),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(msg.date * 1000),
        syncStatus: isUploading ? 'uploading' : 'synced',
        downloadStatus: isDownloaded ? 'downloaded' : (existingFile?.downloadStatus ?? 'remoteOnly'),
        folderId: metadata?['folderId'] ?? existingFile?.folderId,
        isFavorite: existingFile?.isFavorite ?? false,
        isDeleted: existingFile?.isDeleted ?? false,
        lastOpenedAt: existingFile?.lastOpenedAt,
        deletedAt: existingFile?.deletedAt,
      );

      if (existingFile != null) {
        await _dao.updateFile(newFile);
        NovaLogger.upload('Updated local file row: YES');
        if (isUploading) {
          await _dao.updateUploadTask(UploadTask(
            id: 'task_${newFile.id}',
            fileId: newFile.id,
            progress: 0,
            status: 'uploading',
          ));
        }
      } else {
        try {
          await _dao.insertFile(newFile);
          NovaLogger.upload('Local file row created: YES');

          if (isUploading) {
            await _dao.insertUploadTask(UploadTask(
              id: 'task_${msg.id}',
              fileId: msg.id.toString(),
              progress: 0,
              status: 'uploading',
            ));
          }
        } catch (_) {
          final existing = await _dao.getFileByTelegramMessageId(msg.id);
          if (existing != null && existing.telegramThumbnailId == null && info.thumbnail?.file.id != null) {
            await _dao.updateFile(existing.copyWith(
              telegramThumbnailId: drift.Value(info.thumbnail!.file.id),
              thumbnailLocalPath: (info.thumbnail!.file.local.isDownloadingCompleted) && info.thumbnail!.file.local.path.isNotEmpty 
                  ? drift.Value(info.thumbnail!.file.local.path)
                  : const drift.Value.absent(),
            ));
            NovaLogger.sync('Recovered thumbnail for existing file: ${info.fileName}');
          }
        }
      }
    }
  }

  /// Handles file upload/download progress updates with throttling.
  /// Updates in-memory provider immediately, but writes to Drift only at milestones.
  Future<void> _handleUpdateFile(File file) async {
    NovaLogger.tdlib('updateFile received');
    final existingFile = await _dao.getFileByTelegramFileId(file.id);
    if (existingFile != null) {
      if (file.remote.isUploadingActive) {
        final progress = file.expectedSize > 0 
            ? (file.remote.uploadedSize / file.expectedSize * 100).toInt()
            : 0;
        
        _ref.read(uploadProgressManagerProvider).updateState(existingFile.id, (state) => state.copyWith(
          isUploading: true,
          progress: progress,
        ));

        // --- Drift write only at milestones ---
        if (_shouldWriteProgress(existingFile.id, progress)) {
          NovaLogger.upload('Upload progress DB milestone: $progress%');
          await _dao.updateUploadTask(UploadTask(
            id: 'task_${existingFile.id}',
            fileId: existingFile.id,
            progress: progress,
            status: 'uploading',
          ));
        }
      } else if (file.local.isDownloadingActive) {
        final progress = file.expectedSize > 0 
            ? (file.local.downloadedSize / file.expectedSize * 100).toInt()
            : 0;
        
        _ref.read(uploadProgressManagerProvider).updateState(existingFile.id, (state) => state.copyWith(
          isDownloading: true,
          progress: progress,
        ));

        // --- Drift write only at milestones ---
        if (_shouldWriteProgress('dl_${existingFile.id}', progress)) {
          NovaLogger.file('Download progress DB milestone: $progress%');
          await _dao.updateUploadTask(UploadTask(
            id: 'task_${existingFile.id}',
            fileId: existingFile.id,
            progress: progress,
            status: 'downloading',
          ));
        }
      }
      
      // Update file path if download completed (always write this immediately)
      if (file.local.isDownloadingCompleted && existingFile.localPath != file.local.path) {
        await _dao.updateFile(existingFile.copyWith(
          path: file.local.path,
          localPath: drift.Value(file.local.path),
          downloadStatus: 'downloaded',
        ));
        NovaLogger.file('Download completed: YES');
        await _dao.deleteUploadTask('task_${existingFile.id}');
        
        _ref.read(uploadProgressManagerProvider).updateState(existingFile.id, (state) => state.copyWith(
          isDownloading: false,
          progress: 100,
        ));

        // Clean up throttle state
        _lastWrittenProgress.remove(existingFile.id);
        _lastWrittenProgress.remove('dl_${existingFile.id}');
        _lastProgressWriteTime.remove(existingFile.id);
        _lastProgressWriteTime.remove('dl_${existingFile.id}');
      }
    } else {
      final thumbnailFile = await _dao.getFileByTelegramThumbnailId(file.id);
      if (thumbnailFile != null && file.local.isDownloadingCompleted && file.local.path.isNotEmpty) {
        await _dao.updateFile(thumbnailFile.copyWith(
          thumbnailLocalPath: drift.Value(file.local.path),
        ));
        NovaLogger.file('Thumbnail download completed: YES');
        _thumbnailManager.markCompleted(file.id);
      } else if (file.local.isDownloadingCompleted == false && file.local.downloadedSize == 0 && file.expectedSize == 0) {
         // It might be failing continuously
         _thumbnailManager.markFailed(file.id);
      }
    }
  }

  /// Returns true if we should write this progress value to the database.
  /// Only returns true at milestones: started (0-1%), 25%, 50%, 75%, 100%.
  bool _shouldWriteProgress(String fileId, int progress) {
    final lastProgress = _lastWrittenProgress[fileId];

    // Always write first update or completion (100%)
    if (lastProgress == null || progress >= 100) {
      _lastWrittenProgress[fileId] = progress;
      return true;
    }

    int getMilestone(int p) {
      if (p >= 75) return 75;
      if (p >= 50) return 50;
      if (p >= 25) return 25;
      return 0;
    }

    final currentMilestone = getMilestone(progress);
    final lastMilestone = getMilestone(lastProgress);

    if (currentMilestone > lastMilestone) {
      _lastWrittenProgress[fileId] = progress;
      return true;
    }

    return false;
  }

  Future<void> _handleMessageSendSucceeded(Message message, int oldMessageId) async {
    NovaLogger.tdlib('updateMessageSendSucceeded received');
    final existingFile = await _dao.getFileByTelegramMessageId(oldMessageId);
    
    if (existingFile != null) {
      NovaLogger.upload('telegramMessageId updated from $oldMessageId to ${message.id}: YES');
      await _dao.updateFile(existingFile.copyWith(
        telegramMessageId: drift.Value(message.id),
        syncStatus: 'synced',
      ));
      await _dao.updateUploadTask(UploadTask(
        id: 'task_${existingFile.id}',
        fileId: existingFile.id,
        progress: 100,
        status: 'completed',
      ));
      
      // Clean up throttle state
      _lastWrittenProgress.remove(existingFile.id);
      _lastProgressWriteTime.remove(existingFile.id);
      
      _ref.read(uploadProgressManagerProvider).updateState(existingFile.id, (state) => state.copyWith(
        isUploading: false,
        progress: 100,
      ));
    }
    
    // Process the final message to create the permanent row with thumbnail and final TDLib IDs
    await _handleNewMessage(message);
  }

  Future<void> _handleMessageSendFailed(Message message, TdError error) async {
    NovaLogger.tdlib('updateMessageSendFailed received: ${error.message}');
    final existingFile = await _dao.getFileByTelegramMessageId(message.id);
    if (existingFile != null) {
      await _dao.updateFile(existingFile.copyWith(syncStatus: 'failed'));
      await _dao.updateUploadTask(UploadTask(
        id: 'task_${existingFile.id}',
        fileId: existingFile.id,
        progress: 0,
        status: 'failed',
      ));
      // Clean up throttle state
      _lastWrittenProgress.remove(existingFile.id);
      _lastProgressWriteTime.remove(existingFile.id);
      
      _ref.read(uploadProgressManagerProvider).updateState(existingFile.id, (state) => state.copyWith(
        isFailed: true,
      ));
    }
  }

  void dispose() {
    _updateSub?.cancel();
    _ref.read(backendCoordinatorProvider.notifier).unregisterTdlibListener();
    _lastWrittenProgress.clear();
    _lastProgressWriteTime.clear();
  }
}

/// Internal helper class to avoid duplicating file extraction logic.
class _MessageFileInfo {
  final String caption;
  final File? telegramFile;
  final String fileName;
  final int size;
  final String mimeType;
  final Thumbnail? thumbnail;

  _MessageFileInfo({
    required this.caption,
    required this.telegramFile,
    required this.fileName,
    required this.size,
    required this.mimeType,
    required this.thumbnail,
  });
}
