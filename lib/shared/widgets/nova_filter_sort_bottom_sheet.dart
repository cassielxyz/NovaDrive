import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/filter_sort_provider.dart';

import '../../core/theme/app_spacing.dart';

class NovaFilterSortBottomSheet extends ConsumerWidget {
  const NovaFilterSortBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NovaFilterSortBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(filterSortProvider);
    final notifier = ref.read(filterSortProvider.notifier);
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sort & Filter', style: Theme.of(context).textTheme.titleLarge),
                TextButton(
                  onPressed: () {
                    notifier.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            
            Text('Sort By', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                _buildChoiceChip(
                  context: context,
                  label: 'Name',
                  selected: state.sortField == SortField.name,
                  onSelected: (_) => notifier.setSortField(SortField.name),
                ),
                _buildChoiceChip(
                  context: context,
                  label: 'Date',
                  selected: state.sortField == SortField.date,
                  onSelected: (_) => notifier.setSortField(SortField.date),
                ),
                _buildChoiceChip(
                  context: context,
                  label: 'Size',
                  selected: state.sortField == SortField.size,
                  onSelected: (_) => notifier.setSortField(SortField.size),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            
            Text('Order', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            SegmentedButton<SortOrder>(
              segments: const [
                ButtonSegment(value: SortOrder.ascending, label: Text('Ascending'), icon: Icon(Icons.arrow_upward, size: 16)),
                ButtonSegment(value: SortOrder.descending, label: Text('Descending'), icon: Icon(Icons.arrow_downward, size: 16)),
              ],
              selected: {state.sortOrder},
              onSelectionChanged: (Set<SortOrder> newSelection) {
                notifier.setSortOrder(newSelection.first);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            
            Text('File Type', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _buildChoiceChip(
                  context: context,
                  label: 'All',
                  selected: state.typeFilter == FileTypeFilter.all,
                  onSelected: (_) => notifier.setTypeFilter(FileTypeFilter.all),
                ),
                _buildChoiceChip(
                  context: context,
                  label: 'Images',
                  selected: state.typeFilter == FileTypeFilter.image,
                  onSelected: (_) => notifier.setTypeFilter(FileTypeFilter.image),
                ),
                _buildChoiceChip(
                  context: context,
                  label: 'Videos',
                  selected: state.typeFilter == FileTypeFilter.video,
                  onSelected: (_) => notifier.setTypeFilter(FileTypeFilter.video),
                ),
                _buildChoiceChip(
                  context: context,
                  label: 'Audio',
                  selected: state.typeFilter == FileTypeFilter.audio,
                  onSelected: (_) => notifier.setTypeFilter(FileTypeFilter.audio),
                ),
                _buildChoiceChip(
                  context: context,
                  label: 'Documents',
                  selected: state.typeFilter == FileTypeFilter.document,
                  onSelected: (_) => notifier.setTypeFilter(FileTypeFilter.document),
                ),
                _buildChoiceChip(
                  context: context,
                  label: 'Archives',
                  selected: state.typeFilter == FileTypeFilter.archive,
                  onSelected: (_) => notifier.setTypeFilter(FileTypeFilter.archive),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceChip({
    required BuildContext context,
    required String label,
    required bool selected,
    required Function(bool) onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }
}
