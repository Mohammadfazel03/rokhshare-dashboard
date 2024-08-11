import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/season/data/remote/model/season.dart';
import 'package:dashboard/feature/season/data/repositories/season_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:flutter/material.dart';

part 'season_page_state.dart';

class SeasonPageCubit extends Cubit<SeasonPageState> {
  final SeasonRepository _repository;

  SeasonPageCubit({required SeasonRepository repository})
      : _repository = repository,
        super(SeasonPageInitial());

  Future<void> getData({required int seriesId, int page = 1}) async {
    emit(SeasonPageLoading());
    DataResponse<PageResponse<Season>> response =
        await _repository.getSeasons(seriesId: seriesId, page: page);
    if (response is DataFailed) {
      emit(SeasonPageError(
          title: "خطا در دریافت فصل ها",
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(SeasonPageSuccess(data: response.data!));
    }
  }

  void refresh() {
    emit(SeasonPageRefresh());
  }

  Future<void> delete({required int id}) async {
    emit(SeasonPageLoading(code: 2));
    DataResponse<void> response = await _repository.deleteSeason(id: id);
    if (response is DataFailed) {
      emit(SeasonPageError(
          title: "خطا در حذف فصل",
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code == 403 ? 403 : 1));
    } else {
      refresh();
    }
  }
}
