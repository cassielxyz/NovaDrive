import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/trash_provider.dart';
import '../../core/database/database.dart';
import '../../shared/widgets/nova_file_card.dart';

class TrashScreen extends ConsumerWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trashState = ref.watch(trashProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Trash'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Empty Trash',
            onPressed: trashState.files.isEmpty && trashState.folders.isEmpty 
              ? null 
              : () => _emptyTrash(context, ref),
          ),
        ],
      ),
      body: trashState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : (trashState.files.isEmpty && trashState.folders.isEmpty)
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: trashState.folders.length + trashState.files.length,
                  itemBuilder: (context, index) {
                    if (index < trashState.folders.length) {
                      final folder = trashState.folders[index];
                      return _buildFolderTile(context, ref, folder);
                    }
                    final fileWithTask = trashState.files[index - trashState.folders.length];
                    final file = fileWithTask.file;
                    return NovaFileCard(
                      key: ValueKey('trash_${file.id}'),
                      fileId: file.id,
                      fileName: file.name,
                      fileSize: '${(file.size / 1024).toStringAsFixed(1)} KB',
                      mimeType: file.mimeType,
                      localPath: file.localPath,
                      thumbnailLocalPath: file.thumbnailLocalPath,
                      onTap: () {
                        _showRestoreDialog(context, ref, file.id, false);
                      },
                      onMoreTap: () => _showRestoreDialog(context, ref, file.id, false),
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete_outline, size: 80, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            'Trash is empty',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog(BuildContext context, WidgetRef ref, String id, bool isFolder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore?'),
        content: Text(isFolder ? 'Restore this folder and all its contents?' : 'Restore this file?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(trashProvider.notifier).restore(id, isFolder);
            },
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderTile(BuildContext context, WidgetRef ref, Folder folder) {
    return ListTile(
      leading: const Icon(Icons.folder, size: 40, color: Colors.amber),
      title: Text(folder.name, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: const Text('Folder'),
      trailing: IconButton(
        icon: const Icon(Icons.restore),
        onPressed: () => _showRestoreDialog(context, ref, folder.id, true),
      ),
      onTap: () => _showRestoreDialog(context, ref, folder.id, true),
    );
  }

  void _emptyTrash(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Empty Trash?'),
        content: const Text('Permanently delete everything in Trash? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(trashProvider.notifier).emptyTrash();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Empty Trash'),
          ),
        ],
      ),
    );
  }
}
