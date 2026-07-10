import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

class NovaActionItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  NovaActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });
}

class NovaActionBottomSheet extends StatelessWidget {
  final String title;
  final List<NovaActionItem> actions;

  const NovaActionBottomSheet({
    super.key,
    required this.title,
    required this.actions,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<NovaActionItem> actions,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => NovaActionBottomSheet(title: title, actions: actions),
    );
  }

  @override
  Widget build(BuildContext context) {
    final panelColor = Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
    final borderColor = Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.2);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          decoration: BoxDecoration(
            color: panelColor,
            border: Border(
              top: BorderSide(color: borderColor, width: 1.0),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: AppRadius.radiusFull,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ...actions.map((action) => ListTile(
                  leading: Icon(
                    action.icon,
                    color: action.isDestructive 
                        ? Theme.of(context).colorScheme.error 
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                  title: Text(
                    action.label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: action.isDestructive 
                          ? Theme.of(context).colorScheme.error 
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    action.onTap();
                  },
                )),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
