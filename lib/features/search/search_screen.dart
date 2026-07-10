import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/providers/search_provider.dart';
import '../../core/services/file_download_service.dart';

import '../../shared/widgets/nova_file_card.dart';
import '../../shared/widgets/nova_search_bar.dart';
import '../../shared/widgets/nova_empty_state.dart';
import '../../shared/widgets/nova_filter_sort_bottom_sheet.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    // Clear search state when leaving the screen
    ref.read(searchProvider.notifier).clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        title: NovaSearchBar(
          controller: _controller,
          hintText: 'Search files...',
          onChanged: (value) {
            // Debounced search via provider — no setState needed
            ref.read(searchProvider.notifier).updateQuery(value);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              NovaFilterSortBottomSheet.show(context);
            },
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: searchState.query.isEmpty 
          ? const NovaEmptyState(
              icon: Icons.search,
              title: 'Search Nova Drive',
              subtitle: 'Find files by name',
            )
          : searchState.isSearching
              ? const Center(child: CircularProgressIndicator())
              : searchState.results.isEmpty
                  ? const NovaEmptyState(
                      icon: Icons.search_off,
                      title: 'No results',
                      subtitle: 'Try a different search term',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: searchState.results.length,
                      itemBuilder: (context, index) {
                        final item = searchState.results[index];
                        final file = item.file;
                        
                        // Removed unused variables

                        return NovaFileCard(
                          fileId: file.id,
                          fileName: file.name,
                          fileSize: '${(file.size / 1024).toStringAsFixed(1)} KB',
                          mimeType: file.mimeType,
                          localPath: file.localPath,
                          thumbnailLocalPath: file.thumbnailLocalPath,
                          onTap: () {
                            if (file.telegramFileId != null) {
                              ref.read(fileDownloadProvider).downloadAndOpenFile(
                                telegramFileId: file.telegramFileId!,
                                localPath: file.path,
                              );
                            }
                          },
                          onMoreTap: () {},
                        );
                      },
                    ),
    );
  }
}
