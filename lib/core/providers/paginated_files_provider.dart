import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_provider.dart';
import '../database/daos.dart';
import '../providers/filter_sort_provider.dart';
import '../services/nova_logger.dart';

class PaginatedFilesState {
  final List<FileWithTask> files;
  final bool isLoading;
  final bool hasMore;
  final int offset;
  final int pageSize;

  const PaginatedFilesState({
    this.files = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.offset = 0,
    this.pageSize = 50,
  });

  PaginatedFilesState copyWith({
    List<FileWithTask>? files,
    bool? isLoading,
    bool? hasMore,
    int? offset,
    int? pageSize,
  }) {
    return PaginatedFilesState(
      files: files ?? this.files,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

class PaginatedFilesController extends ChangeNotifier {
  final Ref ref;
  final String? folderId;
  Timer? _refreshDebounce;
  StreamSubscription? _countSub;

  PaginatedFilesState _state = const PaginatedFilesState();
  PaginatedFilesState get state => _state;

  PaginatedFilesController(this.ref, this.folderId) {
    Future.microtask(() => loadInitial());
    
    ref.listen(filterSortProvider, (prev, next) {
      if (prev != next) {
        refresh();
      }
    });

    final dao = ref.read(daoProvider);
    _countSub = dao.watchFilesCount(folderId).listen((_) {
      refresh();
    });
  }

  void _setState(PaginatedFilesState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> loadInitial() async {
    if (_state.isLoading) return;
    _setState(_state.copyWith(isLoading: true, offset: 0, files: [], hasMore: true));

    try {
      final dao = ref.read(daoProvider);
      final filterSort = ref.read(filterSortProvider);
      final isDropZone = folderId == null;

      final results = await dao.getFilesWithTasksPaged(
        folderId: folderId,
        isDropZone: isDropZone,
        isDeleted: false,
        sortOption: filterSort.sortOptionIndex,
        typeFilter: filterSort.typeFilter.index,
        limit: _state.pageSize,
        offset: 0,
      );

      _setState(_state.copyWith(
        files: results,
        isLoading: false,
        hasMore: results.length >= _state.pageSize,
        offset: results.length,
      ));
    } catch (e) {
      NovaLogger.error('PaginatedFiles', 'loadInitial failed: $e');
      _setState(_state.copyWith(isLoading: false));
    }
  }

  Future<void> loadMore() async {
    if (_state.isLoading || !_state.hasMore) return;
    _setState(_state.copyWith(isLoading: true));

    try {
      final dao = ref.read(daoProvider);
      final filterSort = ref.read(filterSortProvider);
      final isDropZone = folderId == null;

      final results = await dao.getFilesWithTasksPaged(
        folderId: folderId,
        isDropZone: isDropZone,
        isDeleted: false,
        sortOption: filterSort.sortOptionIndex,
        typeFilter: filterSort.typeFilter.index,
        limit: _state.pageSize,
        offset: _state.offset,
      );

      _setState(_state.copyWith(
        files: [..._state.files, ...results],
        isLoading: false,
        hasMore: results.length >= _state.pageSize,
        offset: _state.offset + results.length,
      ));
    } catch (e) {
      NovaLogger.error('PaginatedFiles', 'loadMore failed: $e');
      _setState(_state.copyWith(isLoading: false));
    }
  }

  void refresh() {
    _refreshDebounce?.cancel();
    _refreshDebounce = Timer(const Duration(milliseconds: 300), () {
      loadInitial();
    });
  }

  @override
  void dispose() {
    _refreshDebounce?.cancel();
    _countSub?.cancel();
    super.dispose();
  }
}

final paginatedControllerProvider = Provider.autoDispose.family<PaginatedFilesController, String?>((ref, folderId) {
  final controller = PaginatedFilesController(ref, folderId);
  ref.onDispose(() => controller.dispose());
  return controller;
});
