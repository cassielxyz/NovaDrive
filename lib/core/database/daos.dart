import 'package:drift/drift.dart';
import 'database.dart';

part 'daos.g.dart';

@DriftAccessor(tables: [Files, Folders, Tags, FileTags, UploadTasks, Tombstones])
class AppDao extends DatabaseAccessor<AppDatabase> with _$AppDaoMixin {
  AppDao(super.db);

  // --- Folders ---
  Future<void> insertFolder(Folder folder) => into(folders).insert(folder);
  Future<void> updateFolder(Folder folder) => update(folders).replace(folder);
  
  Stream<List<Folder>> watchFoldersByParent(String? parentId, int accountId) {
    return (select(folders)
      ..where((f) => f.accountId.equals(accountId))
      ..where((f) => f.isDeleted.equals(false))
      ..where((f) => parentId == null ? f.parentFolderId.isNull() : f.parentFolderId.equals(parentId))
      ..orderBy([(f) => OrderingTerm(expression: f.name)])
    ).watch();
  }

  Stream<List<Folder>> watchFoldersByParentNoAccount(String? parentId) {
    return (select(folders)
      ..where((f) => f.isDeleted.equals(false))
      ..where((f) => parentId == null ? f.parentFolderId.isNull() : f.parentFolderId.equals(parentId))
      ..orderBy([(f) => OrderingTerm(expression: f.name)])
    ).watch();
  }

  Future<Folder?> getFolderById(String id) {
    return (select(folders)..where((f) => f.id.equals(id))).getSingleOrNull();
  }

  Future<void> deleteFolder(String id) => (delete(folders)..where((f) => f.id.equals(id))).go();

  Stream<List<Folder>> watchAllFolders() {
    return (select(folders)..where((f) => f.isDeleted.equals(false))).watch();
  }

  Future<List<Folder>> getFolderHierarchy(String folderId) async {
    final hierarchy = <Folder>[];
    String? currentId = folderId;
    while (currentId != null) {
      final folder = await getFolderById(currentId);
      if (folder == null) break;
      hierarchy.insert(0, folder);
      currentId = folder.parentFolderId;
    }
    return hierarchy;
  }

  // --- Files ---
  Future<List<StorageFile>> getAllFiles() => select(files).get();
  
  Stream<List<StorageFile>> watchAllFiles() => select(files).watch();

  // --- Trash ---
  Future<void> moveToTrash(String id, bool isFolder) async {
    final now = DateTime.now();
    await _recursiveTrash(id, isFolder, true, now);
  }

  Future<void> restoreFromTrash(String id, bool isFolder) async {
    // Instead of complex deletedAt matching without schema change, let's just restore descendants blindly if they are deleted.
    // The user suggested using `deletedAt` but since folders lack `deletedAt`, I will just recursively restore them.
    await _recursiveTrash(id, isFolder, false, null);
  }

  Future<void> _recursiveTrash(String id, bool isFolder, bool isDeleted, DateTime? deletedAtTime) async {
    if (isFolder) {
      final folder = await (select(folders)..where((f) => f.id.equals(id))).getSingleOrNull();
      if (folder != null) {
        await updateFolder(folder.copyWith(isDeleted: isDeleted, updatedAt: deletedAtTime ?? DateTime.now()));
        
        // Find children
        final childFiles = await (select(files)..where((f) => f.folderId.equals(id))).get();
        for (final child in childFiles) {
          await updateFile(child.copyWith(
            isDeleted: isDeleted,
            deletedAt: isDeleted ? Value(deletedAtTime) : const Value.absent(),
          ));
        }

        final childFolders = await (select(folders)..where((f) => f.parentFolderId.equals(id))).get();
        for (final child in childFolders) {
          await _recursiveTrash(child.id, true, isDeleted, deletedAtTime);
        }
      }
    } else {
      final file = await getFileById(id);
      if (file != null) {
        await updateFile(file.copyWith(
          isDeleted: isDeleted,
          deletedAt: isDeleted ? Value(deletedAtTime) : const Value.absent(),
        ));
      }
    }
  }

