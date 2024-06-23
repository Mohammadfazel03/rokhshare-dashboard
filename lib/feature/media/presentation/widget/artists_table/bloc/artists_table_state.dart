part of 'artists_table_cubit.dart';

@immutable
sealed class ArtistsTableState {
  final int numberPages;
  final int pageIndex;

  const ArtistsTableState(
      {required this.numberPages, required this.pageIndex});
}

final class ArtistsTableLoading extends ArtistsTableState {
  const ArtistsTableLoading({super.numberPages = 0, super.pageIndex = 0});
}

final class ArtistsTableError extends ArtistsTableState {
  final String error;
  final int? code;

  const ArtistsTableError(
      {required this.error,
      this.code,
      super.numberPages = 0,
      super.pageIndex = 0});
}

final class ArtistsTableSuccess extends ArtistsTableState {
  final PageResponse<Artist> data;

  const ArtistsTableSuccess(
      {required this.data, super.numberPages = 0, super.pageIndex = 0});
}
