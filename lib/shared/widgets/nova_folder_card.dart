import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import 'nova_glass_card.dart';

class NovaFolderCard extends StatelessWidget {
  final String folderName;
  final bool isSelected;
  final bool selectionMode;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback onMoreTap;

  const NovaFolderCard({
    super.key,
    required this.folderName,
    this.isSelected = false,
    this.selectionMode = false,
    required this.onTap,
    this.onLongPress,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return NovaGlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              selectionMode
                  ? Checkbox(
                      value: isSelected,
                      onChanged: (_) {
                        HapticFeedback.lightImpact();
                        onTap();
                      },
                      visualDensity: VisualDensity.compact,
                    )
                  : Icon(
                      Icons.folder,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onMoreTap();
                },
                child: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ],
          ),
          Text(
            folderName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
