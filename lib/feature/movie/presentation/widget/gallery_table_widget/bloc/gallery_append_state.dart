part of 'gallery_append_cubit.dart';

@immutable
sealed class GalleryAppendState {}

final class GalleryAppendInitial extends GalleryAppendState {}

final class GalleryAppendLoading extends GalleryAppendState {}

final class GalleryAppendSuccessAppend extends GalleryAppendState {}

final class GalleryAppendSuccessUpdate extends GalleryAppendState {}

final class GalleryAppendSuccess extends GalleryAppendState {
  final Gallery gallery;

  GalleryAppendSuccess({required this.gallery});
}

final class GalleryAppendFailed extends GalleryAppendState {
  final String message;
  final int? code;

  GalleryAppendFailed({required this.message, this.code});
}