  Future<List<int>> recursiveGetFolderMessageIds(String folderId) async {
    final messageIds = <int>[];
    await _collectFolderMessageIds(folderId, messageIds);
    return messageIds;
  }

  Future<void> _collectFolderMessageIds(String folderId, List<int> messageIds) async {
    final folder = await getFolderById(folderId);
    if (folder != null && folder.telegramMessageId != null) {
      messageIds.add(folder.telegramMessageId!);
    }

    final childFiles = await (select(files)..where((f) => f.folderId.equals(folderId))).get();
    for (final file in childFiles) {
      if (file.telegramMessageId != null) {
        messageIds.add(file.telegramMessageId!);
      }
    }
    final childFolders = await (select(folders)..where((f) => f.parentFolderId.equals(folderId))).get();
    for (final child in childFolders) {
      await _collectFolderMessageIds(child.id, messageIds);
    }
  }

  Future<void> recursiveDeleteFolder(String folderId) async {
    final childFolders = await (select(folders)..where((f) => f.parentFolderId.equals(folderId))).get();
    for (final child in childFolders) {
      await recursiveDeleteFolder(child.id);
    }
    final childFiles = await (select(files)..where((f) => f.folderId.equals(folderId))).get();
    for (final file in childFiles) {
      await deleteFile(file.id);
    }
    await (delete(folders)..where((f) => f.id.equals(folderId))).go();
  }

  Stream<List<FileWithTask>> watchTrashedFiles() {
    final query = select(files).join([
      leftOuterJoin(uploadTasks, uploadTasks.fileId.equalsExp(files.id)),
    ]);
    query.where(files.isDeleted.equals(true));
    query.orderBy([OrderingTerm.desc(files.deletedAt)]);
    
    return query.watch().map((rows) {
      return rows.map((row) {
        return FileWithTask(
          file: row.readTable(files),
          task: row.readTableOrNull(uploadTasks),
        );
      }).toList();
    });
  }

  Stream<List<Folder>> watchTrashedFolders() {
    final query = select(folders);
    query.where((f) => f.isDeleted.equals(true));
    query.orderBy([(f) => OrderingTerm.desc(f.updatedAt)]);
    return query.watch();
  }

  // --- Tombstones ---
  Future<void> insertTombstone(Tombstone tombstone) => into(tombstones).insertOnConflictUpdate(tombstone);
  
  Future<Tombstone?> getTombstone(int telegramMessageId) {
    return (select(tombstones)..where((t) => t.telegramMessageId.equals(telegramMessageId))).getSingleOrNull();
  }

  Future<bool> isTombstoned(int telegramMessageId) async {
    final tombstone = await getTombstone(telegramMessageId);
    return tombstone != null;
  }

