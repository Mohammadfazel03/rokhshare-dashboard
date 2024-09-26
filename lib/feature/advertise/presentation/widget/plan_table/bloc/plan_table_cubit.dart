import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/advertise/data/repositories/advertise_repository.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/plan.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:flutter/material.dart';

part 'plan_table_state.dart';

class PlanTableCubit extends Cubit<PlanTableState> {
  final AdvertiseRepository _repository;

  PlanTableCubit({required AdvertiseRepository repository})
      : _repository = repository,
        super(const PlanTableLoading());

  Future<void> getData({int page = 1}) async {
    emit(PlanTableLoading(numberPages: state.numberPages, pageIndex: page));
    DataResponse<PageResponse<Plan>> response =
        await _repository.getPlans(page: page);
    if (response is DataFailed) {
      emit(PlanTableError(
          title: "خطا در دریافت طرح ها",
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: page,
          numberPages: state.numberPages));
    } else {
      emit(PlanTableSuccess(
          data: response.data!,
          numberPages: response.data!.totalPages!,
          pageIndex: page));
    }
  }

  Future<void> changeState({required int id, required bool isEnable}) async {
    emit(PlanTableLoading(
        numberPages: state.numberPages, pageIndex: state.pageIndex));
    DataResponse<void> response =
        await _repository.changePlanState(planId: id, isEnable: isEnable);
    if (response is DataFailed) {
      emit(PlanTableError(
          title: "خطا در تغییر وضعیت ظرح",
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: state.pageIndex,
          numberPages: state.numberPages));
    } else {
      getData(page: state.pageIndex);
    }
  }
}
