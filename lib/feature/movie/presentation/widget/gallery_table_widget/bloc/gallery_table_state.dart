part of 'gallery_table_cubit.dart';

@immutable
sealed class GalleryTableState {
  final int numberPages;
  final int pageIndex;
  final PageResponse<Gallery>? data;

  const GalleryTableState(
      {required this.numberPages, required this.pageIndex, required this.data});
}

final class GalleryTableLoading extends GalleryTableState {
  const GalleryTableLoading(
      {super.numberPages = 0, super.pageIndex = 0, super.data});
}

final class GalleryTableInitial extends GalleryTableState {
  const GalleryTableInitial(
      {super.numberPages = 0, super.pageIndex = 0, super.data});
}

final class GalleryTableError extends GalleryTableState {
  final String error;
  final String? title;
  final int? code;

  const GalleryTableError(
      {required this.error,
      this.title,
      this.code,
      super.numberPages = 0,
      super.pageIndex = 0,
      super.data});
}

final class GalleryTableSuccess extends GalleryTableState {
  const GalleryTableSuccess(
      {super.data, super.numberPages = 0, super.pageIndex = 0});
}
