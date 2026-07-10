import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SortField {
  name,
  date,
  size,
}

enum SortOrder {
  ascending,
  descending,
}

enum FileTypeFilter {
  all,
  image,
  video,
  audio,
  document,
  archive,
}

class FilterSortState {
  final SortField sortField;
  final SortOrder sortOrder;
  final FileTypeFilter typeFilter;

  FilterSortState({
    this.sortField = SortField.date,
    this.sortOrder = SortOrder.descending,
    this.typeFilter = FileTypeFilter.all,
  });

  FilterSortState copyWith({
    SortField? sortField,
    SortOrder? sortOrder,
    FileTypeFilter? typeFilter,
  }) {
    return FilterSortState(
      sortField: sortField ?? this.sortField,
      sortOrder: sortOrder ?? this.sortOrder,
      typeFilter: typeFilter ?? this.typeFilter,
    );
  }

  // Helper to map to the old indices if needed by DB, or we can update DB queries
  int get sortOptionIndex {
    if (sortField == SortField.name && sortOrder == SortOrder.ascending) return 0;
    if (sortField == SortField.name && sortOrder == SortOrder.descending) return 1;
    if (sortField == SortField.date && sortOrder == SortOrder.descending) return 2; // dateNewest
    if (sortField == SortField.date && sortOrder == SortOrder.ascending) return 3; // dateOldest
    if (sortField == SortField.size && sortOrder == SortOrder.descending) return 4; // sizeLargest
    if (sortField == SortField.size && sortOrder == SortOrder.ascending) return 5; // sizeSmallest
    return 2;
  }
}

class FilterSortNotifier extends Notifier<FilterSortState> {
  @override
  FilterSortState build() => FilterSortState();

  void setSortField(SortField field) {
    state = state.copyWith(sortField: field);
  }

  void setSortOrder(SortOrder order) {
    state = state.copyWith(sortOrder: order);
  }

  void setTypeFilter(FileTypeFilter filter) {
    state = state.copyWith(typeFilter: filter);
  }

  void clear() {
    state = FilterSortState();
  }
}

final filterSortProvider = NotifierProvider<FilterSortNotifier, FilterSortState>(
  FilterSortNotifier.new,
);
