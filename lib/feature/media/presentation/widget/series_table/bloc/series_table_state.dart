part of 'series_table_cubit.dart';

@immutable
sealed class SeriesTableState {}

final class SeriesTableLoading extends SeriesTableState {}

final class SeriesTableError extends SeriesTableState {
  final String error;
  final int? code;

  SeriesTableError({required this.error, this.code});

}

final class SeriesTableSuccess extends SeriesTableState {
  final PageResponse<Series> data;

  SeriesTableSuccess({required this.data});
}