  /// Paginated query for files with their upload tasks.
  /// Returns a Future (not a Stream) for use with the pagination provider.
  Future<List<FileWithTask>> getFilesWithTasksPaged({
    String? folderId,
    bool isDeleted = false,
    bool isFavorite = false,
    bool isDropZone = false,
    bool isRecent = false,
    String? searchQuery,
    int? sortOption,
    int? typeFilter,
    required int limit,
    required int offset,
  }) async {
    final query = select(files).join([
      leftOuterJoin(uploadTasks, uploadTasks.fileId.equalsExp(files.id)),
    ]);

    Expression<bool> whereClause = files.isDeleted.equals(isDeleted);

    if (isFavorite) {
      whereClause = whereClause & files.isFavorite.equals(true);
    }
    
    if (isDropZone) {
      whereClause = whereClause & files.folderId.isNull();
    } else if (folderId != null) {
      whereClause = whereClause & files.folderId.equals(folderId);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      whereClause = whereClause & files.name.like('%$searchQuery%');
    }

    if (typeFilter != null && typeFilter != 0) {
      switch (typeFilter) {
        case 1: whereClause = whereClause & files.mimeType.like('image/%'); break;
        case 2: whereClause = whereClause & files.mimeType.like('video/%'); break;
        case 3: whereClause = whereClause & files.mimeType.like('audio/%'); break;
        case 4: whereClause = whereClause & (files.mimeType.like('%pdf%') | files.mimeType.like('%document%') | files.mimeType.like('%text%')); break;
        case 5: whereClause = whereClause & (files.mimeType.like('%zip%') | files.mimeType.like('%rar%') | files.mimeType.like('%tar%')); break;
      }
    }

    query.where(whereClause);

    if (isRecent) {
      query.orderBy([OrderingTerm.desc(files.lastOpenedAt), OrderingTerm.desc(files.createdAt)]);
    } else {
      if (sortOption != null) {
        switch (sortOption) {
          case 0: query.orderBy([OrderingTerm.asc(files.name)]); break;
          case 1: query.orderBy([OrderingTerm.desc(files.name)]); break;
          case 2: query.orderBy([OrderingTerm.desc(files.createdAt)]); break;
          case 3: query.orderBy([OrderingTerm.asc(files.createdAt)]); break;
          case 4: query.orderBy([OrderingTerm.desc(files.size)]); break;
          case 5: query.orderBy([OrderingTerm.asc(files.size)]); break;
        }
      } else {
        query.orderBy([OrderingTerm.desc(files.createdAt)]);
      }
    }

    query.limit(limit, offset: offset);

    final rows = await query.get();
    return rows.map((row) {
      return FileWithTask(
        file: row.readTable(files),
        task: row.readTableOrNull(uploadTasks),
      );
    }).toList();
  }

  /// Stream-based query (kept for SmartVault, search, etc.)
  /// Now includes optional limit for bounded loading.
  Stream<List<FileWithTask>> watchFilesWithTasks({
    String? folderId,
    bool isDeleted = false,
    bool isFavorite = false,
    bool isDropZone = false,
    bool isRecent = false,
    String? searchQuery,
    int? sortOption, // 0: nameAsc, 1: nameDesc, 2: dateNewest, 3: dateOldest, 4: sizeLargest, 5: sizeSmallest
    int? typeFilter, // 0: all, 1: image, 2: video, 3: audio, 4: document, 5: archive
    int? limit,
  }) {
    final query = select(files).join([
      leftOuterJoin(uploadTasks, uploadTasks.fileId.equalsExp(files.id)),
    ]);

    Expression<bool> whereClause = files.isDeleted.equals(isDeleted);

    if (isFavorite) {
      whereClause = whereClause & files.isFavorite.equals(true);
    }
    
    if (isDropZone) {
      whereClause = whereClause & files.folderId.isNull();
    } else if (folderId != null) {
      whereClause = whereClause & files.folderId.equals(folderId);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      whereClause = whereClause & files.name.like('%$searchQuery%');
    }

    if (typeFilter != null && typeFilter != 0) {
      switch (typeFilter) {
        case 1: whereClause = whereClause & files.mimeType.like('image/%'); break;
        case 2: whereClause = whereClause & files.mimeType.like('video/%'); break;
        case 3: whereClause = whereClause & files.mimeType.like('audio/%'); break;
        case 4: whereClause = whereClause & (files.mimeType.like('%pdf%') | files.mimeType.like('%document%') | files.mimeType.like('%text%')); break;
        case 5: whereClause = whereClause & (files.mimeType.like('%zip%') | files.mimeType.like('%rar%') | files.mimeType.like('%tar%')); break;
      }
    }

    query.where(whereClause);

    if (isRecent) {
      query.orderBy([OrderingTerm.desc(files.lastOpenedAt), OrderingTerm.desc(files.createdAt)]);
    } else {
      if (sortOption != null) {
        switch (sortOption) {
          case 0: query.orderBy([OrderingTerm.asc(files.name)]); break;
          case 1: query.orderBy([OrderingTerm.desc(files.name)]); break;
          case 2: query.orderBy([OrderingTerm.desc(files.createdAt)]); break;
          case 3: query.orderBy([OrderingTerm.asc(files.createdAt)]); break;
          case 4: query.orderBy([OrderingTerm.desc(files.size)]); break;
          case 5: query.orderBy([OrderingTerm.asc(files.size)]); break;
        }
      } else {
        query.orderBy([OrderingTerm.desc(files.createdAt)]);
      }
    }

    // Apply limit if provided (for search, smart collections, etc.)
    if (limit != null) {
      query.limit(limit);
    }

    return query.watch().map((rows) {
      return rows.map((row) {
        return FileWithTask(
          file: row.readTable(files),
          task: row.readTableOrNull(uploadTasks),
        );
      }).toList();
    });
  }

