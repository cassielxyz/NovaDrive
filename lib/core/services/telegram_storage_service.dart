import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handy_tdlib/handy_tdlib.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
import '../telegram_core/tdlib_bridge.dart';
import '../database/database_provider.dart';
import '../database/database.dart';
import 'nova_logger.dart';

final telegramStorageProvider = Provider<TelegramStorageService>((ref) {
  return TelegramStorageService(ref.watch(tdlibBridgeProvider), ref);
});

class StorageInitializedNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setInitialized(bool value) {
    state = value;
  }
}

final storageInitializedProvider = NotifierProvider<StorageInitializedNotifier, bool>(() {
  return StorageInitializedNotifier();
});
class TelegramStorageService {
  final TdlibBridge _bridge;
  final Ref _ref;
  int? _savedMessagesChatId;
  int? get savedMessagesChatId => _savedMessagesChatId;
  User? currentUser;
  bool _isInitializing = false;
  bool _isInitialized = false;
  Completer<void>? _initCompleter;

  TelegramStorageService(this._bridge, this._ref);

  Future<void> initialize() async {
    // Guard against duplicate initialization
    if (_isInitialized) return;
    if (_isInitializing) {
      // Another call is already in progress — wait for it
      return _initCompleter?.future ?? Future.value();
    }
    _isInitializing = true;
    _initCompleter = Completer<void>();

    final completer = _initCompleter!;
    StreamSubscription? sub;
    sub = _bridge.updates.listen((object) {
      if (object is User) {
        NovaLogger.tdlib('GetMe success: YES');
        NovaLogger.tdlib('Self user ID resolved: YES');
        currentUser = object;
        _ref.read(storageInitializedProvider.notifier).setInitialized(true);
        if (object.profilePhoto != null && !object.profilePhoto!.small.local.isDownloadingCompleted) {
          downloadFile(object.profilePhoto!.small.id);
        }
        _bridge.send(CreatePrivateChat(userId: object.id, force: false));
      } else if (object is Chat) {
        NovaLogger.tdlib('Self chat resolved: YES');
        _savedMessagesChatId = object.id;
        _ref.read(storageInitializedProvider.notifier).setInitialized(true);
        NovaLogger.tdlib('Self chat ID ready: YES');
        _isInitialized = true;
        _isInitializing = false;
        if (!completer.isCompleted) completer.complete();
        sub?.cancel();
      }
    });

    _bridge.send(GetMe());
    await completer.future;
  }

  Future<void> uploadFile(String localPath, {String? folderId}) async {
    if (_savedMessagesChatId == null) await initialize();
    if (_savedMessagesChatId == null) return;

    NovaLogger.upload('Sending to self chat: YES');
    
    final localId = const Uuid().v4();
    final fileName = path.basename(localPath);
    final size = io.File(localPath).lengthSync();

    final dao = _ref.read(daoProvider);
    await dao.insertFileCompanion(FilesCompanion.insert(
      id: localId,
      name: fileName,
      folderId: drift.Value(folderId),
      size: size,
      createdAt: drift.Value(DateTime.now()),
      updatedAt: drift.Value(DateTime.now()),
      syncStatus: const drift.Value('queued'),
      downloadStatus: const drift.Value('downloaded'),
      mimeType: 'application/octet-stream', // default fallback, ideally detected
      path: '', // deprecated but required by companion if no default? wait, it has a default? No, we will just pass empty string if it's required by constructor.
      localPath: drift.Value(localPath),
    ));

    await dao.insertUploadTaskCompanion(UploadTasksCompanion.insert(
      id: 'task_$localId',
      fileId: localId,
      status: const drift.Value('queued'),
      progress: const drift.Value(0),
    ));
    
    final metadata = {
      "v": 1,
      "source": "nova_drive",
      "type": "file",
      "localId": localId,
    };
    if (folderId != null) {
      metadata["folderId"] = folderId;
    }
    final jsonStr = jsonEncode(metadata);

    _bridge.send(SendMessage(
      chatId: _savedMessagesChatId!,
      messageThreadId: 0,
      replyTo: null,
      options: MessageSendOptions(
        disableNotification: true,
        fromBackground: true,
        protectContent: false,
        schedulingState: null,
        effectId: 0,
        onlyPreview: false,
        sendingId: 0,
        updateOrderOfInstalledStickerSets: false,
      ),
      replyMarkup: null,
      inputMessageContent: InputMessageDocument(
        document: InputFileLocal(path: localPath),
        thumbnail: null,
        disableContentTypeDetection: true, // Force as document to prevent compression
        caption: FormattedText(
          text: '#novadrive\n$jsonStr',
          entities: [],
        ),
      ),
    ));
    NovaLogger.upload('SendMessage returned: YES');
  }

  Future<void> createFolder(String folderId, String name, {String? parentFolderId}) async {
    if (_savedMessagesChatId == null) await initialize();
    if (_savedMessagesChatId == null) return;

    final metadata = {
      "v": 1,
      "source": "nova_drive",
      "type": "folder",
      "folderId": folderId,
      "name": name,
      "parentFolderId": parentFolderId,
      "createdAt": DateTime.now().toIso8601String(),
      "updatedAt": DateTime.now().toIso8601String()
    };
    
    final jsonStr = jsonEncode(metadata);
    
    _bridge.send(SendMessage(
      chatId: _savedMessagesChatId!,
      messageThreadId: 0,
      replyTo: null,
      options: MessageSendOptions(
        disableNotification: true,
        fromBackground: true,
        protectContent: false,
        schedulingState: null,
        effectId: 0,
        onlyPreview: false,
        sendingId: 0,
        updateOrderOfInstalledStickerSets: false,
      ),
      replyMarkup: null,
      inputMessageContent: InputMessageText(
        text: FormattedText(
          text: '#novadrive\n$jsonStr',
          entities: [],
        ),
        clearDraft: false,
      ),
    ));
    NovaLogger.upload('Create folder message sent: YES');
  }

  Future<void> downloadFile(int fileId) async {
    _bridge.send(DownloadFile(
      fileId: fileId,
      priority: 1,
      offset: 0,
      limit: 0,
      synchronous: false,
    ));
  }

  Future<void> deleteMessages(List<int> messageIds) async {
    if (_savedMessagesChatId == null) await initialize();
    if (_savedMessagesChatId == null) return;
    
    _bridge.send(DeleteMessages(
      chatId: _savedMessagesChatId!,
      messageIds: messageIds,
      revoke: true, // Delete for all users
    ));
    NovaLogger.upload('DeleteMessages sent for ${messageIds.length} messages');
  }
}
