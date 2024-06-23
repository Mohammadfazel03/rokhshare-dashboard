part of 'movies_table_cubit.dart';

@immutable
sealed class MoviesTableState {
  final int numberPages;
  final int pageIndex;

  const MoviesTableState({required this.numberPages, required this.pageIndex});
}

final class MoviesTableLoading extends MoviesTableState {
  const MoviesTableLoading({int numberPages = 0, int pageIndex = 0})
      : super(numberPages: numberPages, pageIndex: pageIndex);
}

final class MoviesTableError extends MoviesTableState {
  final String error;
  final int? code;

  const MoviesTableError(
      {required this.error, this.code, int numberPages = 0, int pageIndex = 0})
      : super(numberPages: numberPages, pageIndex: pageIndex);
}

final class MoviesTableSuccess extends MoviesTableState {
  final PageResponse<Movie> data;

  const MoviesTableSuccess(
      {required this.data, int pageIndex = 0, int numberPages = 0})
      : super(numberPages: numberPages, pageIndex: pageIndex);
}
