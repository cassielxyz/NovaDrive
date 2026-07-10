import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../../core/database/database_provider.dart';
import '../../core/database/database.dart';
import '../../core/theme/app_spacing.dart';
import 'nova_folder_card.dart';

class NovaMoveDialog extends ConsumerStatefulWidget {
  final List<String> fileIdsToMove;
  final List<String> folderIdsToMove;

  const NovaMoveDialog({
    super.key,
    required this.fileIdsToMove,
    required this.folderIdsToMove,
  });

  static Future<void> show({
    required BuildContext context,
    required List<String> fileIds,
    required List<String> folderIds,
  }) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => NovaMoveDialog(
        fileIdsToMove: fileIds,
        folderIdsToMove: folderIds,
      ),
    );
  }

  @override
  ConsumerState<NovaMoveDialog> createState() => _NovaMoveDialogState();
}

class _NovaMoveDialogState extends ConsumerState<NovaMoveDialog> {
  String? _currentFolderId;
  List<Folder> _hierarchy = [];

  @override
  void initState() {
    super.initState();
    _loadHierarchy();
  }

  Future<void> _loadHierarchy() async {
    if (_currentFolderId == null) {
      if (mounted) setState(() => _hierarchy = []);
      return;
    }
    final dao = ref.read(daoProvider);
    final h = await dao.getFolderHierarchy(_currentFolderId!);
    if (mounted) setState(() => _hierarchy = h);
  }

  void _navigateTo(String? folderId) {
    setState(() => _currentFolderId = folderId);
    _loadHierarchy();
  }

  Future<void> _performMove() async {
    final dao = ref.read(daoProvider);
    
    // Prevent recursive move: moving a folder into itself or its children is not allowed, 
    // but a basic check is to prevent moving a folder if _hierarchy contains it.
    if (_currentFolderId != null) {
      if (widget.folderIdsToMove.contains(_currentFolderId!)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot move a folder into itself')));
        return;
      }
      for (final h in _hierarchy) {
        if (widget.folderIdsToMove.contains(h.id)) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot move a folder into its own subfolder')));
          return;
        }
      }
    }

    // Update files
    for (final fileId in widget.fileIdsToMove) {
      final files = await dao.getAllFiles();
      final file = files.firstWhere((f) => f.id == fileId);
      await dao.updateFile(file.copyWith(folderId: Value(_currentFolderId)));
    }

    // Update folders
    for (final folderId in widget.folderIdsToMove) {
      final folder = await dao.getFolderById(folderId);
      if (folder != null) {
        await dao.updateFolder(folder.copyWith(parentFolderId: Value(_currentFolderId)));
      }
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final dao = ref.watch(daoProvider);
    // Ideally we filter by account, but we can just use the watchFoldersByParent
    // Let's get accountId from somewhere or we can just query all folders by parent for now.
    // To simplify, we get foldersStream using current accountId.
    // For now, let's just query db.
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: _currentFolderId != null
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          if (_hierarchy.length > 1) {
                            _navigateTo(_hierarchy[_hierarchy.length - 2].id);
                          } else {
                            _navigateTo(null);
                          }
                        },
                      )
                    : const SizedBox.shrink(),
                title: Text(_currentFolderId == null ? 'My Drive' : _hierarchy.lastOrNull?.name ?? ''),
                actions: [
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              Expanded(
                child: StreamBuilder<List<Folder>>(
                  stream: dao.watchFoldersByParentNoAccount(_currentFolderId),
                  builder: (context, snapshot) {
                    final folders = snapshot.data ?? [];
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: folders.length,
                      itemBuilder: (context, index) {
                        final folder = folders[index];
                        if (widget.folderIdsToMove.contains(folder.id)) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: NovaFolderCard(
                            folderName: folder.name,
                            onTap: () => _navigateTo(folder.id),
                            onMoreTap: () {},
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: _performMove,
                  child: const Text('Move Here'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
