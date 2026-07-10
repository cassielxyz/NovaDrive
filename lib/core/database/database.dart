import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'database.g.dart';

@DataClassName('StorageFile')
class Files extends Table {
  TextColumn get id => text()(); // local UUID
  IntColumn get telegramMessageId => integer().nullable()(); // message ID when uploaded
  IntColumn get telegramFileId => integer().nullable()(); // local TDLib file ID
  TextColumn get telegramRemoteId => text().nullable()(); // remote TDLib file ID
  TextColumn get name => text()();
  IntColumn get size => integer()();
  TextColumn get mimeType => text()();
  TextColumn get path => text()(); // Deprecated or kept for compat
  TextColumn get localPath => text().nullable()();
  IntColumn get telegramThumbnailId => integer().nullable()(); // TDLib thumbnail file ID
  TextColumn get thumbnailLocalPath => text().nullable()(); // local path to thumbnail
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncStatus => text().withDefault(const Constant('local'))(); // local, uploading, synced, error
  TextColumn get downloadStatus => text().withDefault(const Constant('downloaded'))(); // remoteOnly, downloading, downloaded
  TextColumn get folderId => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastOpenedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

class Folders extends Table {
  TextColumn get id => text()();
  IntColumn get accountId => integer()(); // Telegram user ID / selfChatId
  TextColumn get name => text()();
  TextColumn get parentFolderId => text().nullable()();
  TextColumn get color => text().nullable()();
  TextColumn get icon => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get telegramMessageId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class UploadTasks extends Table {
  TextColumn get id => text()();
  TextColumn get fileId => text().references(Files, #id)();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending, uploading, paused, error, completed
  
  @override
  Set<Column> get primaryKey => {id};
}

class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get color => text().nullable()(); // hex color

  @override
  Set<Column> get primaryKey => {id};
}

class FileTags extends Table {
  TextColumn get fileId => text().references(Files, #id)();
  TextColumn get tagId => text().references(Tags, #id)();

  @override
  Set<Column> get primaryKey => {fileId, tagId};
}

class Tombstones extends Table {
  IntColumn get telegramMessageId => integer()();
  IntColumn get telegramChatId => integer().nullable()();
  IntColumn get telegramFileId => integer().nullable()();
  TextColumn get telegramRemoteId => text().nullable()();
  DateTimeColumn get deletedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get deleteStatus => text().nullable()(); // e.g. "permanently_deleted"
  
  @override
  Set<Column> get primaryKey => {telegramMessageId};
}

@DriftDatabase(tables: [Files, Folders, UploadTasks, Tags, FileTags, Tombstones])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Create performance indexes on fresh install
        await _createPerformanceIndexes();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(folders);
          await m.addColumn(files, files.localPath);
          await m.addColumn(files, files.downloadStatus);
          await m.addColumn(files, files.folderId);
          await m.addColumn(files, files.isFavorite);
          await m.addColumn(files, files.isDeleted);
          await m.addColumn(files, files.lastOpenedAt);
          await m.addColumn(files, files.deletedAt);
          
          // Update existing rows
          await customStatement('UPDATE files SET is_favorite = 0;');
          await customStatement('UPDATE files SET is_deleted = 0;');
          await customStatement('UPDATE files SET download_status = CASE WHEN path IS NOT NULL AND path != \'\' THEN \'downloaded\' ELSE \'remoteOnly\' END;');
        }
        if (from < 3) {
          await m.addColumn(files, files.telegramThumbnailId);
          await m.addColumn(files, files.thumbnailLocalPath);
        }
        if (from < 4) {
          // v4: Add performance indexes
          await _createPerformanceIndexes();
        }
        if (from < 5) {
          // v5: Add Tombstones table for permanent deletion
          await m.createTable(tombstones);
        }
        if (from < 6) {
          // v6: Add telegramMessageId to folders
          await m.addColumn(folders, folders.telegramMessageId);
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
        // Performance: use WAL mode for concurrent reads during writes
        await customStatement('PRAGMA journal_mode = WAL');
      },
    );
  }

  /// Creates performance indexes for faster queries.
  /// Uses IF NOT EXISTS so it's safe to call multiple times.
  Future<void> _createPerformanceIndexes() async {
    // Files table indexes
    await customStatement('CREATE INDEX IF NOT EXISTS idx_files_folder_id ON files (folder_id)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_files_name ON files (name)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_files_sync_status ON files (sync_status)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_files_created_at ON files (created_at)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_files_updated_at ON files (updated_at)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_files_telegram_file_id ON files (telegram_file_id)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_files_telegram_remote_id ON files (telegram_remote_id)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_files_is_favorite ON files (is_favorite)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_files_is_deleted ON files (is_deleted)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_files_telegram_message_id ON files (telegram_message_id)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_files_telegram_thumbnail_id ON files (telegram_thumbnail_id)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_files_mime_type ON files (mime_type)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_files_download_status ON files (download_status)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_files_last_opened_at ON files (last_opened_at)');
    // Composite index for most common query pattern (drop zone / folder view)
    await customStatement('CREATE INDEX IF NOT EXISTS idx_files_deleted_folder ON files (is_deleted, folder_id)');

    // Folders table indexes
    await customStatement('CREATE INDEX IF NOT EXISTS idx_folders_parent_folder_id ON folders (parent_folder_id)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_folders_account_id ON folders (account_id)');

    // UploadTasks table indexes
    await customStatement('CREATE INDEX IF NOT EXISTS idx_upload_tasks_file_id ON upload_tasks (file_id)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_upload_tasks_status ON upload_tasks (status)');
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'nova_drive.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
