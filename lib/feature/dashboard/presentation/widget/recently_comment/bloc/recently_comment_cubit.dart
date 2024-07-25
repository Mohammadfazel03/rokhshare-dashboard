import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/comment.dart';
import 'package:dashboard/feature/dashboard/data/repositories/dashboard_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:flutter/material.dart';

part 'recently_comment_state.dart';

class RecentlyCommentCubit extends Cubit<RecentlyCommentState> {
  final DashboardRepository _repository;

  RecentlyCommentCubit({required DashboardRepository repository})
      : _repository = repository,
        super(RecentlyCommentLoading());


  Future<void> getData() async {
    emit(RecentlyCommentLoading());
    DataResponse<List<Comment>> response = await _repository.getRecentlyComment();
    if (response is DataFailed) {
      emit(RecentlyCommentError(
          error: response.error ?? "مشکلی پیش آمده است", code: response.code));
    } else {
      emit(RecentlyCommentSuccessful(data: response.data!));
    }
  }
}
