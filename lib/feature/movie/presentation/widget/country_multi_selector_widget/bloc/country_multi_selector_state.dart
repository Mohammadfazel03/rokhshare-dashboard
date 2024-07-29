part of 'country_multi_selector_cubit.dart';

enum CountryMultiSelectorStatus {
  loading,
  success,
  fail;
}

class CountryMultiSelectorState {
  final CountryMultiSelectorStatus status;
  final List<Country>? data;
  final String? error;
  final int? code;
  final String? titleError;
  final List<Country> selectedItem;

  const CountryMultiSelectorState(
      {required this.status,
      required this.selectedItem,
      this.data,
      this.error,
      this.code,
      this.titleError});

  CountryMultiSelectorState copyWith(
      {CountryMultiSelectorStatus? status,
      List<Country>? data,
      String? error,
      int? code,
      String? titleError,
      List<Country>? selectedItem}) {
    return CountryMultiSelectorState(
        status: status ?? this.status,
        selectedItem: selectedItem ?? this.selectedItem,
        data: data ?? this.data,
        error: error ?? this.error,
        code: code ?? this.code,
        titleError: titleError ?? this.titleError);
  }

  CountryMultiSelectorState setError(
      String titleError, String error, int code) {
    return CountryMultiSelectorState(
        status: status,
        selectedItem: selectedItem,
        error: error,
        code: code,
        data: data,
        titleError: titleError);
  }

  CountryMultiSelectorState clearError() {
    return CountryMultiSelectorState(
        status: status,
        selectedItem: selectedItem,
        error: null,
        code: null,
        data: data,
        titleError: null);
  }
}
