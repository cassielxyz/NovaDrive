import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_provider.dart';
import '../database/daos.dart';
import '../providers/filter_sort_provider.dart';

/// State for debounced search results.
class SearchState {
  final String query;
  final List<FileWithTask> results;
  final bool isSearching;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.isSearching = false,
  });

  SearchState copyWith({
    String? query,
    List<FileWithTask>? results,
    bool? isSearching,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

/// Provides debounced search with SQL-based filtering.
/// 300ms debounce, LIMIT 100 results, distinctUntilChanged.
class SearchNotifier extends Notifier<SearchState> {
  Timer? _debounce;
  String _lastQuery = '';

  @override
  SearchState build() => const SearchState();

  void updateQuery(String query) {
    final trimmed = query.trim();
    state = state.copyWith(query: trimmed);

    if (trimmed.isEmpty) {
      _debounce?.cancel();
      _lastQuery = '';
      state = state.copyWith(results: [], isSearching: false);
      return;
    }

    // distinctUntilChanged
    if (trimmed == _lastQuery) return;

    state = state.copyWith(isSearching: true);

    // 300ms debounce
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(trimmed);
    });
  }

  Future<void> _performSearch(String query) async {
    _lastQuery = query;
    final dao = ref.read(daoProvider);
    final filterSort = ref.read(filterSortProvider);

    try {
      final results = await dao.getFilesWithTasksPaged(
        searchQuery: query,
        isDeleted: false,
        sortOption: filterSort.sortOptionIndex,
        typeFilter: filterSort.typeFilter.index,
        limit: 100,
        offset: 0,
      );

      // Only update if this is still the current query (avoid stale results)
      if (state.query == query) {
        state = state.copyWith(results: results, isSearching: false);
      }
    } catch (_) {
      state = state.copyWith(isSearching: false);
    }
  }

  void clear() {
    _debounce?.cancel();
    _lastQuery = '';
    state = const SearchState();
  }
}

final searchProvider = NotifierProvider<SearchNotifier, SearchState>(
  SearchNotifier.new,
);
