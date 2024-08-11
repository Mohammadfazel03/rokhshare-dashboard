import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/season/data/remote/model/season.dart';
import 'package:dashboard/feature/season/data/repositories/season_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:flutter/foundation.dart';

part 'season_append_state.dart';

class SeasonAppendCubit extends Cubit<SeasonAppendState> {
  final SeasonRepository _repository;

  SeasonAppendCubit({required SeasonRepository repository})
      : _repository = repository,
        super(SeasonAppendInitial());

  Future<void> saveSeason(
      {required int seriesId,
      required Uint8List poster,
      required Uint8List thumbnail,
      required int number,
      required String publicationDate,
      String? name}) async {
    emit(SeasonAppendLoading());
    DataResponse<String> response = await _repository.saveSeason(
        seriesId: seriesId,
        poster: poster,
        thumbnail: thumbnail,
        number: number,
        publicationDate: publicationDate,
        name: name);
    if (response is DataFailed) {
      emit(SeasonAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(SeasonAppendSuccessAppend());
    }
  }

  Future<void> getSeason({required int id}) async {
    emit(SeasonAppendLoading());
    DataResponse<Season> response = await _repository.getSeason(id: id);
    if (response is DataFailed) {
      emit(SeasonAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(SeasonAppendSuccess(season: response.data!));
    }
  }

  Future<void> updateSeason(
      {required int id,
      Uint8List? poster,
      Uint8List? thumbnail,
      int? number,
      String? publicationDate,
      String? name}) async {
    emit(SeasonAppendLoading());
    DataResponse<String> response = await _repository.editSeason(
        id: id,
        poster: poster,
        thumbnail: thumbnail,
        number: number,
        name: name,
        publicationDate: publicationDate);
    if (response is DataFailed) {
      emit(SeasonAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(SeasonAppendSuccessUpdate());
    }
  }
}
