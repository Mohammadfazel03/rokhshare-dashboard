part of 'season_page_cubit.dart';

class SeasonPageState implements PagingState<int, Season> {
  SeasonPageState({
    List<List<Season>>? pages,
    List<int>? keys,
    this.error,
    this.deleteError,
    this.deleteLoading = false,
    this.hasNextPage = true,
    this.isLoading = false,
  })  : assert(
          pages?.length == keys?.length,
          'The length of pages and keys must be equal.',
        ),
        pages = switch (pages) {
          null => null,
          _ => List.unmodifiable(pages),
        },
        keys = switch (keys) {
          null => null,
          _ => List.unmodifiable(keys),
        };

  @override
  final List<List<Season>>? pages;

  @override
  final List<int>? keys;

  @override
  final ErrorEntity? error;

  @override
  final bool hasNextPage;

  @override
  final bool isLoading;

  final bool deleteLoading;

  final ErrorEntity? deleteError;

  @override
  SeasonPageState copyWith({
    Defaulted<List<List<Season>>?>? pages = const Omit(),
    Defaulted<List<int>?>? keys = const Omit(),
    Defaulted<Object?>? error = const Omit(),
    Defaulted<bool>? hasNextPage = const Omit(),
    Defaulted<bool>? isLoading = const Omit(),
    Defaulted<bool>? deleteLoading = const Omit(),
    Defaulted<ErrorEntity?>? deleteError = const Omit(),
  }) =>
      SeasonPageState(
        pages: pages is Omit ? this.pages : pages as List<List<Season>>?,
        keys: keys is Omit ? this.keys : keys as List<int>?,
        error: error is Omit ? this.error : error as ErrorEntity?,
        hasNextPage:
            hasNextPage is Omit ? this.hasNextPage : hasNextPage as bool,
        isLoading: isLoading is Omit ? this.isLoading : isLoading as bool,
        deleteError: deleteError is Omit
            ? this.deleteError
            : deleteLoading as ErrorEntity?,
        deleteLoading:
            deleteLoading is Omit ? this.deleteLoading : deleteLoading as bool,
      );

  @override
  SeasonPageState reset() => SeasonPageState(
      pages: null,
      keys: null,
      error: null,
      hasNextPage: true,
      isLoading: false,
      deleteError: null,
      deleteLoading: false);

  @override
  String toString() => '${objectRuntimeType(this, 'PagingStateBase')}'
      '(pages: $pages, keys: $keys, error: $error, hasNextPage: $hasNextPage, '
      'isLoading: $isLoading)';

  static const _equality = DeepCollectionEquality();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PagingState<int, Season> &&
            _equality.equals(other.pages, pages) &&
            _equality.equals(other.keys, keys) &&
            other.error == error &&
            other.hasNextPage == hasNextPage &&
            other.isLoading == isLoading);
  }

  @override
  int get hashCode => Object.hash(
        _equality.hash(pages),
        _equality.hash(keys),
        error,
        hasNextPage,
      );
}
