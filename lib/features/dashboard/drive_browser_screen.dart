import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/nova_fluid_sweep.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;

import '../../core/theme/app_spacing.dart';
import '../../core/database/database_provider.dart';
import '../../core/database/database.dart';

import '../../core/services/telegram_storage_service.dart';
import '../../core/services/nova_logger.dart';
import '../../core/services/file_download_service.dart';
import '../../core/providers/selection_provider.dart';

import '../../core/providers/storage_stats_provider.dart';
import '../../core/providers/paginated_files_provider.dart';
import '../../core/providers/thumbnail_provider.dart';
import '../../core/providers/backend_coordinator_provider.dart';

import '../../shared/widgets/nova_file_card.dart';
import '../../shared/widgets/nova_storage_overview_card.dart';
import '../../shared/widgets/nova_folder_card.dart';
import '../../shared/widgets/nova_search_bar.dart';
import '../../shared/widgets/nova_empty_state.dart';
import '../../shared/widgets/nova_fab_menu.dart';
import '../../shared/widgets/nova_action_bottom_sheet.dart';
import '../../shared/widgets/nova_selection_toolbar.dart';
import '../../shared/widgets/nova_move_dialog.dart';
import '../../shared/widgets/nova_glass_card.dart';
import '../../shared/widgets/nova_filter_sort_bottom_sheet.dart';
import '../../shared/widgets/nova_profile_bottom_sheet.dart';
import 'package:handy_tdlib/handy_tdlib.dart' as td;

class DriveBrowserScreen extends ConsumerStatefulWidget {
  final String? currentFolderId;

  const DriveBrowserScreen({super.key, this.currentFolderId});

  @override
  ConsumerState<DriveBrowserScreen> createState() => _DriveBrowserScreenState();
}

class _DriveBrowserScreenState extends ConsumerState<DriveBrowserScreen> {
  bool _isGridView = false;
  List<Folder> _hierarchy = [];

