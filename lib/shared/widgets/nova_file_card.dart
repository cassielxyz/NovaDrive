import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/providers/upload_progress_provider.dart';
import 'nova_glass_card.dart';

class NovaFileCard extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final String mimeType;
  final String? localPath;
  final String? thumbnailLocalPath;
  final bool isSelected;
  final bool selectionMode;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback onMoreTap;
  final String fileId; // Added fileId to fetch progress

  const NovaFileCard({
    super.key,
    required this.fileId,
    required this.fileName,
    required this.fileSize,
    required this.mimeType,
    this.localPath,
    this.thumbnailLocalPath,
    this.isSelected = false,
    this.selectionMode = false,
    required this.onTap,
    this.onLongPress,
    required this.onMoreTap,
  });

  IconData _getFileIcon() {
    if (mimeType.startsWith('image/')) return Icons.image;
    if (mimeType.startsWith('video/')) return Icons.video_file;
    if (mimeType.startsWith('audio/')) return Icons.audio_file;
    if (mimeType.contains('pdf')) return Icons.picture_as_pdf;
    if (mimeType.contains('zip') || mimeType.contains('rar')) return Icons.folder_zip;
    return Icons.insert_drive_file;
  }

  Widget _buildIconOrThumbnail(BuildContext context) {
    if (thumbnailLocalPath != null && thumbnailLocalPath!.isNotEmpty) {
      return ClipRRect(
        borderRadius: AppRadius.radiusMd,
        child: Image.file(
          File(thumbnailLocalPath!),
          width: 56,
          height: 56,
          cacheWidth: 112, // 2x for device pixel ratio
          cacheHeight: 112,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildDefaultIcon(context),
        ),
      );
    } else if (localPath != null && localPath!.isNotEmpty && mimeType.startsWith('image/')) {
      return ClipRRect(
        borderRadius: AppRadius.radiusMd,
        child: Image.file(
          File(localPath!),
          width: 56,
          height: 56,
          cacheWidth: 112, // 2x for device pixel ratio
          cacheHeight: 112,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildDefaultIcon(context),
        ),
      );
    }
    return _buildDefaultIcon(context);
  }

  Widget _buildDefaultIcon(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final manager = ref.watch(uploadProgressManagerProvider);
      return ValueListenableBuilder<FileProgressState>(
        valueListenable: manager.getState(fileId),
        builder: (context, progressState, _) {
          return Icon(
            progressState.isFailed ? Icons.error : _getFileIcon(),
            color: progressState.isFailed 
                ? Theme.of(context).colorScheme.error 
                : Theme.of(context).colorScheme.primary,
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: NovaGlassCard(
        padding: EdgeInsets.zero,
        borderRadius: AppRadius.radiusLg,
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        onLongPress: onLongPress == null ? null : () {
          HapticFeedback.mediumImpact();
          onLongPress!();
        },
        disableBlur: true, // Performance: BackdropFilter in lists causes heavy jank during scroll
        backgroundColor: isSelected 
            ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              leading: selectionMode
                  ? Checkbox(
                      value: isSelected,
                      onChanged: (_) {
                        HapticFeedback.lightImpact();
                        onTap();
                      },
                    )
                  : Consumer(builder: (context, ref, _) {
                      final manager = ref.watch(uploadProgressManagerProvider);
                      return ValueListenableBuilder<FileProgressState>(
                        valueListenable: manager.getState(fileId),
                        builder: (context, progressState, _) {
                          return Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: progressState.isDownloading
                                ? Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        value: progressState.progress / 100,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : _buildIconOrThumbnail(context),
                          );
                        },
                      );
                    }),
              title: Text(
                fileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Consumer(builder: (context, ref, _) {
                  final manager = ref.watch(uploadProgressManagerProvider);
                  return ValueListenableBuilder<FileProgressState>(
                    valueListenable: manager.getState(fileId),
                    builder: (context, progressState, _) {
                      return Text(
                        progressState.isUploading ? 'Uploading...' : 
                        progressState.isDownloading ? 'Downloading... ${progressState.progress}%' :
                        progressState.isFailed ? 'Failed' : 
                        fileSize,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: progressState.isFailed
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                  );
                }),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onMoreTap();
                },
              ),
            ),
            Consumer(builder: (context, ref, _) {
              final manager = ref.watch(uploadProgressManagerProvider);
              return ValueListenableBuilder<FileProgressState>(
                valueListenable: manager.getState(fileId),
                builder: (context, progressState, _) {
                  if (progressState.isUploading || progressState.isDownloading) {
                    return RepaintBoundary(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                        child: LinearProgressIndicator(
                          value: progressState.progress > 0 ? progressState.progress / 100 : null,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
