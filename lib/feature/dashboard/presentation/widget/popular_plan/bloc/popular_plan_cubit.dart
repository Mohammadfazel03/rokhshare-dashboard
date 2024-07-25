import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/plan.dart';
import 'package:dashboard/feature/dashboard/data/repositories/dashboard_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:flutter/material.dart';

part 'popular_plan_state.dart';

class PopularPlanCubit extends Cubit<PopularPlanState> {
  final DashboardRepository _repository;

  PopularPlanCubit({required DashboardRepository repository})
      : _repository = repository,
        super(PopularPlanLoading());

  Future<void> getData() async {
    emit(PopularPlanLoading());
    DataResponse<List<Plan>> response = await _repository.getPopularPlan();
    if (response is DataFailed) {
      emit(PopularPlanError(
          error: response.error ?? "مشکلی پیش آمده است", code: response.code));
    } else {
      emit(PopularPlanSuccessful(data: response.data!));
    }
  }
}
