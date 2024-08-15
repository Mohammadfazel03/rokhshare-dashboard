import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/season_episode/data/remote/model/episode.dart';
import 'package:dashboard/feature/season_episode/data/repositories/season_episode_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:flutter/material.dart';

part 'season_episode_page_state.dart';

class SeasonEpisodePageCubit extends Cubit<SeasonEpisodePageState> {
  final SeasonEpisodeRepository _repository;

  SeasonEpisodePageCubit({required SeasonEpisodeRepository repository})
      : _repository = repository,
        super(const SeasonEpisodePageLoading());

  Future<void> getData({required int seasonId, int page = 1}) async {
    emit(SeasonEpisodePageLoading(
        numberPages: state.numberPages, pageIndex: page));
    DataResponse<PageResponse<Episode>> response =
        await _repository.getEpisodes(page: page, seasonId: seasonId);
    if (response is DataFailed) {
      emit(SeasonEpisodePageError(
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: page,
          numberPages: state.numberPages));
    } else {
      emit(SeasonEpisodePageSuccess(
          data: response.data!,
          numberPages: response.data!.totalPages!,
          pageIndex: page));
    }
  }

  void refreshPage({required int seasonId}) {
    getData(page: state.pageIndex, seasonId: seasonId);
  }

  Future<void> delete({required int id, required int seasonId}) async {
    emit(SeasonEpisodePageLoading(
        numberPages: state.numberPages, pageIndex: state.pageIndex));
    DataResponse<void> response = await _repository.deleteEpisode(id: id);
    if (response is DataFailed) {
      emit(SeasonEpisodePageError(
          title: "خطا در حذف قسمت",
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: state.pageIndex,
          numberPages: state.numberPages));
    } else {
      getData(page: state.pageIndex, seasonId: seasonId);
    }
  }
}
