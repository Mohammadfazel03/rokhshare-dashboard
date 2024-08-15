import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/episode/data/repositories/episode_repository.dart';
import 'package:dashboard/feature/season_episode/data/remote/model/episode.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:flutter/foundation.dart';

part 'episode_page_state.dart';

class EpisodePageCubit extends Cubit<EpisodePageState> {
  final EpisodeRepository _repository;

  EpisodePageCubit({required EpisodeRepository repository})
      : _repository = repository,
        super(EpisodePageInitial());

  void saveEpisode({
    required int seasonId,
    required int time,
    required int number,
    required int video,
    required String releaseDate,
    required int trailer,
    required Uint8List thumbnail,
    required Uint8List poster,
    required String thumbnailName,
    required String posterName,
    required List<Map<String, String?>> casts,
    String? synopsis,
    String? name,
  }) async {
    emit(EpisodePageLoading());
    var res = await _repository.saveEpisode(
        time: time,
        video: video,
        releaseDate: releaseDate,
        trailer: trailer,
        thumbnail: thumbnail,
        poster: poster,
        thumbnailName: thumbnailName,
        posterName: posterName,
        casts: casts,
        name: name,
        synopsis: synopsis,
        seasonId: seasonId,
        number: number);
    if (res is DataSuccess) {
      emit(EpisodePageSuccessAppend());
    } else {
      emit(EpisodePageFailAppend(message: res.error ?? "", code: res.code));
    }
  }

  void editEpisode(
      {required int id,
      int? time,
      int? number,
      int? video,
      String? releaseDate,
      int? trailer,
      Uint8List? thumbnail,
      Uint8List? poster,
      String? thumbnailName,
      String? posterName,
      List<Map<String, String?>>? casts,
      String? synopsis,
      String? name}) async {
    emit(EpisodePageLoading());
    var res = await _repository.editEpisode(
        time: time,
        video: video,
        releaseDate: releaseDate,
        trailer: trailer,
        thumbnail: thumbnail,
        poster: poster,
        thumbnailName: thumbnailName,
        posterName: posterName,
        casts: casts,
        name: name,
        synopsis: synopsis,
        id: id,
        number: number);
    if (res is DataSuccess) {
      emit(EpisodePageSuccessUpdate());
    } else {
      emit(EpisodePageFailAppend(message: res.error ?? "", code: res.code));
    }
  }

  void getEpisode({required int id}) async {
    emit(EpisodePageLoading());
    var res = await _repository.getEpisode(id);
    if (res is DataSuccess) {
      emit(EpisodePageSuccess(data: res.data!));
    } else {
      emit(EpisodePageFail(message: res.error ?? "", code: res.code));
    }
  }
}
