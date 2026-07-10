import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_provider.dart';
import '../database/database.dart';
import '../database/daos.dart';
import '../services/telegram_storage_service.dart';
import '../services/nova_logger.dart';

class TrashState {
  final List<Folder> folders;
  final List<FileWithTask> files;
  final bool isLoading;

  TrashState({
    this.folders = const [],
    this.files = const [],
    this.isLoading = true,
  });

  TrashState copyWith({
    List<Folder>? folders,
    List<FileWithTask>? files,
    bool? isLoading,
  }) {
    return TrashState(
      folders: folders ?? this.folders,
      files: files ?? this.files,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class TrashNotifier extends Notifier<TrashState> {
  @override
  TrashState build() {
    _initStreams();
    return TrashState();
  }

  void _initStreams() {
    final dao = ref.watch(daoProvider);
    
    // Watch folders
    dao.watchTrashedFolders().listen((folders) {
      state = state.copyWith(folders: folders, isLoading: false);
    });

    // Watch files
    dao.watchTrashedFiles().listen((files) {
      state = state.copyWith(files: files, isLoading: false);
    });
  }

  Future<void> restore(String id, bool isFolder) async {
    final dao = ref.read(daoProvider);
    await dao.restoreFromTrash(id, isFolder);
    NovaLogger.file('Restored ${isFolder ? 'folder' : 'file'} from trash: $id');
  }

  Future<void> permanentlyDelete(String id, bool isFolder) async {
    final dao = ref.read(daoProvider);
    if (isFolder) {
      final messageIds = await dao.recursiveGetFolderMessageIds(id);
      if (messageIds.isNotEmpty) {
        final storage = ref.read(telegramStorageProvider);
        await storage.deleteMessages(messageIds);
      }
      await dao.recursiveDeleteFolder(id);
    } else {
      final file = await dao.getFileById(id);
      if (file != null && file.telegramMessageId != null) {
        final storage = ref.read(telegramStorageProvider);
        await storage.deleteMessages([file.telegramMessageId!]);
      }
      await dao.deleteFile(id);
    }
  }

  Future<void> emptyTrash() async {
    final messageIds = state.files
        .map((f) => f.file.telegramMessageId)
        .where((id) => id != null)
        .cast<int>()
        .toList();

    if (messageIds.isNotEmpty) {
      final storage = ref.read(telegramStorageProvider);
      await storage.deleteMessages(messageIds);
    }

    final dao = ref.read(daoProvider);
    for (final folder in state.folders) {
      await dao.recursiveDeleteFolder(folder.id);
    }
  }
}

final trashProvider = NotifierProvider<TrashNotifier, TrashState>(() {
  return TrashNotifier();
});
