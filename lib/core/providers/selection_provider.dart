import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectionState {
  final Set<String> selectedFileIds;
  final Set<String> selectedFolderIds;
  
  bool get isEmpty => selectedFileIds.isEmpty && selectedFolderIds.isEmpty;
  int get count => selectedFileIds.length + selectedFolderIds.length;

  SelectionState({
    this.selectedFileIds = const {},
    this.selectedFolderIds = const {},
  });

  SelectionState copyWith({
    Set<String>? selectedFileIds,
    Set<String>? selectedFolderIds,
  }) {
    return SelectionState(
      selectedFileIds: selectedFileIds ?? this.selectedFileIds,
      selectedFolderIds: selectedFolderIds ?? this.selectedFolderIds,
    );
  }
}

class SelectionNotifier extends Notifier<SelectionState> {
  @override
  SelectionState build() => SelectionState();

  void toggleFile(String fileId) {
    final newFiles = Set<String>.from(state.selectedFileIds);
    if (newFiles.contains(fileId)) {
      newFiles.remove(fileId);
    } else {
      newFiles.add(fileId);
    }
    state = state.copyWith(selectedFileIds: newFiles);
  }

  void toggleFolder(String folderId) {
    final newFolders = Set<String>.from(state.selectedFolderIds);
    if (newFolders.contains(folderId)) {
      newFolders.remove(folderId);
    } else {
      newFolders.add(folderId);
    }
    state = state.copyWith(selectedFolderIds: newFolders);
  }

  void clear() {
    state = SelectionState();
  }
}

final selectionProvider = NotifierProvider<SelectionNotifier, SelectionState>(
  SelectionNotifier.new,
);