  Stream<FileWithTask?> watchFileWithTaskById(String fileId) {
    final query = select(files).join([
      leftOuterJoin(uploadTasks, uploadTasks.fileId.equalsExp(files.id)),
    ])..where(files.id.equals(fileId));

    return query.watchSingleOrNull().map((row) {
      if (row == null) return null;
      return FileWithTask(
        file: row.readTable(files),
        task: row.readTableOrNull(uploadTasks),
      );
    });
  }
  
  Stream<List<FileWithTask>> watchSmartCollection(String type) {
    final query = select(files).join([
      leftOuterJoin(uploadTasks, uploadTasks.fileId.equalsExp(files.id)),
    ]);
    
    Expression<bool> whereClause = files.isDeleted.equals(false);
    
    switch (type) {
      case 'Recently Uploaded':
        query.orderBy([OrderingTerm.desc(files.createdAt)]);
        break;
      case 'Recently Opened':
        whereClause = whereClause & files.lastOpenedAt.isNotNull();
        query.orderBy([OrderingTerm.desc(files.lastOpenedAt)]);
        break;
      case 'Large Files':
        whereClause = whereClause & files.size.isBiggerOrEqualValue(10 * 1024 * 1024); // 10MB
        query.orderBy([OrderingTerm.desc(files.size)]);
        break;
      case 'Offline Available':
        whereClause = whereClause & files.downloadStatus.equals('downloaded');
        query.orderBy([OrderingTerm.desc(files.createdAt)]);
        break;
      case 'Not Downloaded':
        whereClause = whereClause & files.downloadStatus.equals('remoteOnly');
        query.orderBy([OrderingTerm.desc(files.createdAt)]);
        break;
      case 'Images':
        whereClause = whereClause & files.mimeType.like('image/%');
        query.orderBy([OrderingTerm.desc(files.createdAt)]);
        break;
      case 'Videos':
        whereClause = whereClause & files.mimeType.like('video/%');
        query.orderBy([OrderingTerm.desc(files.createdAt)]);
        break;
      case 'Documents':
        whereClause = whereClause & files.mimeType.like('application/pdf'); // Can expand later
        query.orderBy([OrderingTerm.desc(files.createdAt)]);
        break;
      case 'Archives':
        whereClause = whereClause & (files.mimeType.like('application/zip') | files.mimeType.like('application/x-rar'));
        query.orderBy([OrderingTerm.desc(files.createdAt)]);
        break;
      case 'Failed Uploads':
        whereClause = whereClause & files.syncStatus.equals('error');
        query.orderBy([OrderingTerm.desc(files.createdAt)]);
        break;
      case 'Unsorted Files':
        whereClause = whereClause & files.folderId.isNull();
        query.orderBy([OrderingTerm.desc(files.createdAt)]);
        break;
    }
    
    query.where(whereClause);
    // Limit smart collections to prevent loading massive lists
    query.limit(200);
    
    return query.watch().map((rows) {
      return rows.map((row) => FileWithTask(
        file: row.readTable(files),
        task: row.readTableOrNull(uploadTasks),
      )).toList();
    });
  }

