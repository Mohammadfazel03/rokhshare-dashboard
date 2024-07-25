import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/ads.dart';
import 'package:dashboard/feature/dashboard/data/repositories/dashboard_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:flutter/material.dart';

part 'recently_advertise_state.dart';

class RecentlyAdvertiseCubit extends Cubit<RecentlyAdvertiseState> {
  final DashboardRepository _repository;

  RecentlyAdvertiseCubit({required DashboardRepository repository})
      : _repository = repository,
        super(RecentlyAdvertiseLoading());

  Future<void> getData() async {
    emit(RecentlyAdvertiseLoading());
    DataResponse<List<Advertise>> response = await _repository.getAdvertise();
    if (response is DataFailed) {
      emit(RecentlyAdvertiseError(
          error: response.error ?? "مشکلی پیش آمده است", code: response.code));
    } else {
      emit(RecentlyAdvertiseSuccessful(data: response.data!));
    }
  }
}
