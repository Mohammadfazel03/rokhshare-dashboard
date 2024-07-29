part of 'genre_section_cubit.dart';

enum GenreSectionStatus {
  loading,
  success,
  fail;
}

final class GenreSectionState {
  final GenreSectionStatus status;
  final List<Genre>? data;
  final String? error;
  final int? code;
  final String? titleError;
  final List<Genre> selectedItem;

  const GenreSectionState({
    required this.status,
    required this.selectedItem,
    this.data,
    this.error,
    this.code,
    this.titleError
  });


  GenreSectionState setError(String titleError,  String error, int code) {
    return GenreSectionState(status: status,
        selectedItem: selectedItem,
        error: error,
        code: code,
        data: data,
        titleError: titleError);
  }


  GenreSectionState clearError() {
    return GenreSectionState(status: status,
        selectedItem: selectedItem,
        error: null,
        code: null,
        data: data,
        titleError: null);
  }

  GenreSectionState copyWith(
      {GenreSectionStatus? status,
      List<Genre>? data,
      String? error,
      int? code,
      String? titleError,
      List<Genre>? selectedItem}) {
    return GenreSectionState(
        status: status ?? this.status,
        selectedItem: selectedItem ?? this.selectedItem,
        data: data ?? this.data,
        error: error ?? this.error,
        code: code ?? this.code,
        titleError: titleError ?? this.titleError);
  }
}
