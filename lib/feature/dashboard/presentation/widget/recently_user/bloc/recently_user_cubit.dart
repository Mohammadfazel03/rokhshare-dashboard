import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/user.dart';
import 'package:dashboard/feature/dashboard/data/repositories/dashboard_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:flutter/material.dart';

part 'recently_user_state.dart';

class RecentlyUserCubit extends Cubit<RecentlyUserState> {
  final DashboardRepository _repository;

  RecentlyUserCubit({required DashboardRepository repository})
      : _repository = repository,
        super(const RecentlyUserLoading());

  Future<void> getData({int page = 1}) async {
    emit(RecentlyUserLoading(numberPages: state.numberPages, pageIndex: page));
    DataResponse<PageResponse<User>> response =
        await _repository.getRecentlyUser(page: page);
    if (response is DataFailed) {
      emit(RecentlyUserError(
          title: "خطا در دریافت کاربران",
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: page,
          numberPages: state.numberPages));
    } else {
      emit(RecentlyUserSuccess(
          data: response.data!,
          numberPages: response.data!.totalPages!,
          pageIndex: page));
    }
  }
}
