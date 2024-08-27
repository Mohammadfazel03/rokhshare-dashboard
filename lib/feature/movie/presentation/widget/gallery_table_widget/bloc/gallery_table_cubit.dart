import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/movie/data/remote/model/gallery.dart';
import 'package:dashboard/feature/movie/data/repositories/movie_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:flutter/material.dart';

part 'gallery_table_state.dart';

class GalleryTableCubit extends Cubit<GalleryTableState> {
  final MovieRepository _repository;

  GalleryTableCubit({required MovieRepository repository})
      : _repository = repository,
        super(const GalleryTableInitial());

  Future<void> getData(
      {required int? mediaId, required int? episodeId, int page = 1}) async {
    if (mediaId == null && episodeId == null) {
      return;
    }
    emit(GalleryTableLoading(
        numberPages: state.numberPages, pageIndex: page, data: state.data));
    late DataResponse<PageResponse<Gallery>> response;
    if (episodeId != null) {
      response = await _repository.getGalleryOfEpisode(
          episodeId: episodeId, page: page);
    } else if (mediaId != null) {
      response =
          await _repository.getGalleryOfMedia(mediaId: mediaId, page: page);
    }
    if (response is DataFailed) {
      emit(GalleryTableError(
          data: state.data,
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: page,
          numberPages: state.numberPages));
    } else {
      emit(GalleryTableSuccess(
          data: response.data!,
          numberPages: response.data!.totalPages!,
          pageIndex: page));
    }
  }

  Future<void> delete(
      {required int id, required int? episodeId, required int? mediaId}) async {
    emit(GalleryTableLoading(
        data: state.data,
        numberPages: state.numberPages,
        pageIndex: state.pageIndex));
    DataResponse<void> response = await _repository.deleteGallery(id: id);
    if (response is DataFailed) {
      emit(GalleryTableError(
          data: state.data,
          title: "خطا در حذف تصویر",
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: state.pageIndex,
          numberPages: state.numberPages));
    } else {
      getData(page: state.pageIndex, mediaId: mediaId, episodeId: episodeId);
    }
  }
}
