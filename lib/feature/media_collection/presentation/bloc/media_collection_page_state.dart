part of 'media_collection_page_cubit.dart';

@immutable
sealed class MediaCollectionPageState {
  final int numberPages;
  final int pageIndex;

  const MediaCollectionPageState(
      {required this.numberPages, required this.pageIndex});
}

final class MediaCollectionPageLoading extends MediaCollectionPageState {
  const MediaCollectionPageLoading({int numberPages = 0, int pageIndex = 0})
      : super(numberPages: numberPages, pageIndex: pageIndex);
}

final class MediaCollectionPageError extends MediaCollectionPageState {
  final String error;
  final String? title;
  final int? code;

  const MediaCollectionPageError(
      {required this.error,
      this.title,
      this.code,
      int numberPages = 0,
      int pageIndex = 0})
      : super(numberPages: numberPages, pageIndex: pageIndex);
}

final class MediaCollectionPageSuccess extends MediaCollectionPageState {
  final PageResponse<Media> data;

  const MediaCollectionPageSuccess(
      {required this.data, int pageIndex = 0, int numberPages = 0})
      : super(numberPages: numberPages, pageIndex: pageIndex);
}