  Stream<int> watchFilesCount(String? folderId) {
    final query = select(files);
    query.where((f) => f.isDeleted.equals(false));
    if (folderId == null) {
      query.where((f) => f.folderId.isNull());
    } else {
      query.where((f) => f.folderId.equals(folderId));
    }
    return query.watch().map((rows) => rows.length).distinct();
  }

  Future<StorageFile?> getFileById(String id) {
    return (select(files)..where((f) => f.id.equals(id))).getSingleOrNull();
  }

  Future<StorageFile?> getFileByTelegramFileId(int telegramFileId) {
    return (select(files)..where((f) => f.telegramFileId.equals(telegramFileId))).getSingleOrNull();
  }

  Future<StorageFile?> getFileByTelegramThumbnailId(int telegramThumbnailId) {
    return (select(files)..where((f) => f.telegramThumbnailId.equals(telegramThumbnailId))).getSingleOrNull();
  }

  Future<StorageFile?> getFileByTelegramMessageId(int telegramMessageId) {
    return (select(files)..where((f) => f.telegramMessageId.equals(telegramMessageId))).getSingleOrNull();
  }

  Future<void> insertFile(StorageFile file) => into(files).insert(file);
  Future<void> insertFileCompanion(FilesCompanion companion) => into(files).insert(companion);
  
  Future<void> updateFile(StorageFile file) => update(files).replace(file);
  
  Future<void> deleteFile(String id) async {
    await (delete(uploadTasks)..where((t) => t.fileId.equals(id))).go();
    await (delete(fileTags)..where((t) => t.fileId.equals(id))).go();
    await (delete(files)..where((f) => f.id.equals(id))).go();
  }

  Future<void> deleteAllFiles() => delete(files).go();
  Future<void> deleteAllFolders() => delete(folders).go();

