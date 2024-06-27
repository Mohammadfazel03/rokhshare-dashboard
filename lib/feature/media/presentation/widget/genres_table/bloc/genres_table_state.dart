part of 'genres_table_cubit.dart';

@immutable
sealed class GenresTableState {
  final int numberPages;
  final int pageIndex;

  const GenresTableState({required this.numberPages, required this.pageIndex});
}

final class GenresTableLoading extends GenresTableState {
  const GenresTableLoading({super.numberPages = 0, super.pageIndex = 0});
}

final class GenresTableError extends GenresTableState {
  final String error;
  final int? code;
  final String title;

  const GenresTableError(
      {required this.error,
      required this.title,
      this.code,
      super.numberPages = 0,
      super.pageIndex = 0});
}

final class GenresTableSuccess extends GenresTableState {
  final PageResponse<Genre> data;

  const GenresTableSuccess(
      {required this.data, super.numberPages = 0, super.pageIndex = 0});
}
