import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/advertise/data/repositories/advertise_repository.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/plan.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:flutter/material.dart';

part 'plan_append_state.dart';

class PlanAppendCubit extends Cubit<PlanAppendState> {
  final AdvertiseRepository _repository;

  PlanAppendCubit({required AdvertiseRepository repository})
      : _repository = repository,
        super(PlanAppendInitial());

  Future<void> savePlan(
      {required String title,
      required String description,
      required int days,
      required int price}) async {
    emit(PlanAppendLoading());
    DataResponse<void> response = await _repository.addPlan(
        title: title, description: description, days: days, price: price);
    if (response is DataFailed) {
      emit(PlanAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(PlanAppendSuccessAppend());
    }
  }

  Future<void> getPlan({required int id}) async {
    emit(PlanAppendLoading());
    DataResponse<Plan> response = await _repository.getPlan(id: id);
    if (response is DataFailed) {
      emit(PlanAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(PlanAppendSuccess(plan: response.data!));
    }
  }
}
