import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/advertise/data/repositories/advertise_repository.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/ads.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:flutter/material.dart';

part 'advertise_append_state.dart';

class AdvertiseAppendCubit extends Cubit<AdvertiseAppendState> {
  final AdvertiseRepository _repository;

  AdvertiseAppendCubit({required AdvertiseRepository repository})
      : _repository = repository,
        super(AdvertiseAppendInitial());

  Future<void> saveAdvertise(
      {required String title,
      required int numberRepeated,
      required int fileId,
      required int time}) async {
    emit(AdvertiseAppendLoading());
    DataResponse<void> response = await _repository.addAdvertise(
        title: title,
        numberRepeated: numberRepeated,
        fileId: fileId,
        time: time);
    if (response is DataFailed) {
      emit(AdvertiseAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(AdvertiseAppendSuccessAppend());
    }
  }

  Future<void> getAdvertise({required int id}) async {
    emit(AdvertiseAppendLoading());
    DataResponse<Advertise> response = await _repository.getAdvertise(id: id);
    if (response is DataFailed) {
      emit(AdvertiseAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(AdvertiseAppendSuccess(advertise: response.data!));
    }
  }

  Future<void> updateAdvertise(
      {required int id,
      String? title,
      int? numberRepeated,
      int? fileId,
      int? time}) async {
    emit(AdvertiseAppendLoading());
    DataResponse<void> response = await _repository.editAdvertise(
        id: id,
        time: time,
        title: title,
        numberRepeated: numberRepeated,
        fileId: fileId);
    if (response is DataFailed) {
      emit(AdvertiseAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(AdvertiseAppendSuccessUpdate());
    }
  }
}
