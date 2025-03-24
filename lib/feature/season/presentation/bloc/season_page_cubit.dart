import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/season/data/remote/model/season.dart';
import 'package:dashboard/feature/season/data/repositories/season_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/error_entity.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:collection/collection.dart';

part 'season_page_state.dart';

class SeasonPageCubit extends Cubit<SeasonPageState> {
  final SeasonRepository _repository;

  SeasonPageCubit({required SeasonRepository repository})
      : _repository = repository,
        super(SeasonPageState());

  Future<void> getData({required int seriesId}) async {
    if (state.isLoading) return;
    if (state.keys == null) {
      emit(state.copyWith(isLoading: true, keys: [0], pages: [[Season()]]));
    } else {
      emit(state.copyWith(isLoading: true));
    }
    int page = ((state.keys?.last ?? 0) > 0) ? state.keys!.last : 1;
    DataResponse<PageResponse<Season>> response = await _repository.getSeasons(
        seriesId: seriesId, page: page);
    if (response is DataFailed) {
      emit(state.copyWith(
          isLoading: false,
          error: ErrorEntity(
              title: "خطا در دریافت فصل ها",
              error: response.error ?? "مشکلی پیش آمده است",
              code: response.code)));
    } else {
      final newKey = page + 1;
      emit(state.copyWith(
          error: null,
          isLoading: false,
          pages: [...?state.pages, response.data!.results ?? []],
          keys: [...?state.keys, newKey],
          hasNextPage: response.data!.totalPages! > newKey));
    }
  }

  void refresh() {
    emit(state.reset());
  }

  Future<void> delete({required int id}) async {
    emit(state.copyWith(deleteLoading: true));
    DataResponse<void> response = await _repository.deleteSeason(id: id);
    if (response is DataFailed) {
      emit(state.copyWith(
          deleteLoading: false,
          deleteError: ErrorEntity(
              title: "خطا در حذف فصل",
              error: response.error ?? "مشکلی پیش آمده است",
              code: response.code == 403 ? 403 : 1)));
    } else {
      emit(state.reset());
    }
  }
}
