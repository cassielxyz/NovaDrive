// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daos.dart';

// ignore_for_file: type=lint
mixin _$AppDaoMixin on DatabaseAccessor<AppDatabase> {
  $FilesTable get files => attachedDatabase.files;
  $FoldersTable get folders => attachedDatabase.folders;
  $TagsTable get tags => attachedDatabase.tags;
  $FileTagsTable get fileTags => attachedDatabase.fileTags;
  $UploadTasksTable get uploadTasks => attachedDatabase.uploadTasks;
  $TombstonesTable get tombstones => attachedDatabase.tombstones;
  AppDaoManager get managers => AppDaoManager(this);
}

class AppDaoManager {
  final _$AppDaoMixin _db;
  AppDaoManager(this._db);
  $$FilesTableTableManager get files =>
      $$FilesTableTableManager(_db.attachedDatabase, _db.files);
  $$FoldersTableTableManager get folders =>
      $$FoldersTableTableManager(_db.attachedDatabase, _db.folders);
  $$TagsTableTableManager get tags =>
      $$TagsTableTableManager(_db.attachedDatabase, _db.tags);
  $$FileTagsTableTableManager get fileTags =>
      $$FileTagsTableTableManager(_db.attachedDatabase, _db.fileTags);
  $$UploadTasksTableTableManager get uploadTasks =>
      $$UploadTasksTableTableManager(_db.attachedDatabase, _db.uploadTasks);
  $$TombstonesTableTableManager get tombstones =>
      $$TombstonesTableTableManager(_db.attachedDatabase, _db.tombstones);
}
