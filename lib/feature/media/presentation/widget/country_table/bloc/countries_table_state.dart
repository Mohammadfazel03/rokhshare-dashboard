part of 'countries_table_cubit.dart';

@immutable
sealed class CountriesTableState {
  final int numberPages;
  final int pageIndex;

  const CountriesTableState(
      {required this.numberPages, required this.pageIndex});
}

final class CountriesTableLoading extends CountriesTableState {
  const CountriesTableLoading({super.numberPages = 0, super.pageIndex = 0});
}

final class CountriesTableError extends CountriesTableState {
  final String error;
  final int? code;
  final String title;

  const CountriesTableError(
      {required this.error,
      required this.title,
      this.code,
      super.numberPages = 0,
      super.pageIndex = 0});
}

final class CountriesTableSuccess extends CountriesTableState {
  final PageResponse<Country> data;

  const CountriesTableSuccess(
      {required this.data, super.numberPages = 0, super.pageIndex = 0});
}
