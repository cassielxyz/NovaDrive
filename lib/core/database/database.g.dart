// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FilesTable extends Files with TableInfo<$FilesTable, StorageFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telegramMessageIdMeta = const VerificationMeta(
    'telegramMessageId',
  );
  @override
  late final GeneratedColumn<int> telegramMessageId = GeneratedColumn<int>(
    'telegram_message_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _telegramFileIdMeta = const VerificationMeta(
    'telegramFileId',
  );
  @override
  late final GeneratedColumn<int> telegramFileId = GeneratedColumn<int>(
    'telegram_file_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _telegramRemoteIdMeta = const VerificationMeta(
    'telegramRemoteId',
  );
  @override
  late final GeneratedColumn<String> telegramRemoteId = GeneratedColumn<String>(
    'telegram_remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
    'size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _telegramThumbnailIdMeta =
      const VerificationMeta('telegramThumbnailId');
  @override
  late final GeneratedColumn<int> telegramThumbnailId = GeneratedColumn<int>(
    'telegram_thumbnail_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thumbnailLocalPathMeta =
      const VerificationMeta('thumbnailLocalPath');
  @override
  late final GeneratedColumn<String> thumbnailLocalPath =
      GeneratedColumn<String>(
        'thumbnail_local_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('local'),
  );
  static const VerificationMeta _downloadStatusMeta = const VerificationMeta(
    'downloadStatus',
  );
  @override
  late final GeneratedColumn<String> downloadStatus = GeneratedColumn<String>(
    'download_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('downloaded'),
  );
  static const VerificationMeta _folderIdMeta = const VerificationMeta(
    'folderId',
  );
  @override
  late final GeneratedColumn<String> folderId = GeneratedColumn<String>(
    'folder_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastOpenedAtMeta = const VerificationMeta(
    'lastOpenedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastOpenedAt = GeneratedColumn<DateTime>(
    'last_opened_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    telegramMessageId,
    telegramFileId,
    telegramRemoteId,
    name,
    size,
    mimeType,
    path,
    localPath,
    telegramThumbnailId,
    thumbnailLocalPath,
    createdAt,
    updatedAt,
    syncStatus,
    downloadStatus,
    folderId,
    isFavorite,
    isDeleted,
    lastOpenedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'files';
  @override
  VerificationContext validateIntegrity(
    Insertable<StorageFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('telegram_message_id')) {
      context.handle(
        _telegramMessageIdMeta,
        telegramMessageId.isAcceptableOrUnknown(
          data['telegram_message_id']!,
          _telegramMessageIdMeta,
        ),
      );
    }
    if (data.containsKey('telegram_file_id')) {
      context.handle(
        _telegramFileIdMeta,
        telegramFileId.isAcceptableOrUnknown(
          data['telegram_file_id']!,
          _telegramFileIdMeta,
        ),
      );
    }
    if (data.containsKey('telegram_remote_id')) {
      context.handle(
        _telegramRemoteIdMeta,
        telegramRemoteId.isAcceptableOrUnknown(
          data['telegram_remote_id']!,
          _telegramRemoteIdMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('size')) {
      context.handle(
        _sizeMeta,
        size.isAcceptableOrUnknown(data['size']!, _sizeMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    }
    if (data.containsKey('telegram_thumbnail_id')) {
      context.handle(
        _telegramThumbnailIdMeta,
        telegramThumbnailId.isAcceptableOrUnknown(
          data['telegram_thumbnail_id']!,
          _telegramThumbnailIdMeta,
        ),
      );
    }
    if (data.containsKey('thumbnail_local_path')) {
      context.handle(
        _thumbnailLocalPathMeta,
        thumbnailLocalPath.isAcceptableOrUnknown(
          data['thumbnail_local_path']!,
          _thumbnailLocalPathMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('download_status')) {
      context.handle(
        _downloadStatusMeta,
        downloadStatus.isAcceptableOrUnknown(
          data['download_status']!,
          _downloadStatusMeta,
        ),
      );
    }
    if (data.containsKey('folder_id')) {
      context.handle(
        _folderIdMeta,
        folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('last_opened_at')) {
      context.handle(
        _lastOpenedAtMeta,
        lastOpenedAt.isAcceptableOrUnknown(
          data['last_opened_at']!,
          _lastOpenedAtMeta,
        ),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StorageFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StorageFile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      telegramMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}telegram_message_id'],
      ),
      telegramFileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}telegram_file_id'],
      ),
      telegramRemoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telegram_remote_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      ),
      telegramThumbnailId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}telegram_thumbnail_id'],
      ),
      thumbnailLocalPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_local_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      downloadStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}download_status'],
      )!,
      folderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder_id'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      lastOpenedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_opened_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $FilesTable createAlias(String alias) {
    return $FilesTable(attachedDatabase, alias);
  }
}

class StorageFile extends DataClass implements Insertable<StorageFile> {
  final String id;
  final int? telegramMessageId;
  final int? telegramFileId;
  final String? telegramRemoteId;
  final String name;
  final int size;
  final String mimeType;
  final String path;
  final String? localPath;
  final int? telegramThumbnailId;
  final String? thumbnailLocalPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;
  final String downloadStatus;
  final String? folderId;
  final bool isFavorite;
  final bool isDeleted;
  final DateTime? lastOpenedAt;
  final DateTime? deletedAt;
  const StorageFile({
    required this.id,
    this.telegramMessageId,
    this.telegramFileId,
    this.telegramRemoteId,
    required this.name,
    required this.size,
    required this.mimeType,
    required this.path,
    this.localPath,
    this.telegramThumbnailId,
    this.thumbnailLocalPath,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.downloadStatus,
    this.folderId,
    required this.isFavorite,
    required this.isDeleted,
    this.lastOpenedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || telegramMessageId != null) {
      map['telegram_message_id'] = Variable<int>(telegramMessageId);
    }
    if (!nullToAbsent || telegramFileId != null) {
      map['telegram_file_id'] = Variable<int>(telegramFileId);
    }
    if (!nullToAbsent || telegramRemoteId != null) {
      map['telegram_remote_id'] = Variable<String>(telegramRemoteId);
    }
    map['name'] = Variable<String>(name);
    map['size'] = Variable<int>(size);
    map['mime_type'] = Variable<String>(mimeType);
    map['path'] = Variable<String>(path);
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    if (!nullToAbsent || telegramThumbnailId != null) {
      map['telegram_thumbnail_id'] = Variable<int>(telegramThumbnailId);
    }
    if (!nullToAbsent || thumbnailLocalPath != null) {
      map['thumbnail_local_path'] = Variable<String>(thumbnailLocalPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    map['download_status'] = Variable<String>(downloadStatus);
    if (!nullToAbsent || folderId != null) {
      map['folder_id'] = Variable<String>(folderId);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || lastOpenedAt != null) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  FilesCompanion toCompanion(bool nullToAbsent) {
    return FilesCompanion(
      id: Value(id),
      telegramMessageId: telegramMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(telegramMessageId),
      telegramFileId: telegramFileId == null && nullToAbsent
          ? const Value.absent()
          : Value(telegramFileId),
      telegramRemoteId: telegramRemoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(telegramRemoteId),
      name: Value(name),
      size: Value(size),
      mimeType: Value(mimeType),
      path: Value(path),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      telegramThumbnailId: telegramThumbnailId == null && nullToAbsent
          ? const Value.absent()
          : Value(telegramThumbnailId),
      thumbnailLocalPath: thumbnailLocalPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailLocalPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      downloadStatus: Value(downloadStatus),
      folderId: folderId == null && nullToAbsent
          ? const Value.absent()
          : Value(folderId),
      isFavorite: Value(isFavorite),
      isDeleted: Value(isDeleted),
      lastOpenedAt: lastOpenedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOpenedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory StorageFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StorageFile(
      id: serializer.fromJson<String>(json['id']),
      telegramMessageId: serializer.fromJson<int?>(json['telegramMessageId']),
      telegramFileId: serializer.fromJson<int?>(json['telegramFileId']),
      telegramRemoteId: serializer.fromJson<String?>(json['telegramRemoteId']),
      name: serializer.fromJson<String>(json['name']),
      size: serializer.fromJson<int>(json['size']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      path: serializer.fromJson<String>(json['path']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      telegramThumbnailId: serializer.fromJson<int?>(
        json['telegramThumbnailId'],
      ),
      thumbnailLocalPath: serializer.fromJson<String?>(
        json['thumbnailLocalPath'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      downloadStatus: serializer.fromJson<String>(json['downloadStatus']),
      folderId: serializer.fromJson<String?>(json['folderId']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      lastOpenedAt: serializer.fromJson<DateTime?>(json['lastOpenedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'telegramMessageId': serializer.toJson<int?>(telegramMessageId),
      'telegramFileId': serializer.toJson<int?>(telegramFileId),
      'telegramRemoteId': serializer.toJson<String?>(telegramRemoteId),
      'name': serializer.toJson<String>(name),
      'size': serializer.toJson<int>(size),
      'mimeType': serializer.toJson<String>(mimeType),
      'path': serializer.toJson<String>(path),
      'localPath': serializer.toJson<String?>(localPath),
      'telegramThumbnailId': serializer.toJson<int?>(telegramThumbnailId),
      'thumbnailLocalPath': serializer.toJson<String?>(thumbnailLocalPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'downloadStatus': serializer.toJson<String>(downloadStatus),
      'folderId': serializer.toJson<String?>(folderId),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'lastOpenedAt': serializer.toJson<DateTime?>(lastOpenedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  StorageFile copyWith({
    String? id,
    Value<int?> telegramMessageId = const Value.absent(),
    Value<int?> telegramFileId = const Value.absent(),
    Value<String?> telegramRemoteId = const Value.absent(),
    String? name,
    int? size,
    String? mimeType,
    String? path,
    Value<String?> localPath = const Value.absent(),
    Value<int?> telegramThumbnailId = const Value.absent(),
    Value<String?> thumbnailLocalPath = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
    String? downloadStatus,
    Value<String?> folderId = const Value.absent(),
    bool? isFavorite,
    bool? isDeleted,
    Value<DateTime?> lastOpenedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => StorageFile(
    id: id ?? this.id,
    telegramMessageId: telegramMessageId.present
        ? telegramMessageId.value
        : this.telegramMessageId,
    telegramFileId: telegramFileId.present
        ? telegramFileId.value
        : this.telegramFileId,
    telegramRemoteId: telegramRemoteId.present
        ? telegramRemoteId.value
        : this.telegramRemoteId,
    name: name ?? this.name,
    size: size ?? this.size,
    mimeType: mimeType ?? this.mimeType,
    path: path ?? this.path,
    localPath: localPath.present ? localPath.value : this.localPath,
    telegramThumbnailId: telegramThumbnailId.present
        ? telegramThumbnailId.value
        : this.telegramThumbnailId,
    thumbnailLocalPath: thumbnailLocalPath.present
        ? thumbnailLocalPath.value
        : this.thumbnailLocalPath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    downloadStatus: downloadStatus ?? this.downloadStatus,
    folderId: folderId.present ? folderId.value : this.folderId,
    isFavorite: isFavorite ?? this.isFavorite,
    isDeleted: isDeleted ?? this.isDeleted,
    lastOpenedAt: lastOpenedAt.present ? lastOpenedAt.value : this.lastOpenedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  StorageFile copyWithCompanion(FilesCompanion data) {
    return StorageFile(
      id: data.id.present ? data.id.value : this.id,
      telegramMessageId: data.telegramMessageId.present
          ? data.telegramMessageId.value
          : this.telegramMessageId,
      telegramFileId: data.telegramFileId.present
          ? data.telegramFileId.value
          : this.telegramFileId,
      telegramRemoteId: data.telegramRemoteId.present
          ? data.telegramRemoteId.value
          : this.telegramRemoteId,
      name: data.name.present ? data.name.value : this.name,
      size: data.size.present ? data.size.value : this.size,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      path: data.path.present ? data.path.value : this.path,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      telegramThumbnailId: data.telegramThumbnailId.present
          ? data.telegramThumbnailId.value
          : this.telegramThumbnailId,
      thumbnailLocalPath: data.thumbnailLocalPath.present
          ? data.thumbnailLocalPath.value
          : this.thumbnailLocalPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      downloadStatus: data.downloadStatus.present
          ? data.downloadStatus.value
          : this.downloadStatus,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      lastOpenedAt: data.lastOpenedAt.present
          ? data.lastOpenedAt.value
          : this.lastOpenedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StorageFile(')
          ..write('id: $id, ')
          ..write('telegramMessageId: $telegramMessageId, ')
          ..write('telegramFileId: $telegramFileId, ')
          ..write('telegramRemoteId: $telegramRemoteId, ')
          ..write('name: $name, ')
          ..write('size: $size, ')
          ..write('mimeType: $mimeType, ')
          ..write('path: $path, ')
          ..write('localPath: $localPath, ')
          ..write('telegramThumbnailId: $telegramThumbnailId, ')
          ..write('thumbnailLocalPath: $thumbnailLocalPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('downloadStatus: $downloadStatus, ')
          ..write('folderId: $folderId, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('lastOpenedAt: $lastOpenedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    telegramMessageId,
    telegramFileId,
    telegramRemoteId,
    name,
    size,
    mimeType,
    path,
    localPath,
    telegramThumbnailId,
    thumbnailLocalPath,
    createdAt,
    updatedAt,
    syncStatus,
    downloadStatus,
    folderId,
    isFavorite,
    isDeleted,
    lastOpenedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StorageFile &&
          other.id == this.id &&
          other.telegramMessageId == this.telegramMessageId &&
          other.telegramFileId == this.telegramFileId &&
          other.telegramRemoteId == this.telegramRemoteId &&
          other.name == this.name &&
          other.size == this.size &&
          other.mimeType == this.mimeType &&
          other.path == this.path &&
          other.localPath == this.localPath &&
          other.telegramThumbnailId == this.telegramThumbnailId &&
          other.thumbnailLocalPath == this.thumbnailLocalPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.downloadStatus == this.downloadStatus &&
          other.folderId == this.folderId &&
          other.isFavorite == this.isFavorite &&
          other.isDeleted == this.isDeleted &&
          other.lastOpenedAt == this.lastOpenedAt &&
          other.deletedAt == this.deletedAt);
}

class FilesCompanion extends UpdateCompanion<StorageFile> {
  final Value<String> id;
  final Value<int?> telegramMessageId;
  final Value<int?> telegramFileId;
  final Value<String?> telegramRemoteId;
  final Value<String> name;
  final Value<int> size;
  final Value<String> mimeType;
  final Value<String> path;
  final Value<String?> localPath;
  final Value<int?> telegramThumbnailId;
  final Value<String?> thumbnailLocalPath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<String> downloadStatus;
  final Value<String?> folderId;
  final Value<bool> isFavorite;
  final Value<bool> isDeleted;
  final Value<DateTime?> lastOpenedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const FilesCompanion({
    this.id = const Value.absent(),
    this.telegramMessageId = const Value.absent(),
    this.telegramFileId = const Value.absent(),
    this.telegramRemoteId = const Value.absent(),
    this.name = const Value.absent(),
    this.size = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.path = const Value.absent(),
    this.localPath = const Value.absent(),
    this.telegramThumbnailId = const Value.absent(),
    this.thumbnailLocalPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.downloadStatus = const Value.absent(),
    this.folderId = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FilesCompanion.insert({
    required String id,
    this.telegramMessageId = const Value.absent(),
    this.telegramFileId = const Value.absent(),
    this.telegramRemoteId = const Value.absent(),
    required String name,
    required int size,
    required String mimeType,
    required String path,
    this.localPath = const Value.absent(),
    this.telegramThumbnailId = const Value.absent(),
    this.thumbnailLocalPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.downloadStatus = const Value.absent(),
    this.folderId = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       size = Value(size),
       mimeType = Value(mimeType),
       path = Value(path);
  static Insertable<StorageFile> custom({
    Expression<String>? id,
    Expression<int>? telegramMessageId,
    Expression<int>? telegramFileId,
    Expression<String>? telegramRemoteId,
    Expression<String>? name,
    Expression<int>? size,
    Expression<String>? mimeType,
    Expression<String>? path,
    Expression<String>? localPath,
    Expression<int>? telegramThumbnailId,
    Expression<String>? thumbnailLocalPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? downloadStatus,
    Expression<String>? folderId,
    Expression<bool>? isFavorite,
    Expression<bool>? isDeleted,
    Expression<DateTime>? lastOpenedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (telegramMessageId != null) 'telegram_message_id': telegramMessageId,
      if (telegramFileId != null) 'telegram_file_id': telegramFileId,
      if (telegramRemoteId != null) 'telegram_remote_id': telegramRemoteId,
      if (name != null) 'name': name,
      if (size != null) 'size': size,
      if (mimeType != null) 'mime_type': mimeType,
      if (path != null) 'path': path,
      if (localPath != null) 'local_path': localPath,
      if (telegramThumbnailId != null)
        'telegram_thumbnail_id': telegramThumbnailId,
      if (thumbnailLocalPath != null)
        'thumbnail_local_path': thumbnailLocalPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (downloadStatus != null) 'download_status': downloadStatus,
      if (folderId != null) 'folder_id': folderId,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (lastOpenedAt != null) 'last_opened_at': lastOpenedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FilesCompanion copyWith({
    Value<String>? id,
    Value<int?>? telegramMessageId,
    Value<int?>? telegramFileId,
    Value<String?>? telegramRemoteId,
    Value<String>? name,
    Value<int>? size,
    Value<String>? mimeType,
    Value<String>? path,
    Value<String?>? localPath,
    Value<int?>? telegramThumbnailId,
    Value<String?>? thumbnailLocalPath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? syncStatus,
    Value<String>? downloadStatus,
    Value<String?>? folderId,
    Value<bool>? isFavorite,
    Value<bool>? isDeleted,
    Value<DateTime?>? lastOpenedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return FilesCompanion(
      id: id ?? this.id,
      telegramMessageId: telegramMessageId ?? this.telegramMessageId,
      telegramFileId: telegramFileId ?? this.telegramFileId,
      telegramRemoteId: telegramRemoteId ?? this.telegramRemoteId,
      name: name ?? this.name,
      size: size ?? this.size,
      mimeType: mimeType ?? this.mimeType,
      path: path ?? this.path,
      localPath: localPath ?? this.localPath,
      telegramThumbnailId: telegramThumbnailId ?? this.telegramThumbnailId,
      thumbnailLocalPath: thumbnailLocalPath ?? this.thumbnailLocalPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      downloadStatus: downloadStatus ?? this.downloadStatus,
      folderId: folderId ?? this.folderId,
      isFavorite: isFavorite ?? this.isFavorite,
      isDeleted: isDeleted ?? this.isDeleted,
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (telegramMessageId.present) {
      map['telegram_message_id'] = Variable<int>(telegramMessageId.value);
    }
    if (telegramFileId.present) {
      map['telegram_file_id'] = Variable<int>(telegramFileId.value);
    }
    if (telegramRemoteId.present) {
      map['telegram_remote_id'] = Variable<String>(telegramRemoteId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (telegramThumbnailId.present) {
      map['telegram_thumbnail_id'] = Variable<int>(telegramThumbnailId.value);
    }
    if (thumbnailLocalPath.present) {
      map['thumbnail_local_path'] = Variable<String>(thumbnailLocalPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (downloadStatus.present) {
      map['download_status'] = Variable<String>(downloadStatus.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<String>(folderId.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (lastOpenedAt.present) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FilesCompanion(')
          ..write('id: $id, ')
          ..write('telegramMessageId: $telegramMessageId, ')
          ..write('telegramFileId: $telegramFileId, ')
          ..write('telegramRemoteId: $telegramRemoteId, ')
          ..write('name: $name, ')
          ..write('size: $size, ')
          ..write('mimeType: $mimeType, ')
          ..write('path: $path, ')
          ..write('localPath: $localPath, ')
          ..write('telegramThumbnailId: $telegramThumbnailId, ')
          ..write('thumbnailLocalPath: $thumbnailLocalPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('downloadStatus: $downloadStatus, ')
          ..write('folderId: $folderId, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('lastOpenedAt: $lastOpenedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FoldersTable extends Folders with TableInfo<$FoldersTable, Folder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoldersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentFolderIdMeta = const VerificationMeta(
    'parentFolderId',
  );
  @override
  late final GeneratedColumn<String> parentFolderId = GeneratedColumn<String>(
    'parent_folder_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _telegramMessageIdMeta = const VerificationMeta(
    'telegramMessageId',
  );
  @override
  late final GeneratedColumn<int> telegramMessageId = GeneratedColumn<int>(
    'telegram_message_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    name,
    parentFolderId,
    color,
    icon,
    createdAt,
    updatedAt,
    isDeleted,
    deletedAt,
    sortOrder,
    telegramMessageId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'folders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Folder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_folder_id')) {
      context.handle(
        _parentFolderIdMeta,
        parentFolderId.isAcceptableOrUnknown(
          data['parent_folder_id']!,
          _parentFolderIdMeta,
        ),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('telegram_message_id')) {
      context.handle(
        _telegramMessageIdMeta,
        telegramMessageId.isAcceptableOrUnknown(
          data['telegram_message_id']!,
          _telegramMessageIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Folder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Folder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentFolderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_folder_id'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      telegramMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}telegram_message_id'],
      ),
    );
  }

  @override
  $FoldersTable createAlias(String alias) {
    return $FoldersTable(attachedDatabase, alias);
  }
}

class Folder extends DataClass implements Insertable<Folder> {
  final String id;
  final int accountId;
  final String name;
  final String? parentFolderId;
  final String? color;
  final String? icon;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final DateTime? deletedAt;
  final int sortOrder;
  final int? telegramMessageId;
  const Folder({
    required this.id,
    required this.accountId,
    required this.name,
    this.parentFolderId,
    this.color,
    this.icon,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    this.deletedAt,
    required this.sortOrder,
    this.telegramMessageId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<int>(accountId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentFolderId != null) {
      map['parent_folder_id'] = Variable<String>(parentFolderId);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || telegramMessageId != null) {
      map['telegram_message_id'] = Variable<int>(telegramMessageId);
    }
    return map;
  }

  FoldersCompanion toCompanion(bool nullToAbsent) {
    return FoldersCompanion(
      id: Value(id),
      accountId: Value(accountId),
      name: Value(name),
      parentFolderId: parentFolderId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentFolderId),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      sortOrder: Value(sortOrder),
      telegramMessageId: telegramMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(telegramMessageId),
    );
  }

  factory Folder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Folder(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      name: serializer.fromJson<String>(json['name']),
      parentFolderId: serializer.fromJson<String?>(json['parentFolderId']),
      color: serializer.fromJson<String?>(json['color']),
      icon: serializer.fromJson<String?>(json['icon']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      telegramMessageId: serializer.fromJson<int?>(json['telegramMessageId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<int>(accountId),
      'name': serializer.toJson<String>(name),
      'parentFolderId': serializer.toJson<String?>(parentFolderId),
      'color': serializer.toJson<String?>(color),
      'icon': serializer.toJson<String?>(icon),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'telegramMessageId': serializer.toJson<int?>(telegramMessageId),
    };
  }

  Folder copyWith({
    String? id,
    int? accountId,
    String? name,
    Value<String?> parentFolderId = const Value.absent(),
    Value<String?> color = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? sortOrder,
    Value<int?> telegramMessageId = const Value.absent(),
  }) => Folder(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    name: name ?? this.name,
    parentFolderId: parentFolderId.present
        ? parentFolderId.value
        : this.parentFolderId,
    color: color.present ? color.value : this.color,
    icon: icon.present ? icon.value : this.icon,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    sortOrder: sortOrder ?? this.sortOrder,
    telegramMessageId: telegramMessageId.present
        ? telegramMessageId.value
        : this.telegramMessageId,
  );
  Folder copyWithCompanion(FoldersCompanion data) {
    return Folder(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      name: data.name.present ? data.name.value : this.name,
      parentFolderId: data.parentFolderId.present
          ? data.parentFolderId.value
          : this.parentFolderId,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      telegramMessageId: data.telegramMessageId.present
          ? data.telegramMessageId.value
          : this.telegramMessageId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Folder(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('parentFolderId: $parentFolderId, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('telegramMessageId: $telegramMessageId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    name,
    parentFolderId,
    color,
    icon,
    createdAt,
    updatedAt,
    isDeleted,
    deletedAt,
    sortOrder,
    telegramMessageId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Folder &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.name == this.name &&
          other.parentFolderId == this.parentFolderId &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt &&
          other.sortOrder == this.sortOrder &&
          other.telegramMessageId == this.telegramMessageId);
}

class FoldersCompanion extends UpdateCompanion<Folder> {
  final Value<String> id;
  final Value<int> accountId;
  final Value<String> name;
  final Value<String?> parentFolderId;
  final Value<String?> color;
  final Value<String?> icon;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<int> sortOrder;
  final Value<int?> telegramMessageId;
  final Value<int> rowid;
  const FoldersCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.name = const Value.absent(),
    this.parentFolderId = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.telegramMessageId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoldersCompanion.insert({
    required String id,
    required int accountId,
    required String name,
    this.parentFolderId = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.telegramMessageId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       name = Value(name);
  static Insertable<Folder> custom({
    Expression<String>? id,
    Expression<int>? accountId,
    Expression<String>? name,
    Expression<String>? parentFolderId,
    Expression<String>? color,
    Expression<String>? icon,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<int>? sortOrder,
    Expression<int>? telegramMessageId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (name != null) 'name': name,
      if (parentFolderId != null) 'parent_folder_id': parentFolderId,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (telegramMessageId != null) 'telegram_message_id': telegramMessageId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoldersCompanion copyWith({
    Value<String>? id,
    Value<int>? accountId,
    Value<String>? name,
    Value<String?>? parentFolderId,
    Value<String?>? color,
    Value<String?>? icon,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<int>? sortOrder,
    Value<int?>? telegramMessageId,
    Value<int>? rowid,
  }) {
    return FoldersCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      parentFolderId: parentFolderId ?? this.parentFolderId,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      sortOrder: sortOrder ?? this.sortOrder,
      telegramMessageId: telegramMessageId ?? this.telegramMessageId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentFolderId.present) {
      map['parent_folder_id'] = Variable<String>(parentFolderId.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (telegramMessageId.present) {
      map['telegram_message_id'] = Variable<int>(telegramMessageId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoldersCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('parentFolderId: $parentFolderId, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('telegramMessageId: $telegramMessageId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UploadTasksTable extends UploadTasks
    with TableInfo<$UploadTasksTable, UploadTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UploadTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileIdMeta = const VerificationMeta('fileId');
  @override
  late final GeneratedColumn<String> fileId = GeneratedColumn<String>(
    'file_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES files (id)',
    ),
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, fileId, progress, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'upload_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<UploadTask> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('file_id')) {
      context.handle(
        _fileIdMeta,
        fileId.isAcceptableOrUnknown(data['file_id']!, _fileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fileIdMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UploadTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UploadTask(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_id'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $UploadTasksTable createAlias(String alias) {
    return $UploadTasksTable(attachedDatabase, alias);
  }
}

class UploadTask extends DataClass implements Insertable<UploadTask> {
  final String id;
  final String fileId;
  final int progress;
  final String status;
  const UploadTask({
    required this.id,
    required this.fileId,
    required this.progress,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['file_id'] = Variable<String>(fileId);
    map['progress'] = Variable<int>(progress);
    map['status'] = Variable<String>(status);
    return map;
  }

  UploadTasksCompanion toCompanion(bool nullToAbsent) {
    return UploadTasksCompanion(
      id: Value(id),
      fileId: Value(fileId),
      progress: Value(progress),
      status: Value(status),
    );
  }

  factory UploadTask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UploadTask(
      id: serializer.fromJson<String>(json['id']),
      fileId: serializer.fromJson<String>(json['fileId']),
      progress: serializer.fromJson<int>(json['progress']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fileId': serializer.toJson<String>(fileId),
      'progress': serializer.toJson<int>(progress),
      'status': serializer.toJson<String>(status),
    };
  }

  UploadTask copyWith({
    String? id,
    String? fileId,
    int? progress,
    String? status,
  }) => UploadTask(
    id: id ?? this.id,
    fileId: fileId ?? this.fileId,
    progress: progress ?? this.progress,
    status: status ?? this.status,
  );
  UploadTask copyWithCompanion(UploadTasksCompanion data) {
    return UploadTask(
      id: data.id.present ? data.id.value : this.id,
      fileId: data.fileId.present ? data.fileId.value : this.fileId,
      progress: data.progress.present ? data.progress.value : this.progress,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UploadTask(')
          ..write('id: $id, ')
          ..write('fileId: $fileId, ')
          ..write('progress: $progress, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fileId, progress, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UploadTask &&
          other.id == this.id &&
          other.fileId == this.fileId &&
          other.progress == this.progress &&
          other.status == this.status);
}

class UploadTasksCompanion extends UpdateCompanion<UploadTask> {
  final Value<String> id;
  final Value<String> fileId;
  final Value<int> progress;
  final Value<String> status;
  final Value<int> rowid;
  const UploadTasksCompanion({
    this.id = const Value.absent(),
    this.fileId = const Value.absent(),
    this.progress = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UploadTasksCompanion.insert({
    required String id,
    required String fileId,
    this.progress = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fileId = Value(fileId);
  static Insertable<UploadTask> custom({
    Expression<String>? id,
    Expression<String>? fileId,
    Expression<int>? progress,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fileId != null) 'file_id': fileId,
      if (progress != null) 'progress': progress,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UploadTasksCompanion copyWith({
    Value<String>? id,
    Value<String>? fileId,
    Value<int>? progress,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return UploadTasksCompanion(
      id: id ?? this.id,
      fileId: fileId ?? this.fileId,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fileId.present) {
      map['file_id'] = Variable<String>(fileId.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UploadTasksCompanion(')
          ..write('id: $id, ')
          ..write('fileId: $fileId, ')
          ..write('progress: $progress, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, color];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final String id;
  final String name;
  final String? color;
  const Tag({required this.id, required this.name, this.color});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
    );
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String?>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String?>(color),
    };
  }

  Tag copyWith({
    String? id,
    String? name,
    Value<String?> color = const Value.absent(),
  }) => Tag(
    id: id ?? this.id,
    name: name ?? this.name,
    color: color.present ? color.value : this.color,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> color;
  final Value<int> rowid;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    required String id,
    required String name,
    this.color = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Tag> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? color,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? color,
    Value<int>? rowid,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FileTagsTable extends FileTags with TableInfo<$FileTagsTable, FileTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FileTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fileIdMeta = const VerificationMeta('fileId');
  @override
  late final GeneratedColumn<String> fileId = GeneratedColumn<String>(
    'file_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES files (id)',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [fileId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'file_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<FileTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('file_id')) {
      context.handle(
        _fileIdMeta,
        fileId.isAcceptableOrUnknown(data['file_id']!, _fileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fileIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {fileId, tagId};
  @override
  FileTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FileTag(
      fileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $FileTagsTable createAlias(String alias) {
    return $FileTagsTable(attachedDatabase, alias);
  }
}

class FileTag extends DataClass implements Insertable<FileTag> {
  final String fileId;
  final String tagId;
  const FileTag({required this.fileId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['file_id'] = Variable<String>(fileId);
    map['tag_id'] = Variable<String>(tagId);
    return map;
  }

  FileTagsCompanion toCompanion(bool nullToAbsent) {
    return FileTagsCompanion(fileId: Value(fileId), tagId: Value(tagId));
  }

  factory FileTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FileTag(
      fileId: serializer.fromJson<String>(json['fileId']),
      tagId: serializer.fromJson<String>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fileId': serializer.toJson<String>(fileId),
      'tagId': serializer.toJson<String>(tagId),
    };
  }

  FileTag copyWith({String? fileId, String? tagId}) =>
      FileTag(fileId: fileId ?? this.fileId, tagId: tagId ?? this.tagId);
  FileTag copyWithCompanion(FileTagsCompanion data) {
    return FileTag(
      fileId: data.fileId.present ? data.fileId.value : this.fileId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FileTag(')
          ..write('fileId: $fileId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(fileId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FileTag &&
          other.fileId == this.fileId &&
          other.tagId == this.tagId);
}

class FileTagsCompanion extends UpdateCompanion<FileTag> {
  final Value<String> fileId;
  final Value<String> tagId;
  final Value<int> rowid;
  const FileTagsCompanion({
    this.fileId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FileTagsCompanion.insert({
    required String fileId,
    required String tagId,
    this.rowid = const Value.absent(),
  }) : fileId = Value(fileId),
       tagId = Value(tagId);
  static Insertable<FileTag> custom({
    Expression<String>? fileId,
    Expression<String>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (fileId != null) 'file_id': fileId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FileTagsCompanion copyWith({
    Value<String>? fileId,
    Value<String>? tagId,
    Value<int>? rowid,
  }) {
    return FileTagsCompanion(
      fileId: fileId ?? this.fileId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fileId.present) {
      map['file_id'] = Variable<String>(fileId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FileTagsCompanion(')
          ..write('fileId: $fileId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TombstonesTable extends Tombstones
    with TableInfo<$TombstonesTable, Tombstone> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TombstonesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _telegramMessageIdMeta = const VerificationMeta(
    'telegramMessageId',
  );
  @override
  late final GeneratedColumn<int> telegramMessageId = GeneratedColumn<int>(
    'telegram_message_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _telegramChatIdMeta = const VerificationMeta(
    'telegramChatId',
  );
  @override
  late final GeneratedColumn<int> telegramChatId = GeneratedColumn<int>(
    'telegram_chat_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _telegramFileIdMeta = const VerificationMeta(
    'telegramFileId',
  );
  @override
  late final GeneratedColumn<int> telegramFileId = GeneratedColumn<int>(
    'telegram_file_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _telegramRemoteIdMeta = const VerificationMeta(
    'telegramRemoteId',
  );
  @override
  late final GeneratedColumn<String> telegramRemoteId = GeneratedColumn<String>(
    'telegram_remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deleteStatusMeta = const VerificationMeta(
    'deleteStatus',
  );
  @override
  late final GeneratedColumn<String> deleteStatus = GeneratedColumn<String>(
    'delete_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    telegramMessageId,
    telegramChatId,
    telegramFileId,
    telegramRemoteId,
    deletedAt,
    deleteStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tombstones';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tombstone> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('telegram_message_id')) {
      context.handle(
        _telegramMessageIdMeta,
        telegramMessageId.isAcceptableOrUnknown(
          data['telegram_message_id']!,
          _telegramMessageIdMeta,
        ),
      );
    }
    if (data.containsKey('telegram_chat_id')) {
      context.handle(
        _telegramChatIdMeta,
        telegramChatId.isAcceptableOrUnknown(
          data['telegram_chat_id']!,
          _telegramChatIdMeta,
        ),
      );
    }
    if (data.containsKey('telegram_file_id')) {
      context.handle(
        _telegramFileIdMeta,
        telegramFileId.isAcceptableOrUnknown(
          data['telegram_file_id']!,
          _telegramFileIdMeta,
        ),
      );
    }
    if (data.containsKey('telegram_remote_id')) {
      context.handle(
        _telegramRemoteIdMeta,
        telegramRemoteId.isAcceptableOrUnknown(
          data['telegram_remote_id']!,
          _telegramRemoteIdMeta,
        ),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('delete_status')) {
      context.handle(
        _deleteStatusMeta,
        deleteStatus.isAcceptableOrUnknown(
          data['delete_status']!,
          _deleteStatusMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {telegramMessageId};
  @override
  Tombstone map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tombstone(
      telegramMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}telegram_message_id'],
      )!,
      telegramChatId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}telegram_chat_id'],
      ),
      telegramFileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}telegram_file_id'],
      ),
      telegramRemoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telegram_remote_id'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      )!,
      deleteStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}delete_status'],
      ),
    );
  }

  @override
  $TombstonesTable createAlias(String alias) {
    return $TombstonesTable(attachedDatabase, alias);
  }
}

class Tombstone extends DataClass implements Insertable<Tombstone> {
  final int telegramMessageId;
  final int? telegramChatId;
  final int? telegramFileId;
  final String? telegramRemoteId;
  final DateTime deletedAt;
  final String? deleteStatus;
  const Tombstone({
    required this.telegramMessageId,
    this.telegramChatId,
    this.telegramFileId,
    this.telegramRemoteId,
    required this.deletedAt,
    this.deleteStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['telegram_message_id'] = Variable<int>(telegramMessageId);
    if (!nullToAbsent || telegramChatId != null) {
      map['telegram_chat_id'] = Variable<int>(telegramChatId);
    }
    if (!nullToAbsent || telegramFileId != null) {
      map['telegram_file_id'] = Variable<int>(telegramFileId);
    }
    if (!nullToAbsent || telegramRemoteId != null) {
      map['telegram_remote_id'] = Variable<String>(telegramRemoteId);
    }
    map['deleted_at'] = Variable<DateTime>(deletedAt);
    if (!nullToAbsent || deleteStatus != null) {
      map['delete_status'] = Variable<String>(deleteStatus);
    }
    return map;
  }

  TombstonesCompanion toCompanion(bool nullToAbsent) {
    return TombstonesCompanion(
      telegramMessageId: Value(telegramMessageId),
      telegramChatId: telegramChatId == null && nullToAbsent
          ? const Value.absent()
          : Value(telegramChatId),
      telegramFileId: telegramFileId == null && nullToAbsent
          ? const Value.absent()
          : Value(telegramFileId),
      telegramRemoteId: telegramRemoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(telegramRemoteId),
      deletedAt: Value(deletedAt),
      deleteStatus: deleteStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(deleteStatus),
    );
  }

  factory Tombstone.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tombstone(
      telegramMessageId: serializer.fromJson<int>(json['telegramMessageId']),
      telegramChatId: serializer.fromJson<int?>(json['telegramChatId']),
      telegramFileId: serializer.fromJson<int?>(json['telegramFileId']),
      telegramRemoteId: serializer.fromJson<String?>(json['telegramRemoteId']),
      deletedAt: serializer.fromJson<DateTime>(json['deletedAt']),
      deleteStatus: serializer.fromJson<String?>(json['deleteStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'telegramMessageId': serializer.toJson<int>(telegramMessageId),
      'telegramChatId': serializer.toJson<int?>(telegramChatId),
      'telegramFileId': serializer.toJson<int?>(telegramFileId),
      'telegramRemoteId': serializer.toJson<String?>(telegramRemoteId),
      'deletedAt': serializer.toJson<DateTime>(deletedAt),
      'deleteStatus': serializer.toJson<String?>(deleteStatus),
    };
  }

  Tombstone copyWith({
    int? telegramMessageId,
    Value<int?> telegramChatId = const Value.absent(),
    Value<int?> telegramFileId = const Value.absent(),
    Value<String?> telegramRemoteId = const Value.absent(),
    DateTime? deletedAt,
    Value<String?> deleteStatus = const Value.absent(),
  }) => Tombstone(
    telegramMessageId: telegramMessageId ?? this.telegramMessageId,
    telegramChatId: telegramChatId.present
        ? telegramChatId.value
        : this.telegramChatId,
    telegramFileId: telegramFileId.present
        ? telegramFileId.value
        : this.telegramFileId,
    telegramRemoteId: telegramRemoteId.present
        ? telegramRemoteId.value
        : this.telegramRemoteId,
    deletedAt: deletedAt ?? this.deletedAt,
    deleteStatus: deleteStatus.present ? deleteStatus.value : this.deleteStatus,
  );
  Tombstone copyWithCompanion(TombstonesCompanion data) {
    return Tombstone(
      telegramMessageId: data.telegramMessageId.present
          ? data.telegramMessageId.value
          : this.telegramMessageId,
      telegramChatId: data.telegramChatId.present
          ? data.telegramChatId.value
          : this.telegramChatId,
      telegramFileId: data.telegramFileId.present
          ? data.telegramFileId.value
          : this.telegramFileId,
      telegramRemoteId: data.telegramRemoteId.present
          ? data.telegramRemoteId.value
          : this.telegramRemoteId,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deleteStatus: data.deleteStatus.present
          ? data.deleteStatus.value
          : this.deleteStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tombstone(')
          ..write('telegramMessageId: $telegramMessageId, ')
          ..write('telegramChatId: $telegramChatId, ')
          ..write('telegramFileId: $telegramFileId, ')
          ..write('telegramRemoteId: $telegramRemoteId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deleteStatus: $deleteStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    telegramMessageId,
    telegramChatId,
    telegramFileId,
    telegramRemoteId,
    deletedAt,
    deleteStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tombstone &&
          other.telegramMessageId == this.telegramMessageId &&
          other.telegramChatId == this.telegramChatId &&
          other.telegramFileId == this.telegramFileId &&
          other.telegramRemoteId == this.telegramRemoteId &&
          other.deletedAt == this.deletedAt &&
          other.deleteStatus == this.deleteStatus);
}

class TombstonesCompanion extends UpdateCompanion<Tombstone> {
  final Value<int> telegramMessageId;
  final Value<int?> telegramChatId;
  final Value<int?> telegramFileId;
  final Value<String?> telegramRemoteId;
  final Value<DateTime> deletedAt;
  final Value<String?> deleteStatus;
  const TombstonesCompanion({
    this.telegramMessageId = const Value.absent(),
    this.telegramChatId = const Value.absent(),
    this.telegramFileId = const Value.absent(),
    this.telegramRemoteId = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deleteStatus = const Value.absent(),
  });
  TombstonesCompanion.insert({
    this.telegramMessageId = const Value.absent(),
    this.telegramChatId = const Value.absent(),
    this.telegramFileId = const Value.absent(),
    this.telegramRemoteId = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deleteStatus = const Value.absent(),
  });
  static Insertable<Tombstone> custom({
    Expression<int>? telegramMessageId,
    Expression<int>? telegramChatId,
    Expression<int>? telegramFileId,
    Expression<String>? telegramRemoteId,
    Expression<DateTime>? deletedAt,
    Expression<String>? deleteStatus,
  }) {
    return RawValuesInsertable({
      if (telegramMessageId != null) 'telegram_message_id': telegramMessageId,
      if (telegramChatId != null) 'telegram_chat_id': telegramChatId,
      if (telegramFileId != null) 'telegram_file_id': telegramFileId,
      if (telegramRemoteId != null) 'telegram_remote_id': telegramRemoteId,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deleteStatus != null) 'delete_status': deleteStatus,
    });
  }

  TombstonesCompanion copyWith({
    Value<int>? telegramMessageId,
    Value<int?>? telegramChatId,
    Value<int?>? telegramFileId,
    Value<String?>? telegramRemoteId,
    Value<DateTime>? deletedAt,
    Value<String?>? deleteStatus,
  }) {
    return TombstonesCompanion(
      telegramMessageId: telegramMessageId ?? this.telegramMessageId,
      telegramChatId: telegramChatId ?? this.telegramChatId,
      telegramFileId: telegramFileId ?? this.telegramFileId,
      telegramRemoteId: telegramRemoteId ?? this.telegramRemoteId,
      deletedAt: deletedAt ?? this.deletedAt,
      deleteStatus: deleteStatus ?? this.deleteStatus,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (telegramMessageId.present) {
      map['telegram_message_id'] = Variable<int>(telegramMessageId.value);
    }
    if (telegramChatId.present) {
      map['telegram_chat_id'] = Variable<int>(telegramChatId.value);
    }
    if (telegramFileId.present) {
      map['telegram_file_id'] = Variable<int>(telegramFileId.value);
    }
    if (telegramRemoteId.present) {
      map['telegram_remote_id'] = Variable<String>(telegramRemoteId.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deleteStatus.present) {
      map['delete_status'] = Variable<String>(deleteStatus.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TombstonesCompanion(')
          ..write('telegramMessageId: $telegramMessageId, ')
          ..write('telegramChatId: $telegramChatId, ')
          ..write('telegramFileId: $telegramFileId, ')
          ..write('telegramRemoteId: $telegramRemoteId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deleteStatus: $deleteStatus')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FilesTable files = $FilesTable(this);
  late final $FoldersTable folders = $FoldersTable(this);
  late final $UploadTasksTable uploadTasks = $UploadTasksTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $FileTagsTable fileTags = $FileTagsTable(this);
  late final $TombstonesTable tombstones = $TombstonesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    files,
    folders,
    uploadTasks,
    tags,
    fileTags,
    tombstones,
  ];
}

typedef $$FilesTableCreateCompanionBuilder =
    FilesCompanion Function({
      required String id,
      Value<int?> telegramMessageId,
      Value<int?> telegramFileId,
      Value<String?> telegramRemoteId,
      required String name,
      required int size,
      required String mimeType,
      required String path,
      Value<String?> localPath,
      Value<int?> telegramThumbnailId,
      Value<String?> thumbnailLocalPath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> syncStatus,
      Value<String> downloadStatus,
      Value<String?> folderId,
      Value<bool> isFavorite,
      Value<bool> isDeleted,
      Value<DateTime?> lastOpenedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$FilesTableUpdateCompanionBuilder =
    FilesCompanion Function({
      Value<String> id,
      Value<int?> telegramMessageId,
      Value<int?> telegramFileId,
      Value<String?> telegramRemoteId,
      Value<String> name,
      Value<int> size,
      Value<String> mimeType,
      Value<String> path,
      Value<String?> localPath,
      Value<int?> telegramThumbnailId,
      Value<String?> thumbnailLocalPath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> syncStatus,
      Value<String> downloadStatus,
      Value<String?> folderId,
      Value<bool> isFavorite,
      Value<bool> isDeleted,
      Value<DateTime?> lastOpenedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$FilesTableReferences
    extends BaseReferences<_$AppDatabase, $FilesTable, StorageFile> {
  $$FilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UploadTasksTable, List<UploadTask>>
  _uploadTasksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.uploadTasks,
    aliasName: 'files__id__upload_tasks__file_id',
  );

  $$UploadTasksTableProcessedTableManager get uploadTasksRefs {
    final manager = $$UploadTasksTableTableManager(
      $_db,
      $_db.uploadTasks,
    ).filter((f) => f.fileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_uploadTasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FileTagsTable, List<FileTag>> _fileTagsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.fileTags,
    aliasName: 'files__id__file_tags__file_id',
  );

  $$FileTagsTableProcessedTableManager get fileTagsRefs {
    final manager = $$FileTagsTableTableManager(
      $_db,
      $_db.fileTags,
    ).filter((f) => f.fileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_fileTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FilesTableFilterComposer extends Composer<_$AppDatabase, $FilesTable> {
  $$FilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get telegramMessageId => $composableBuilder(
    column: $table.telegramMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get telegramFileId => $composableBuilder(
    column: $table.telegramFileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telegramRemoteId => $composableBuilder(
    column: $table.telegramRemoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get telegramThumbnailId => $composableBuilder(
    column: $table.telegramThumbnailId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailLocalPath => $composableBuilder(
    column: $table.thumbnailLocalPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get downloadStatus => $composableBuilder(
    column: $table.downloadStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get folderId => $composableBuilder(
    column: $table.folderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> uploadTasksRefs(
    Expression<bool> Function($$UploadTasksTableFilterComposer f) f,
  ) {
    final $$UploadTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.uploadTasks,
      getReferencedColumn: (t) => t.fileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UploadTasksTableFilterComposer(
            $db: $db,
            $table: $db.uploadTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> fileTagsRefs(
    Expression<bool> Function($$FileTagsTableFilterComposer f) f,
  ) {
    final $$FileTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fileTags,
      getReferencedColumn: (t) => t.fileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FileTagsTableFilterComposer(
            $db: $db,
            $table: $db.fileTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FilesTableOrderingComposer
    extends Composer<_$AppDatabase, $FilesTable> {
  $$FilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get telegramMessageId => $composableBuilder(
    column: $table.telegramMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get telegramFileId => $composableBuilder(
    column: $table.telegramFileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telegramRemoteId => $composableBuilder(
    column: $table.telegramRemoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get telegramThumbnailId => $composableBuilder(
    column: $table.telegramThumbnailId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailLocalPath => $composableBuilder(
    column: $table.thumbnailLocalPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get downloadStatus => $composableBuilder(
    column: $table.downloadStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get folderId => $composableBuilder(
    column: $table.folderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FilesTable> {
  $$FilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get telegramMessageId => $composableBuilder(
    column: $table.telegramMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get telegramFileId => $composableBuilder(
    column: $table.telegramFileId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get telegramRemoteId => $composableBuilder(
    column: $table.telegramRemoteId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<int> get telegramThumbnailId => $composableBuilder(
    column: $table.telegramThumbnailId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get thumbnailLocalPath => $composableBuilder(
    column: $table.thumbnailLocalPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get downloadStatus => $composableBuilder(
    column: $table.downloadStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get folderId =>
      $composableBuilder(column: $table.folderId, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> uploadTasksRefs<T extends Object>(
    Expression<T> Function($$UploadTasksTableAnnotationComposer a) f,
  ) {
    final $$UploadTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.uploadTasks,
      getReferencedColumn: (t) => t.fileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UploadTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.uploadTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> fileTagsRefs<T extends Object>(
    Expression<T> Function($$FileTagsTableAnnotationComposer a) f,
  ) {
    final $$FileTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fileTags,
      getReferencedColumn: (t) => t.fileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FileTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.fileTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FilesTable,
          StorageFile,
          $$FilesTableFilterComposer,
          $$FilesTableOrderingComposer,
          $$FilesTableAnnotationComposer,
          $$FilesTableCreateCompanionBuilder,
          $$FilesTableUpdateCompanionBuilder,
          (StorageFile, $$FilesTableReferences),
          StorageFile,
          PrefetchHooks Function({bool uploadTasksRefs, bool fileTagsRefs})
        > {
  $$FilesTableTableManager(_$AppDatabase db, $FilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int?> telegramMessageId = const Value.absent(),
                Value<int?> telegramFileId = const Value.absent(),
                Value<String?> telegramRemoteId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> size = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<int?> telegramThumbnailId = const Value.absent(),
                Value<String?> thumbnailLocalPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> downloadStatus = const Value.absent(),
                Value<String?> folderId = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> lastOpenedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FilesCompanion(
                id: id,
                telegramMessageId: telegramMessageId,
                telegramFileId: telegramFileId,
                telegramRemoteId: telegramRemoteId,
                name: name,
                size: size,
                mimeType: mimeType,
                path: path,
                localPath: localPath,
                telegramThumbnailId: telegramThumbnailId,
                thumbnailLocalPath: thumbnailLocalPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                downloadStatus: downloadStatus,
                folderId: folderId,
                isFavorite: isFavorite,
                isDeleted: isDeleted,
                lastOpenedAt: lastOpenedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int?> telegramMessageId = const Value.absent(),
                Value<int?> telegramFileId = const Value.absent(),
                Value<String?> telegramRemoteId = const Value.absent(),
                required String name,
                required int size,
                required String mimeType,
                required String path,
                Value<String?> localPath = const Value.absent(),
                Value<int?> telegramThumbnailId = const Value.absent(),
                Value<String?> thumbnailLocalPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> downloadStatus = const Value.absent(),
                Value<String?> folderId = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> lastOpenedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FilesCompanion.insert(
                id: id,
                telegramMessageId: telegramMessageId,
                telegramFileId: telegramFileId,
                telegramRemoteId: telegramRemoteId,
                name: name,
                size: size,
                mimeType: mimeType,
                path: path,
                localPath: localPath,
                telegramThumbnailId: telegramThumbnailId,
                thumbnailLocalPath: thumbnailLocalPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                downloadStatus: downloadStatus,
                folderId: folderId,
                isFavorite: isFavorite,
                isDeleted: isDeleted,
                lastOpenedAt: lastOpenedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$FilesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({uploadTasksRefs = false, fileTagsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (uploadTasksRefs) db.uploadTasks,
                    if (fileTagsRefs) db.fileTags,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (uploadTasksRefs)
                        await $_getPrefetchedData<
                          StorageFile,
                          $FilesTable,
                          UploadTask
                        >(
                          currentTable: table,
                          referencedTable: $$FilesTableReferences
                              ._uploadTasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FilesTableReferences(
                                db,
                                table,
                                p0,
                              ).uploadTasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.fileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (fileTagsRefs)
                        await $_getPrefetchedData<
                          StorageFile,
                          $FilesTable,
                          FileTag
                        >(
                          currentTable: table,
                          referencedTable: $$FilesTableReferences
                              ._fileTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FilesTableReferences(
                                db,
                                table,
                                p0,
                              ).fileTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.fileId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FilesTable,
      StorageFile,
      $$FilesTableFilterComposer,
      $$FilesTableOrderingComposer,
      $$FilesTableAnnotationComposer,
      $$FilesTableCreateCompanionBuilder,
      $$FilesTableUpdateCompanionBuilder,
      (StorageFile, $$FilesTableReferences),
      StorageFile,
      PrefetchHooks Function({bool uploadTasksRefs, bool fileTagsRefs})
    >;
typedef $$FoldersTableCreateCompanionBuilder =
    FoldersCompanion Function({
      required String id,
      required int accountId,
      required String name,
      Value<String?> parentFolderId,
      Value<String?> color,
      Value<String?> icon,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<int> sortOrder,
      Value<int?> telegramMessageId,
      Value<int> rowid,
    });
typedef $$FoldersTableUpdateCompanionBuilder =
    FoldersCompanion Function({
      Value<String> id,
      Value<int> accountId,
      Value<String> name,
      Value<String?> parentFolderId,
      Value<String?> color,
      Value<String?> icon,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<int> sortOrder,
      Value<int?> telegramMessageId,
      Value<int> rowid,
    });

class $$FoldersTableFilterComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentFolderId => $composableBuilder(
    column: $table.parentFolderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get telegramMessageId => $composableBuilder(
    column: $table.telegramMessageId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoldersTableOrderingComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentFolderId => $composableBuilder(
    column: $table.parentFolderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get telegramMessageId => $composableBuilder(
    column: $table.telegramMessageId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoldersTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get parentFolderId => $composableBuilder(
    column: $table.parentFolderId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get telegramMessageId => $composableBuilder(
    column: $table.telegramMessageId,
    builder: (column) => column,
  );
}

class $$FoldersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoldersTable,
          Folder,
          $$FoldersTableFilterComposer,
          $$FoldersTableOrderingComposer,
          $$FoldersTableAnnotationComposer,
          $$FoldersTableCreateCompanionBuilder,
          $$FoldersTableUpdateCompanionBuilder,
          (Folder, BaseReferences<_$AppDatabase, $FoldersTable, Folder>),
          Folder,
          PrefetchHooks Function()
        > {
  $$FoldersTableTableManager(_$AppDatabase db, $FoldersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoldersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoldersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoldersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> parentFolderId = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int?> telegramMessageId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoldersCompanion(
                id: id,
                accountId: accountId,
                name: name,
                parentFolderId: parentFolderId,
                color: color,
                icon: icon,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                sortOrder: sortOrder,
                telegramMessageId: telegramMessageId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int accountId,
                required String name,
                Value<String?> parentFolderId = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int?> telegramMessageId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoldersCompanion.insert(
                id: id,
                accountId: accountId,
                name: name,
                parentFolderId: parentFolderId,
                color: color,
                icon: icon,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                sortOrder: sortOrder,
                telegramMessageId: telegramMessageId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoldersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoldersTable,
      Folder,
      $$FoldersTableFilterComposer,
      $$FoldersTableOrderingComposer,
      $$FoldersTableAnnotationComposer,
      $$FoldersTableCreateCompanionBuilder,
      $$FoldersTableUpdateCompanionBuilder,
      (Folder, BaseReferences<_$AppDatabase, $FoldersTable, Folder>),
      Folder,
      PrefetchHooks Function()
    >;
typedef $$UploadTasksTableCreateCompanionBuilder =
    UploadTasksCompanion Function({
      required String id,
      required String fileId,
      Value<int> progress,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$UploadTasksTableUpdateCompanionBuilder =
    UploadTasksCompanion Function({
      Value<String> id,
      Value<String> fileId,
      Value<int> progress,
      Value<String> status,
      Value<int> rowid,
    });

final class $$UploadTasksTableReferences
    extends BaseReferences<_$AppDatabase, $UploadTasksTable, UploadTask> {
  $$UploadTasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FilesTable _fileIdTable(_$AppDatabase db) =>
      db.files.createAlias('upload_tasks__file_id__files__id');

  $$FilesTableProcessedTableManager get fileId {
    final $_column = $_itemColumn<String>('file_id')!;

    final manager = $$FilesTableTableManager(
      $_db,
      $_db.files,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UploadTasksTableFilterComposer
    extends Composer<_$AppDatabase, $UploadTasksTable> {
  $$UploadTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  $$FilesTableFilterComposer get fileId {
    final $$FilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fileId,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableFilterComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UploadTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $UploadTasksTable> {
  $$UploadTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$FilesTableOrderingComposer get fileId {
    final $$FilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fileId,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableOrderingComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UploadTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $UploadTasksTable> {
  $$UploadTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$FilesTableAnnotationComposer get fileId {
    final $$FilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fileId,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableAnnotationComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UploadTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UploadTasksTable,
          UploadTask,
          $$UploadTasksTableFilterComposer,
          $$UploadTasksTableOrderingComposer,
          $$UploadTasksTableAnnotationComposer,
          $$UploadTasksTableCreateCompanionBuilder,
          $$UploadTasksTableUpdateCompanionBuilder,
          (UploadTask, $$UploadTasksTableReferences),
          UploadTask,
          PrefetchHooks Function({bool fileId})
        > {
  $$UploadTasksTableTableManager(_$AppDatabase db, $UploadTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UploadTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UploadTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UploadTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fileId = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UploadTasksCompanion(
                id: id,
                fileId: fileId,
                progress: progress,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fileId,
                Value<int> progress = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UploadTasksCompanion.insert(
                id: id,
                fileId: fileId,
                progress: progress,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UploadTasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({fileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (fileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.fileId,
                                referencedTable: $$UploadTasksTableReferences
                                    ._fileIdTable(db),
                                referencedColumn: $$UploadTasksTableReferences
                                    ._fileIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UploadTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UploadTasksTable,
      UploadTask,
      $$UploadTasksTableFilterComposer,
      $$UploadTasksTableOrderingComposer,
      $$UploadTasksTableAnnotationComposer,
      $$UploadTasksTableCreateCompanionBuilder,
      $$UploadTasksTableUpdateCompanionBuilder,
      (UploadTask, $$UploadTasksTableReferences),
      UploadTask,
      PrefetchHooks Function({bool fileId})
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({
      required String id,
      required String name,
      Value<String?> color,
      Value<int> rowid,
    });
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> color,
      Value<int> rowid,
    });

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FileTagsTable, List<FileTag>> _fileTagsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.fileTags,
    aliasName: 'tags__id__file_tags__tag_id',
  );

  $$FileTagsTableProcessedTableManager get fileTagsRefs {
    final manager = $$FileTagsTableTableManager(
      $_db,
      $_db.fileTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_fileTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> fileTagsRefs(
    Expression<bool> Function($$FileTagsTableFilterComposer f) f,
  ) {
    final $$FileTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fileTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FileTagsTableFilterComposer(
            $db: $db,
            $table: $db.fileTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  Expression<T> fileTagsRefs<T extends Object>(
    Expression<T> Function($$FileTagsTableAnnotationComposer a) f,
  ) {
    final $$FileTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fileTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FileTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.fileTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({bool fileTagsRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) =>
                  TagsCompanion(id: id, name: name, color: color, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> color = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion.insert(
                id: id,
                name: name,
                color: color,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TagsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({fileTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (fileTagsRefs) db.fileTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (fileTagsRefs)
                    await $_getPrefetchedData<Tag, $TagsTable, FileTag>(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences._fileTagsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$TagsTableReferences(db, table, p0).fileTagsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({bool fileTagsRefs})
    >;
typedef $$FileTagsTableCreateCompanionBuilder =
    FileTagsCompanion Function({
      required String fileId,
      required String tagId,
      Value<int> rowid,
    });
typedef $$FileTagsTableUpdateCompanionBuilder =
    FileTagsCompanion Function({
      Value<String> fileId,
      Value<String> tagId,
      Value<int> rowid,
    });

final class $$FileTagsTableReferences
    extends BaseReferences<_$AppDatabase, $FileTagsTable, FileTag> {
  $$FileTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FilesTable _fileIdTable(_$AppDatabase db) =>
      db.files.createAlias('file_tags__file_id__files__id');

  $$FilesTableProcessedTableManager get fileId {
    final $_column = $_itemColumn<String>('file_id')!;

    final manager = $$FilesTableTableManager(
      $_db,
      $_db.files,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias('file_tags__tag_id__tags__id');

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<String>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FileTagsTableFilterComposer
    extends Composer<_$AppDatabase, $FileTagsTable> {
  $$FileTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$FilesTableFilterComposer get fileId {
    final $$FilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fileId,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableFilterComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FileTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $FileTagsTable> {
  $$FileTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$FilesTableOrderingComposer get fileId {
    final $$FilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fileId,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableOrderingComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FileTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FileTagsTable> {
  $$FileTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$FilesTableAnnotationComposer get fileId {
    final $$FilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fileId,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableAnnotationComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FileTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FileTagsTable,
          FileTag,
          $$FileTagsTableFilterComposer,
          $$FileTagsTableOrderingComposer,
          $$FileTagsTableAnnotationComposer,
          $$FileTagsTableCreateCompanionBuilder,
          $$FileTagsTableUpdateCompanionBuilder,
          (FileTag, $$FileTagsTableReferences),
          FileTag,
          PrefetchHooks Function({bool fileId, bool tagId})
        > {
  $$FileTagsTableTableManager(_$AppDatabase db, $FileTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FileTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FileTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FileTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> fileId = const Value.absent(),
                Value<String> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) =>
                  FileTagsCompanion(fileId: fileId, tagId: tagId, rowid: rowid),
          createCompanionCallback:
              ({
                required String fileId,
                required String tagId,
                Value<int> rowid = const Value.absent(),
              }) => FileTagsCompanion.insert(
                fileId: fileId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FileTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({fileId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (fileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.fileId,
                                referencedTable: $$FileTagsTableReferences
                                    ._fileIdTable(db),
                                referencedColumn: $$FileTagsTableReferences
                                    ._fileIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (tagId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tagId,
                                referencedTable: $$FileTagsTableReferences
                                    ._tagIdTable(db),
                                referencedColumn: $$FileTagsTableReferences
                                    ._tagIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FileTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FileTagsTable,
      FileTag,
      $$FileTagsTableFilterComposer,
      $$FileTagsTableOrderingComposer,
      $$FileTagsTableAnnotationComposer,
      $$FileTagsTableCreateCompanionBuilder,
      $$FileTagsTableUpdateCompanionBuilder,
      (FileTag, $$FileTagsTableReferences),
      FileTag,
      PrefetchHooks Function({bool fileId, bool tagId})
    >;
typedef $$TombstonesTableCreateCompanionBuilder =
    TombstonesCompanion Function({
      Value<int> telegramMessageId,
      Value<int?> telegramChatId,
      Value<int?> telegramFileId,
      Value<String?> telegramRemoteId,
      Value<DateTime> deletedAt,
      Value<String?> deleteStatus,
    });
typedef $$TombstonesTableUpdateCompanionBuilder =
    TombstonesCompanion Function({
      Value<int> telegramMessageId,
      Value<int?> telegramChatId,
      Value<int?> telegramFileId,
      Value<String?> telegramRemoteId,
      Value<DateTime> deletedAt,
      Value<String?> deleteStatus,
    });

class $$TombstonesTableFilterComposer
    extends Composer<_$AppDatabase, $TombstonesTable> {
  $$TombstonesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get telegramMessageId => $composableBuilder(
    column: $table.telegramMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get telegramChatId => $composableBuilder(
    column: $table.telegramChatId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get telegramFileId => $composableBuilder(
    column: $table.telegramFileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telegramRemoteId => $composableBuilder(
    column: $table.telegramRemoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deleteStatus => $composableBuilder(
    column: $table.deleteStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TombstonesTableOrderingComposer
    extends Composer<_$AppDatabase, $TombstonesTable> {
  $$TombstonesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get telegramMessageId => $composableBuilder(
    column: $table.telegramMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get telegramChatId => $composableBuilder(
    column: $table.telegramChatId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get telegramFileId => $composableBuilder(
    column: $table.telegramFileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telegramRemoteId => $composableBuilder(
    column: $table.telegramRemoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deleteStatus => $composableBuilder(
    column: $table.deleteStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TombstonesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TombstonesTable> {
  $$TombstonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get telegramMessageId => $composableBuilder(
    column: $table.telegramMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get telegramChatId => $composableBuilder(
    column: $table.telegramChatId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get telegramFileId => $composableBuilder(
    column: $table.telegramFileId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get telegramRemoteId => $composableBuilder(
    column: $table.telegramRemoteId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deleteStatus => $composableBuilder(
    column: $table.deleteStatus,
    builder: (column) => column,
  );
}

class $$TombstonesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TombstonesTable,
          Tombstone,
          $$TombstonesTableFilterComposer,
          $$TombstonesTableOrderingComposer,
          $$TombstonesTableAnnotationComposer,
          $$TombstonesTableCreateCompanionBuilder,
          $$TombstonesTableUpdateCompanionBuilder,
          (
            Tombstone,
            BaseReferences<_$AppDatabase, $TombstonesTable, Tombstone>,
          ),
          Tombstone,
          PrefetchHooks Function()
        > {
  $$TombstonesTableTableManager(_$AppDatabase db, $TombstonesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TombstonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TombstonesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TombstonesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> telegramMessageId = const Value.absent(),
                Value<int?> telegramChatId = const Value.absent(),
                Value<int?> telegramFileId = const Value.absent(),
                Value<String?> telegramRemoteId = const Value.absent(),
                Value<DateTime> deletedAt = const Value.absent(),
                Value<String?> deleteStatus = const Value.absent(),
              }) => TombstonesCompanion(
                telegramMessageId: telegramMessageId,
                telegramChatId: telegramChatId,
                telegramFileId: telegramFileId,
                telegramRemoteId: telegramRemoteId,
                deletedAt: deletedAt,
                deleteStatus: deleteStatus,
              ),
          createCompanionCallback:
              ({
                Value<int> telegramMessageId = const Value.absent(),
                Value<int?> telegramChatId = const Value.absent(),
                Value<int?> telegramFileId = const Value.absent(),
                Value<String?> telegramRemoteId = const Value.absent(),
                Value<DateTime> deletedAt = const Value.absent(),
                Value<String?> deleteStatus = const Value.absent(),
              }) => TombstonesCompanion.insert(
                telegramMessageId: telegramMessageId,
                telegramChatId: telegramChatId,
                telegramFileId: telegramFileId,
                telegramRemoteId: telegramRemoteId,
                deletedAt: deletedAt,
                deleteStatus: deleteStatus,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TombstonesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TombstonesTable,
      Tombstone,
      $$TombstonesTableFilterComposer,
      $$TombstonesTableOrderingComposer,
      $$TombstonesTableAnnotationComposer,
      $$TombstonesTableCreateCompanionBuilder,
      $$TombstonesTableUpdateCompanionBuilder,
      (Tombstone, BaseReferences<_$AppDatabase, $TombstonesTable, Tombstone>),
      Tombstone,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FilesTableTableManager get files =>
      $$FilesTableTableManager(_db, _db.files);
  $$FoldersTableTableManager get folders =>
      $$FoldersTableTableManager(_db, _db.folders);
  $$UploadTasksTableTableManager get uploadTasks =>
      $$UploadTasksTableTableManager(_db, _db.uploadTasks);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$FileTagsTableTableManager get fileTags =>
      $$FileTagsTableTableManager(_db, _db.fileTags);
  $$TombstonesTableTableManager get tombstones =>
      $$TombstonesTableTableManager(_db, _db.tombstones);
}
