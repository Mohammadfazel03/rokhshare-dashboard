part of 'movies_table_cubit.dart';

@immutable
sealed class MoviesTableState {}

final class MoviesTableLoading extends MoviesTableState {}

final class MoviesTableError extends MoviesTableState {
  final String error;
  final int? code;

  MoviesTableError({required this.error, this.code});

}

final class MoviesTableSuccess extends MoviesTableState {
  final PageResponse<Movie> data;

  MoviesTableSuccess({required this.data});
}
