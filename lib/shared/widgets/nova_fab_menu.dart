import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';

class NovaFabMenu extends StatefulWidget {
  final VoidCallback onUploadFile;
  final VoidCallback onCreateFolder;

  const NovaFabMenu({
    super.key,
    required this.onUploadFile,
    required this.onCreateFolder,
  });

  @override
  State<NovaFabMenu> createState() => _NovaFabMenuState();
}

class _NovaFabMenuState extends State<NovaFabMenu> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_isOpen) ...[
          ScaleTransition(
            scale: _expandAnimation,
            child: FloatingActionButton.extended(
              heroTag: 'createFolder',
              onPressed: () {
                _toggle();
                widget.onCreateFolder();
              },
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              icon: const Icon(Icons.create_new_folder),
              label: const Text('Create Folder'),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ScaleTransition(
            scale: _expandAnimation,
            child: FloatingActionButton.extended(
              heroTag: 'uploadFile',
              onPressed: () {
                _toggle();
                widget.onUploadFile();
              },
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload File'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        FloatingActionButton(
          heroTag: 'mainFab',
          onPressed: _toggle,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _animationController,
          ),
        ),
      ],
    );
  }
}
