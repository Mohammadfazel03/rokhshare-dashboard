import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/media/data/remote/model/slider.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:flutter/foundation.dart';

part 'slider_append_state.dart';

class SliderAppendCubit extends Cubit<SliderAppendState> {
  final MediaRepository _repository;

  SliderAppendCubit({required MediaRepository repository})
      : _repository = repository,
        super(SliderAppendInitial());

  Future<void> saveSlider(
      {required int mediaId,
      required int priority,
      required String title,
      required String description,
      required Uint8List thumbnail,
      required Uint8List poster,
      required String thumbnailName,
      required String posterName}) async {
    emit(SliderAppendLoading());
    DataResponse<String> response = await _repository.saveSlider(
        mediaId: mediaId,
        priority: priority,
        title: title,
        description: description,
        thumbnail: thumbnail,
        poster: poster,
        thumbnailName: thumbnailName,
        posterName: posterName);
    if (response is DataFailed) {
      emit(SliderAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(SliderAppendSuccessAppend());
    }
  }

  Future<void> getSlider({required int id}) async {
    emit(SliderAppendLoading());
    DataResponse<SliderModel> response = await _repository.getSlider(id: id);
    if (response is DataFailed) {
      emit(SliderAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(SliderAppendSuccess(slider: response.data!));
    }
  }

  Future<void> updateSlider(
      {required int id,
      int? mediaId,
      int? priority,
      String? title,
      String? description,
      Uint8List? thumbnail,
      Uint8List? poster,
      String? thumbnailName,
      String? posterName}) async {
    emit(SliderAppendLoading());
    DataResponse<String> response = await _repository.editSlider(
        id: id,
        mediaId: mediaId,
        priority: priority,
        title: title,
        description: description,
        thumbnail: thumbnail,
        poster: poster,
        thumbnailName: thumbnailName,
        posterName: posterName);
    if (response is DataFailed) {
      emit(SliderAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(SliderAppendSuccessUpdate());
    }
  }
}
