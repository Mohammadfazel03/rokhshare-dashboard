import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/movie/data/remote/model/gallery.dart';
import 'package:dashboard/feature/movie/data/repositories/movie_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:flutter/material.dart';

part 'gallery_append_state.dart';

class GalleryAppendCubit extends Cubit<GalleryAppendState> {
  final MovieRepository _repository;

  GalleryAppendCubit({required MovieRepository repository})
      : _repository = repository,
        super(GalleryAppendInitial());

  Future<void> saveGallery(
      {required int? mediaId,
      required int? episodeId,
      required int fileId,
      required String description}) async {
    emit(GalleryAppendLoading());
    DataResponse<void> response = await _repository.saveGallery(
        episodeId: episodeId,
        mediaId: mediaId,
        fileId: fileId,
        description: description);
    if (response is DataFailed) {
      emit(GalleryAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(GalleryAppendSuccessAppend());
    }
  }

  Future<void> getGallery({required int id}) async {
    emit(GalleryAppendLoading());
    DataResponse<Gallery> response = await _repository.getGallery(id: id);
    if (response is DataFailed) {
      emit(GalleryAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(GalleryAppendSuccess(gallery: response.data!));
    }
  }

  Future<void> updateGallery(
      {required int id,
      required int? fileId,
      required String? description}) async {
    emit(GalleryAppendLoading());
    DataResponse<void> response = await _repository.editGallery(
        id: id, fileId: fileId, description: description);
    if (response is DataFailed) {
      emit(GalleryAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(GalleryAppendSuccessUpdate());
    }
  }
}
