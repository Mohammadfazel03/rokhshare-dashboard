part of 'collections_table_cubit.dart';

@immutable
sealed class CollectionsTableState {
  final int numberPages;
  final int pageIndex;

  const CollectionsTableState({required this.numberPages, required this.pageIndex});
}

final class CollectionsTableLoading extends CollectionsTableState {
  const CollectionsTableLoading({super.numberPages = 0, super.pageIndex = 0});
}

final class CollectionsTableError extends CollectionsTableState {
  final String error;
  final int? code;

  const CollectionsTableError(
      {required this.error,
      this.code,
      super.numberPages = 0,
      super.pageIndex = 0});
}

final class CollectionsTableSuccess extends CollectionsTableState {
  final PageResponse<Collection> data;

  const CollectionsTableSuccess(
      {required this.data, super.numberPages = 0, super.pageIndex = 0});
}
