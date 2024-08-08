part of 'series_table_cubit.dart';

@immutable
sealed class SeriesTableState {
  final int numberPages;
  final int pageIndex;

  const SeriesTableState({required this.numberPages, required this.pageIndex});
}

final class SeriesTableLoading extends SeriesTableState {
  const SeriesTableLoading({super.numberPages = 0, super.pageIndex = 0});
}

final class SeriesTableError extends SeriesTableState {
  final String error;
  final int? code;
  final String? title;

  const SeriesTableError(
      {required this.error,
      this.code,
      this.title,
      super.numberPages = 0,
      super.pageIndex = 0});
}

final class SeriesTableSuccess extends SeriesTableState {
  final PageResponse<Series> data;

  const SeriesTableSuccess(
      {required this.data, super.numberPages = 0, super.pageIndex = 0});
}
