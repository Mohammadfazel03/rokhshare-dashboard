part of 'artists_autocomplete_cubit.dart';

@immutable
sealed class ArtistsAutocompleteState {
  final int numberPages;
  final int pageIndex;

  const ArtistsAutocompleteState({required this.numberPages, required this.pageIndex});
}

final class ArtistsAutocompleteLoading extends ArtistsAutocompleteState {
  const ArtistsAutocompleteLoading({super.numberPages = 0, super.pageIndex = 0});
}

final class ArtistsAutocompleteError extends ArtistsAutocompleteState {
  final String error;
  final int? code;
  final String title;

  const ArtistsAutocompleteError(
      {required this.error,
      required this.title,
      this.code,
      super.numberPages = 0,
      super.pageIndex = 0});
}

final class ArtistsAutocompleteSuccess extends ArtistsAutocompleteState {
  final PageResponse<Artist> data;

  const ArtistsAutocompleteSuccess(
      {required this.data, super.numberPages = 0, super.pageIndex = 0});
}
