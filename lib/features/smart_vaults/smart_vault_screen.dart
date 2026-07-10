import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/database/database_provider.dart';
import '../../core/database/daos.dart';

import '../../shared/widgets/nova_file_card.dart';
import '../../shared/widgets/nova_empty_state.dart';
import '../../core/services/file_download_service.dart';
import '../../shared/widgets/nova_action_bottom_sheet.dart';
import '../../core/providers/selection_provider.dart';
import '../../core/services/telegram_storage_service.dart';
import '../../shared/widgets/nova_selection_toolbar.dart';
import 'package:flutter/services.dart';

class SmartVaultScreen extends ConsumerWidget {
  final String title;

  const SmartVaultScreen({super.key, required this.title});

  void _showFileActions(BuildContext context, WidgetRef ref, dynamic file) {
    NovaActionBottomSheet.show(
      context: context,
      title: file.name,
      actions: [
        NovaActionItem(
          icon: file.isFavorite ? Icons.star : Icons.star_border,
          label: file.isFavorite ? 'Remove from favorites' : 'Add to favorites',
          onTap: () {
            ref.read(daoProvider).updateFile(file.copyWith(isFavorite: !file.isFavorite));
          },
        ),
        if (title == 'Trash')
          NovaActionItem(
            icon: Icons.restore,
            label: 'Restore from trash',
            onTap: () {
              ref.read(daoProvider).updateFile(file.copyWith(isDeleted: false));
            },
          )
        else
          NovaActionItem(
            icon: Icons.delete,
            label: 'Move to trash',
            isDestructive: true,
            onTap: () {
              ref.read(daoProvider).updateFile(file.copyWith(isDeleted: true));
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dao = ref.watch(daoProvider);
    
    Stream<List<FileWithTask>> stream;
    if (title == 'Favorites') {
      stream = dao.watchFilesWithTasks(isFavorite: true, isDeleted: false);
    } else if (title == 'Recents') {
      stream = dao.watchFilesWithTasks(isRecent: true, isDeleted: false);
    } else if (title == 'Trash') {
      stream = dao.watchFilesWithTasks(isDeleted: true);
    } else {
      stream = dao.watchSmartCollection(title);
    }

    final selection = ref.watch(selectionProvider);
    final isSelectionMode = !selection.isEmpty;

    return Scaffold(
      appBar: isSelectionMode
          ? NovaSelectionToolbar(
              selectedCount: selection.count,
              onClear: () => ref.read(selectionProvider.notifier).clear(),
              onSelectAll: () async {
                final files = await stream.first;
                for (final item in files) {
                  ref.read(selectionProvider.notifier).toggleFile(item.file.id);
                }
              },
              onRestore: title == 'Trash' ? () async {
                for (final fileId in selection.selectedFileIds) {
                  final file = await dao.getFileById(fileId);
                  if (file != null) await dao.updateFile(file.copyWith(isDeleted: false));
                }
                ref.read(selectionProvider.notifier).clear();
              } : null,
              onDeletePermanently: title == 'Trash' ? () async {
                final storage = ref.read(telegramStorageProvider);
                final telegramIdsToDelete = <int>[];
                for (final fileId in selection.selectedFileIds) {
                  final file = await dao.getFileById(fileId);
                  if (file != null) {
                    if (file.telegramMessageId != null) {
                      telegramIdsToDelete.add(file.telegramMessageId!);
                    }
                    await dao.deleteFile(fileId);
                  }
                }
                if (telegramIdsToDelete.isNotEmpty) {
                  await storage.deleteMessages(telegramIdsToDelete);
                }
                ref.read(selectionProvider.notifier).clear();
              } : null,
              onTrash: title != 'Trash' ? () async {
                for (final fileId in selection.selectedFileIds) {
                  final file = await dao.getFileById(fileId);
                  if (file != null) await dao.updateFile(file.copyWith(isDeleted: true));
                }
                ref.read(selectionProvider.notifier).clear();
              } : null,
            )
          : AppBar(
              title: Text(title),
            ),
      body: StreamBuilder<List<FileWithTask>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return NovaEmptyState(
              icon: title == 'Trash' ? Icons.delete_outline : Icons.folder_open,
              title: 'Empty $title',
              subtitle: 'No files found in this collection.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final file = item.file;
              
              return NovaFileCard(
                key: ValueKey('vault_${file.id}'),
                fileId: file.id,
                fileName: file.name,
                fileSize: '${(file.size / 1024).toStringAsFixed(1)} KB',
                mimeType: file.mimeType,
                localPath: file.localPath,
                thumbnailLocalPath: file.thumbnailLocalPath,
                isSelected: selection.selectedFileIds.contains(file.id),
                selectionMode: isSelectionMode,
                onLongPress: () {
                  if (!isSelectionMode) {
                    HapticFeedback.mediumImpact();
                    ref.read(selectionProvider.notifier).toggleFile(file.id);
                  }
                },
                onTap: () {
                  if (isSelectionMode) {
                    ref.read(selectionProvider.notifier).toggleFile(file.id);
                    return;
                  }
                  if (title == 'Trash') return; // Cannot open deleted files
                  if (file.telegramFileId != null) {
                    ref.read(fileDownloadProvider).downloadAndOpenFile(
                      telegramFileId: file.telegramFileId!,
                      localPath: file.path,
                    );
                  }
                },
                onMoreTap: () => _showFileActions(context, ref, file),
              );
            },
          );
        },
      ),
    );
  }
}
