import 'package:flutter/material.dart';

class NovaSelectionToolbar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedCount;
  final VoidCallback onClear;
  final VoidCallback? onRestore;
  final VoidCallback? onDeletePermanently;
  final VoidCallback? onSelectAll;
  final VoidCallback? onMove;
  final VoidCallback? onFavorite;
  final VoidCallback? onTrash;

  const NovaSelectionToolbar({
    super.key,
    required this.selectedCount,
    required this.onClear,
    this.onMove,
    this.onFavorite,
    this.onTrash,
    this.onRestore,
    this.onDeletePermanently,
    this.onSelectAll,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: onClear,
      ),
      title: Text(
        '$selectedCount selected',
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
      actions: [
        if (onSelectAll != null)
          IconButton(
            icon: const Icon(Icons.select_all),
            tooltip: 'Select all',
            onPressed: onSelectAll,
          ),
        if (onRestore != null)
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Restore',
            onPressed: onRestore,
          ),
        if (onMove != null)
          IconButton(
            icon: const Icon(Icons.drive_file_move),
            tooltip: 'Move',
            onPressed: onMove,
          ),
        if (onFavorite != null)
          IconButton(
            icon: const Icon(Icons.star),
            tooltip: 'Favorite',
            onPressed: onFavorite,
          ),
        if (onTrash != null)
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Move to trash',
            onPressed: onTrash,
          ),
        if (onDeletePermanently != null)
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            tooltip: 'Delete permanently',
            onPressed: onDeletePermanently,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
