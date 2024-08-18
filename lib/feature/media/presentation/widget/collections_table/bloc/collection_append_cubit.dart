import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/media/data/remote/model/collection.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:flutter/material.dart';

part 'collection_append_state.dart';

class CollectionAppendCubit extends Cubit<CollectionAppendState> {
  final MediaRepository _repository;

  CollectionAppendCubit({required MediaRepository repository})
      : _repository = repository,
        super(CollectionAppendInitial());

  Future<void> saveCollection({title, poster}) async {
    emit(CollectionAppendLoading());
    DataResponse<void> response =
        await _repository.postCollection(title: title, poster: poster);
    if (response is DataFailed) {
      emit(CollectionAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(CollectionAppendSuccessAppend());
    }
  }

  Future<void> getCollection({required int id}) async {
    emit(CollectionAppendLoading());
    DataResponse<Collection> response = await _repository.getCollection(id: id);
    if (response is DataFailed) {
      emit(CollectionAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(CollectionAppendSuccess(collection: response.data!));
    }
  }

  Future<void> updateCollection({required int id, poster, title}) async {
    emit(CollectionAppendLoading());
    DataResponse<void> response = await _repository.updateCollection(
        id: id, title: title, poster: poster);
    if (response is DataFailed) {
      emit(CollectionAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(CollectionAppendSuccessUpdate());
    }
  }
}