  @override
  void initState() {
    super.initState();
    NovaLogger.route('DriveBrowser mounted. FolderId: ${widget.currentFolderId}');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final storage = ref.read(telegramStorageProvider);
      await storage.initialize();
      _loadFolderInfo();
      
      // Delay sync to let UI settle
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && storage.savedMessagesChatId != null) {
          ref.read(backendCoordinatorProvider.notifier).startBackgroundSync(storage.savedMessagesChatId!);
        }
      });
    });
  }

  Future<void> _loadFolderInfo() async {
    if (widget.currentFolderId != null) {
      final dao = ref.read(daoProvider);
      final hierarchy = await dao.getFolderHierarchy(widget.currentFolderId!);
      if (mounted) {
        setState(() {
          _hierarchy = hierarchy;
        });
      }
    }
  }

  void _showFileActions(StorageFile file) {
    NovaActionBottomSheet.show(
      context: context,
      title: file.name,
      actions: [
        NovaActionItem(
          icon: Icons.edit,
          label: 'Rename',
          onTap: () {},
        ),
        NovaActionItem(
          icon: Icons.drive_file_move,
          label: 'Move to folder',
          onTap: () {},
        ),
        NovaActionItem(
          icon: file.isFavorite ? Icons.star : Icons.star_border,
          label: file.isFavorite ? 'Remove from favorites' : 'Add to favorites',
          onTap: () {
            ref.read(daoProvider).updateFile(file.copyWith(isFavorite: !file.isFavorite));
          },
        ),
        NovaActionItem(
          icon: Icons.delete,
          label: 'Move to trash',
          isDestructive: true,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Move to Trash?'),
                content: const Text('This file will be moved to the Trash. You can restore it or permanently delete it later.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await ref.read(daoProvider).moveToTrash(file.id, false);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                    ),
                    child: const Text('Move to Trash'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _showFolderActions(Folder folder) {
    NovaActionBottomSheet.show(
      context: context,
      title: folder.name,
      actions: [
        NovaActionItem(
          icon: Icons.edit,
          label: 'Rename',
          onTap: () {},
        ),
        NovaActionItem(
          icon: Icons.delete,
          label: 'Move to Trash',
          isDestructive: true,
          onTap: () {
            ref.read(daoProvider).moveToTrash(folder.id, true);
          },
        ),
      ],
    );
  }

  void _createFolder() {
    // Show dialog to create folder
    showDialog(
      context: context,
      builder: (dialogContext) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('New Folder'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Folder name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  final storage = ref.read(telegramStorageProvider);
                  if (storage.savedMessagesChatId != null) {
                    final folderId = const Uuid().v4();
                    await storage.createFolder(
                      folderId,
                      name,
                      parentFolderId: widget.currentFolderId,
                    );
                  }
                }
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }


  Widget _buildSmartVaults() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          _buildVaultCard(context, 'Recents', Icons.schedule, () => context.push('/recents')),
          const SizedBox(width: AppSpacing.sm),
          _buildVaultCard(context, 'Favorites', Icons.star, () => context.push('/favorites')),
          const SizedBox(width: AppSpacing.sm),
          _buildVaultCard(context, 'Trash', Icons.delete, () => context.push('/trash')),
        ],
      ),
    );
  }

  Widget _buildVaultCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return NovaGlassCard(
      onTap: onTap,
      width: 100,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 32),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dao = ref.watch(daoProvider);
    final storage = ref.watch(telegramStorageProvider);
    
    final backendStatus = ref.watch(backendCoordinatorProvider);
    final foldersStream = storage.savedMessagesChatId != null 
        ? dao.watchFoldersByParent(widget.currentFolderId, storage.savedMessagesChatId!)
        : const Stream<List<Folder>>.empty();

    final paginatedController = ref.watch(paginatedControllerProvider(widget.currentFolderId));

    final selection = ref.watch(selectionProvider);
    final isSelectionMode = !selection.isEmpty;
    
    final storageStatsAsync = ref.watch(storageStatsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: paginatedController,
          builder: (context, _) {
            final paginatedState = paginatedController.state;
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                // Load more files when scrolled near bottom
                if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 300) {
                  if (paginatedState.hasMore && !paginatedState.isLoading) {
                    paginatedController.loadMore();
                  }
                }
                return false;
              },
              child: CustomScrollView(
            slivers: [
              if (isSelectionMode)
                SliverToBoxAdapter(
                  child: NovaSelectionToolbar(
                    selectedCount: selection.count,
                    onClear: () => ref.read(selectionProvider.notifier).clear(),
                    onMove: () async {
                      await NovaMoveDialog.show(
                        context: context,
                        fileIds: selection.selectedFileIds.toList(),
                        folderIds: selection.selectedFolderIds.toList(),
                      );
                      ref.read(selectionProvider.notifier).clear();
                    },
                    onFavorite: () async {
                      // Optimized: query individual files by ID instead of loading all files
                      for (final fileId in selection.selectedFileIds) {
                        final file = await dao.getFileById(fileId);
                        if (file != null) {
                          await dao.updateFile(file.copyWith(isFavorite: true));
                        }
                      }
                      ref.read(selectionProvider.notifier).clear();
                    },
                    onTrash: () async {
                      for (final fileId in selection.selectedFileIds) {
                        await dao.moveToTrash(fileId, false);
                      }
                      for (final folderId in selection.selectedFolderIds) {
                        await dao.moveToTrash(folderId, true);
                      }
                      ref.read(selectionProvider.notifier).clear();
                    },
                  ),
                )
              else
                SliverAppBar(
                  floating: true,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  title: SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        if (widget.currentFolderId != null) ...[
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => context.pop(),
                          ),
                        ],
                        GestureDetector(
                          onTap: () => context.go('/dashboard'),
                          child: Center(
                            child: Row(
                              children: [
                                _NovaAnimatedTitle(isHome: widget.currentFolderId == null),
                                if (backendStatus.isSyncing)
                                  const Padding(
                                    padding: EdgeInsets.only(left: AppSpacing.sm),
                                    child: SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        for (final folder in _hierarchy) ...[
                          const Center(child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                            child: Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                          )),
                          GestureDetector(
                            onTap: () => context.push('/folder/${folder.id}'),
                            child: Center(
                              child: Text(
                                folder.name, 
                                style: TextStyle(
                                  fontWeight: folder.id == widget.currentFolderId ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => context.push('/trash'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.md),
                      child: storage.currentUser != null
                          ? _NovaProfileIcon(user: storage.currentUser!)
                          : const CircleAvatar(
                              radius: 18,
                              child: Icon(Icons.person, size: 20),
                            ),
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(70),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
                      child: NovaSearchBar(
                        onTap: () => context.push('/search'),
                        readOnly: true,
                      ),
                    ),
                  ),
                ),
            
              if (!isSelectionMode && widget.currentFolderId == null)
                SliverToBoxAdapter(
                  child: storageStatsAsync.when(
                    data: (stats) => NovaStorageOverviewCard(stats: stats),
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ),

              if (!isSelectionMode && widget.currentFolderId == null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text('Smart Vaults', style: Theme.of(context).textTheme.titleMedium),
                  ),
                ),
              if (!isSelectionMode && widget.currentFolderId == null)
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.sm),
                      _buildSmartVaults(),
                    ],
                  ),
                ),
            


              // Folders Section
              StreamBuilder<List<Folder>>(
                stream: foldersStream,
                builder: (context, snapshot) {
                  final folders = snapshot.data ?? [];
                  if (folders.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

                  return SliverPadding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    sliver: SliverMainAxisGroup(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Folders', style: Theme.of(context).textTheme.titleMedium),
                                IconButton(
                                  icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
                                  onPressed: () => setState(() => _isGridView = !_isGridView),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_isGridView)
                          SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: AppSpacing.sm,
                              mainAxisSpacing: AppSpacing.sm,
                              childAspectRatio: 1.2,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              addRepaintBoundaries: true,
                              addSemanticIndexes: false,
                              (context, index) {
                                final folder = folders[index];
                                return NovaFolderCard(
                                  key: ValueKey('folder_${folder.id}'),
                                  folderName: folder.name,
                                  isSelected: selection.selectedFolderIds.contains(folder.id),
                                  selectionMode: isSelectionMode,
                                  onTap: () {
                                    if (isSelectionMode) {
                                      ref.read(selectionProvider.notifier).toggleFolder(folder.id);
                                    } else {
                                      context.push('/folder/${folder.id}');
                                    }
                                  },
                                  onLongPress: () {
                                    if (!isSelectionMode) {
                                      ref.read(selectionProvider.notifier).toggleFolder(folder.id);
                                    }
                                  },
                                  onMoreTap: () => _showFolderActions(folder),
                                );
                              },
                              childCount: folders.length,
                            ),
                          )
                        else
                          SliverList.builder(
                            addRepaintBoundaries: true,
                            addSemanticIndexes: false,
                            itemCount: folders.length,
                            itemBuilder: (context, index) {
                              final folder = folders[index];
                              return Padding(
                                key: ValueKey('folder_${folder.id}'),
                                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                                child: NovaFolderCard(
                                  folderName: folder.name,
                                  isSelected: selection.selectedFolderIds.contains(folder.id),
                                  selectionMode: isSelectionMode,
                                  onTap: () {
                                    if (isSelectionMode) {
                                      ref.read(selectionProvider.notifier).toggleFolder(folder.id);
                                    } else {
                                      context.push('/folder/${folder.id}');
                                    }
                                  },
                                  onLongPress: () {
                                    if (!isSelectionMode) {
                                      ref.read(selectionProvider.notifier).toggleFolder(folder.id);
                                    }
                                  },
                                  onMoreTap: () => _showFolderActions(folder),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  );
                },
              ),

              // Drop Zone / Files Section Header
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.currentFolderId == null ? 'Drop Zone' : 'Files', style: Theme.of(context).textTheme.titleMedium),
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () {
                          NovaFilterSortBottomSheet.show(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Files list — now using paginated provider with SliverList.builder
              if (paginatedState.files.isEmpty && !paginatedState.isLoading)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  sliver: const SliverToBoxAdapter(
                    child: NovaEmptyState(
                      icon: Icons.cloud_upload_outlined,
                      title: 'No files',
                      subtitle: 'Upload files or create folders to get started.',
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  sliver: SliverList.builder(
                    addRepaintBoundaries: true,
                    addSemanticIndexes: false,
                    itemCount: paginatedState.files.length + (paginatedState.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show loading indicator at the end
                      if (index >= paginatedState.files.length) {
                        return const Padding(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final item = paginatedState.files[index];
                      final file = item.file;
                      // Removed unused variables

                      // Lazy thumbnail request — only when item is visible
                      if (file.telegramThumbnailId != null && file.thumbnailLocalPath == null) {
                        ref.read(thumbnailManagerProvider).requestThumbnail(file.telegramThumbnailId!);
                      }

                      return NovaFileCard(
                        key: ValueKey('file_${file.id}'),
                        fileId: file.id,
                        fileName: file.name,
                        fileSize: '${(file.size / 1024).toStringAsFixed(1)} KB',
                        mimeType: file.mimeType,
                        localPath: file.localPath,
                        thumbnailLocalPath: file.thumbnailLocalPath,
                        isSelected: selection.selectedFileIds.contains(file.id),
                        selectionMode: isSelectionMode,
                        onTap: () {
                          if (isSelectionMode) {
                            ref.read(selectionProvider.notifier).toggleFile(file.id);
                          } else {
                            // Update lastOpenedAt when opened
                            dao.updateFile(file.copyWith(lastOpenedAt: drift.Value(DateTime.now())));
                            if (file.telegramFileId != null) {
                              ref.read(fileDownloadProvider).downloadAndOpenFile(
                                telegramFileId: file.telegramFileId!,
                                localPath: file.path,
                              );
                            }
                          }
                        },
                        onLongPress: () {
                          if (!isSelectionMode) {
                            ref.read(selectionProvider.notifier).toggleFile(file.id);
                          }
                        },
                        onMoreTap: () => _showFileActions(file),
                      );
                    },
                  ),
                ),

              // Bottom padding to scroll past FAB and floating nav bar
              const SliverToBoxAdapter(
                child: SizedBox(height: 120),
              ),
            ],
          ),
        );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: NovaFabMenu(
          onUploadFile: () async {
            final result = await FilePicker.pickFiles();
            if (result != null && result.files.single.path != null) {
              NovaLogger.upload('File picked: YES');
              ref.read(telegramStorageProvider).uploadFile(
                result.files.single.path!,
                folderId: widget.currentFolderId,
              );
            }
          },
          onCreateFolder: _createFolder,
        ),
      ),
    );
  }
}

class _NovaAnimatedTitle extends StatefulWidget {
  final bool isHome;
  const _NovaAnimatedTitle({this.isHome = true});

  @override
  State<_NovaAnimatedTitle> createState() => _NovaAnimatedTitleState();
}

class _NovaAnimatedTitleState extends State<_NovaAnimatedTitle> {
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final hsl = HSLColor.fromColor(primary);
    final darkColor = hsl.withLightness((hsl.lightness - 0.2).clamp(0.0, 1.0)).toColor();
    final lightColor = hsl.withLightness((hsl.lightness + 0.2).clamp(0.0, 1.0)).toColor();
    final adjacentColor = hsl.withHue((hsl.hue + 30) % 360).toColor();

    return FluidSweepText(
      text: 'Nova Drive',
      colors: [darkColor, lightColor, adjacentColor, primary, darkColor],
      isStroke: true,
      strokeWidth: widget.isHome ? 0.8 : 0.5,
      style: TextStyle(
        fontFamily: 'Outfit',
        fontSize: widget.isHome ? 28 : 18,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.italic,
        letterSpacing: widget.isHome ? -0.5 : 0.0,
      ),
    );
  }
}

class _NovaProfileIcon extends StatefulWidget {
  final td.User user;

  const _NovaProfileIcon({required this.user});

  @override
  State<_NovaProfileIcon> createState() => _NovaProfileIconState();
}

class _NovaProfileIconState extends State<_NovaProfileIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = (widget.user.profilePhoto?.small.local.isDownloadingCompleted ?? false) &&
        widget.user.profilePhoto!.small.local.path.isNotEmpty;
        
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () {
        NovaProfileBottomSheet.show(context, widget.user);
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _ProfileGradientPainter(
              rotation: _controller.value,
              primaryColor: primaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0), // Space for the border
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                backgroundImage: hasPhoto ? FileImage(File(widget.user.profilePhoto!.small.local.path)) : null,
                child: hasPhoto
                    ? null
                    : Text(
                        widget.user.firstName.isNotEmpty ? widget.user.firstName[0] : 'U',
                        style: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfileGradientPainter extends CustomPainter {
  final double rotation;
  final Color primaryColor;

  _ProfileGradientPainter({required this.rotation, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final hsl = HSLColor.fromColor(primaryColor);
    final darkColor = hsl.withLightness((hsl.lightness - 0.2).clamp(0.0, 1.0)).toColor();
    final lightColor = hsl.withLightness((hsl.lightness + 0.2).clamp(0.0, 1.0)).toColor();
    final adjacentColor = hsl.withHue((hsl.hue + 30) % 360).toColor();

    final paint = Paint()
      ..shader = SweepGradient(
        colors: [
          darkColor,
          lightColor,
          adjacentColor,
          primaryColor,
          darkColor,
        ],
        transform: GradientRotation(rotation * 2 * 3.14159),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_ProfileGradientPainter oldDelegate) => 
      rotation != oldDelegate.rotation || primaryColor != oldDelegate.primaryColor;
}
