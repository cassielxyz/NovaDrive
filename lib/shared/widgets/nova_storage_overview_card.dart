import 'package:flutter/material.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/providers/storage_stats_provider.dart';
import 'nova_glass_card.dart';

class NovaStorageOverviewCard extends StatelessWidget {
  final StorageStats stats;

  const NovaStorageOverviewCard({super.key, required this.stats});

  String _formatSize(int bytes) {
    if (bytes == 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  @override
  Widget build(BuildContext context) {
    final double percentUsed = (stats.usedBytes / (1000.0 * 1024 * 1024 * 1024 * 1024)).clamp(0.0, 1.0);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: NovaGlassCard(
        borderRadius: AppRadius.radiusLg,
        padding: const EdgeInsets.all(AppSpacing.md),
        heavyBlur: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Storage', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      '${stats.fileCount} files, ${stats.folderCount} folders',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${_formatSize(stats.usedBytes)} / 1000 TB',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentUsed,
                minHeight: 8,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              children: [
                _buildStatItem(context, 'Images', stats.imageBytes, Colors.blue),
                _buildStatItem(context, 'Videos', stats.videoBytes, Colors.purple),
                _buildStatItem(context, 'Docs', stats.documentBytes, Colors.orange),
                _buildStatItem(context, 'Audio', stats.audioBytes, Colors.green),
                _buildStatItem(context, 'Archives', stats.archiveBytes, Colors.red),
                _buildStatItem(context, 'APK', stats.apkBytes, Colors.teal),
                _buildStatItem(context, 'Other', stats.otherBytes, Colors.grey),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconStat(context, Icons.cloud_done, 'Cloud Only', _formatSize(stats.cloudOnlyBytes)),
                _buildIconStat(context, Icons.offline_pin, 'Offline', _formatSize(stats.offlineBytes)),
                if (stats.activeUploadCount > 0)
                  _buildIconStat(context, Icons.upload, 'Uploading', '${stats.activeUploadCount} items', color: Colors.blue),
                if (stats.failedUploadCount > 0)
                  _buildIconStat(context, Icons.error_outline, 'Failed', '${stats.failedUploadCount} items', color: Colors.red),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, int bytes, Color color) {
    if (bytes == 0) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          _formatSize(bytes),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildIconStat(BuildContext context, IconData icon, String label, String value, {Color? color}) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color ?? Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: color)),
        Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }
}