  /// Batch upsert files in a single transaction for sync performance.
  Future<void> upsertFiles(List<StorageFile> fileList) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(files, fileList);
    });
  }

  // --- Tags ---
  Future<List<Tag>> getAllTags() => select(tags).get();
  Stream<List<Tag>> watchAllTags() => select(tags).watch();
  Future<void> insertTag(Tag tag) => into(tags).insert(tag);
  Future<void> deleteTag(String id) {
    return (delete(tags)..where((t) => t.id.equals(id))).go();
  }

  // --- UploadTasks ---
  Stream<List<UploadTask>> watchPendingTasks() {
    return (select(uploadTasks)..where((t) => t.status.equals('pending') | t.status.equals('uploading'))).watch();
  }
  Future<void> insertUploadTask(UploadTask task) => into(uploadTasks).insert(task);
  Future<void> insertUploadTaskCompanion(UploadTasksCompanion companion) => into(uploadTasks).insert(companion);
  Future<void> updateUploadTask(UploadTask task) => update(uploadTasks).replace(task);
  Future<void> deleteUploadTask(String id) {
    return (delete(uploadTasks)..where((t) => t.id.equals(id))).go();
  }
  Future<void> deleteAllUploadTasks() => delete(uploadTasks).go();

  /// Watch storage stats via SQL aggregation stream.
  /// Avoids loading all file rows into Dart memory.
  Stream<StorageStatsRow> watchStorageStatsAggregated() {
    return customSelect(
      '''
      SELECT 
        COALESCE(SUM(CASE WHEN is_deleted = 0 THEN 1 ELSE 0 END), 0) as active_count,
        COALESCE(SUM(CASE WHEN is_deleted = 0 THEN size ELSE 0 END), 0) as total_bytes,
        COALESCE(SUM(CASE WHEN is_deleted = 0 AND mime_type LIKE 'image/%' THEN size ELSE 0 END), 0) as image_bytes,
        COALESCE(SUM(CASE WHEN is_deleted = 0 AND mime_type LIKE 'video/%' THEN size ELSE 0 END), 0) as video_bytes,
        COALESCE(SUM(CASE WHEN is_deleted = 0 AND mime_type LIKE 'audio/%' THEN size ELSE 0 END), 0) as audio_bytes,
        COALESCE(SUM(CASE WHEN is_deleted = 0 AND (mime_type LIKE '%pdf%' OR mime_type LIKE '%document%' OR mime_type LIKE '%text%') THEN size ELSE 0 END), 0) as doc_bytes,
        COALESCE(SUM(CASE WHEN is_deleted = 0 AND (mime_type LIKE '%zip%' OR mime_type LIKE '%rar%' OR mime_type LIKE '%tar%' OR mime_type LIKE '%archive%') THEN size ELSE 0 END), 0) as archive_bytes,
        COALESCE(SUM(CASE WHEN is_deleted = 0 AND (mime_type LIKE '%android.package-archive%' OR name LIKE '%.apk') THEN size ELSE 0 END), 0) as apk_bytes,
        COALESCE(SUM(CASE WHEN is_deleted = 0 AND download_status = 'downloaded' THEN size ELSE 0 END), 0) as offline_bytes,
        COALESCE(SUM(CASE WHEN is_deleted = 0 AND download_status != 'downloaded' THEN size ELSE 0 END), 0) as cloud_only_bytes,
        COALESCE(SUM(CASE WHEN is_deleted = 0 AND (sync_status = 'failed' OR sync_status = 'error') THEN 1 ELSE 0 END), 0) as failed_count,
        COALESCE(SUM(CASE WHEN is_deleted = 0 AND sync_status = 'uploading' THEN 1 ELSE 0 END), 0) as active_upload_count,
        (SELECT COUNT(*) FROM folders WHERE is_deleted = 0) as folder_count
      FROM files
      ''',
      readsFrom: {files, folders},
    ).watchSingle().map((result) {
      return StorageStatsRow(
        activeCount: result.read<int>('active_count'),
        totalBytes: result.read<int>('total_bytes'),
        imageBytes: result.read<int>('image_bytes'),
        videoBytes: result.read<int>('video_bytes'),
        audioBytes: result.read<int>('audio_bytes'),
        docBytes: result.read<int>('doc_bytes'),
        archiveBytes: result.read<int>('archive_bytes'),
        apkBytes: result.read<int>('apk_bytes'),
        offlineBytes: result.read<int>('offline_bytes'),
        cloudOnlyBytes: result.read<int>('cloud_only_bytes'),
        failedCount: result.read<int>('failed_count'),
        activeUploadCount: result.read<int>('active_upload_count'),
        folderCount: result.read<int>('folder_count'),
      );
    });
  }
}

class FileWithTask {
  final StorageFile file;
  final UploadTask? task;

  FileWithTask({required this.file, this.task});
}

/// Aggregated storage stats from SQL. Avoids loading all file rows into Dart.
class StorageStatsRow {
  final int activeCount;
  final int totalBytes;
  final int imageBytes;
  final int videoBytes;
  final int audioBytes;
  final int docBytes;
  final int archiveBytes;
  final int apkBytes;
  final int offlineBytes;
  final int cloudOnlyBytes;
  final int failedCount;
  final int activeUploadCount;
  final int folderCount;

  StorageStatsRow({
    required this.activeCount,
    required this.totalBytes,
    required this.imageBytes,
    required this.videoBytes,
    required this.audioBytes,
    required this.docBytes,
    required this.archiveBytes,
    required this.apkBytes,
    required this.offlineBytes,
    required this.cloudOnlyBytes,
    required this.failedCount,
    required this.activeUploadCount,
    required this.folderCount,
  });
}
