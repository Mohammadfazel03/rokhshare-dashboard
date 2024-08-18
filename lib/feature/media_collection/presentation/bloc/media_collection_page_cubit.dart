import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/media_collection/data/repositories/media_collection_repository.dart';
import 'package:dashboard/feature/movie/data/remote/model/movie.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:flutter/material.dart';

part 'media_collection_page_state.dart';

class MediaCollectionPageCubit extends Cubit<MediaCollectionPageState> {
  final MediaCollectionRepository _repository;

  MediaCollectionPageCubit({required MediaCollectionRepository repository})
      : _repository = repository,
        super(const MediaCollectionPageLoading());

  Future<void> getData({required int collectionId, int page = 1}) async {
    emit(MediaCollectionPageLoading(
        numberPages: state.numberPages, pageIndex: page));
    DataResponse<PageResponse<Media>> response = await _repository
        .getMediaOfCollection(collectionId: collectionId, page: page);
    if (response is DataFailed) {
      emit(MediaCollectionPageError(
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: page,
          numberPages: state.numberPages));
    } else {
      emit(MediaCollectionPageSuccess(
          data: response.data!,
          numberPages: response.data!.totalPages!,
          pageIndex: page));
    }
  }

  void refreshPage({required int collectionId}) {
    getData(page: state.pageIndex, collectionId: collectionId);
  }

  Future<void> removeMedia(
      {required int mediaId, required int collectionId}) async {
    emit(MediaCollectionPageLoading(
        numberPages: state.numberPages, pageIndex: state.pageIndex));
    DataResponse<void> response = await _repository.removeMedia(
        collectionId: collectionId, mediaId: mediaId);
    if (response is DataFailed) {
      emit(MediaCollectionPageError(
          title: "خطا در حذف فیلم",
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: state.pageIndex,
          numberPages: state.numberPages));
    } else {
      getData(page: state.pageIndex, collectionId: collectionId);
    }
  }

  Future<void> addMedia(
      {required int mediaId, required int collectionId}) async {
    emit(MediaCollectionPageLoading(
        numberPages: state.numberPages, pageIndex: state.pageIndex));
    DataResponse<void> response = await _repository.addMedia(
        collectionId: collectionId, mediaId: mediaId);
    if (response is DataFailed) {
      emit(MediaCollectionPageError(
          title: "خطا در افزودن فیلم",
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: state.pageIndex,
          numberPages: state.numberPages));
    } else {
      getData(page: 1, collectionId: collectionId);
    }
  }
}
