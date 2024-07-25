import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/user.dart';
import 'package:dashboard/feature/dashboard/data/repositories/dashboard_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:flutter/material.dart';

part 'recently_user_state.dart';

class RecentlyUserCubit extends Cubit<RecentlyUserState> {
  final DashboardRepository _repository;

  RecentlyUserCubit({required DashboardRepository repository})
      : _repository = repository,
        super(RecentlyUserLoading());

  Future<void> getData() async {
    emit(RecentlyUserLoading());
    DataResponse<List<User>> response = await _repository.getRecentlyUser();
    if (response is DataFailed) {
      emit(RecentlyUserError(
          error: response.error ?? "مشکلی پیش آمده است", code: response.code));
    } else {
      emit(RecentlyUserSuccess(data: response.data!));
    }
  }
}
