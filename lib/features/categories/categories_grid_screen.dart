import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/nova_glass_card.dart';

class CategoriesGridScreen extends StatelessWidget {
  const CategoriesGridScreen({super.key});

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return NovaGlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 48),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(AppSpacing.md),
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.1,
        children: [
          _buildCategoryCard(context, 'Photos', Icons.photo, () => context.push('/vault/Images')),
          _buildCategoryCard(context, 'Videos', Icons.video_library, () => context.push('/vault/Videos')),
          _buildCategoryCard(context, 'Documents', Icons.description, () => context.push('/vault/Documents')),
          _buildCategoryCard(context, 'Archives', Icons.folder_zip, () => context.push('/vault/Archives')),
        ],
      ),
    );
  }
}
