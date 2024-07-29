import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/movie/data/remote/model/movie.dart';
import 'package:dashboard/feature/movie/data/repositories/movie_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:flutter/foundation.dart';

part 'movie_page_state.dart';

class MoviePageCubit extends Cubit<MoviePageState> {
  final MovieRepository _repository;

  MoviePageCubit({required MovieRepository repository})
      : _repository = repository,
        super(MoviePageInitial());

  void saveMovie({
    required int time,
    required List<int> genres,
    required List<int> countries,
    required int video,
    required String releaseDate,
    required int trailer,
    required Uint8List thumbnail,
    required Uint8List poster,
    required String thumbnailName,
    required String posterName,
    required List<Map<String, String?>> casts,
    required String synopsis,
    required String value,
    required String name,
  }) async {
    emit(MoviePageLoading());
    var res = await _repository.saveMovie(
        time: time,
        genres: genres,
        countries: countries,
        video: video,
        releaseDate: releaseDate,
        trailer: trailer,
        thumbnail: thumbnail,
        poster: poster,
        thumbnailName: thumbnailName,
        posterName: posterName,
        casts: casts,
        value: value,
        name: name,
        synopsis: synopsis);
    if (res is DataSuccess) {
      emit(MoviePageSuccessAppend());
    } else {
      emit(MoviePageFailAppend(message: res.error ?? "", code: res.code));
    }
  }

  void editMovie({
    required int id,
    int? time,
    List<int>? genres,
    List<int>? countries,
    int? video,
    String? releaseDate,
    int? trailer,
    Uint8List? thumbnail,
    Uint8List? poster,
    String? thumbnailName,
    String? posterName,
    List<Map<String, String?>>? casts,
    String? synopsis,
    String? name,
    String? value,
  }) async {
    emit(MoviePageLoading());
    var res = await _repository.editMovie(
        time: time,
        genres: genres,
        countries: countries,
        video: video,
        releaseDate: releaseDate,
        trailer: trailer,
        thumbnail: thumbnail,
        poster: poster,
        thumbnailName: thumbnailName,
        posterName: posterName,
        casts: casts,
        value: value,
        name: name,
        synopsis: synopsis,
        id: id);
    if (res is DataSuccess) {
      emit(MoviePageSuccessUpdate());
    } else {
      emit(MoviePageFailAppend(message: res.error ?? "", code: res.code));
    }
  }

  void getMovie({required int id}) async {
    emit(MoviePageLoading());
    var res = await _repository.getMovie(id);
    if (res is DataSuccess) {
      emit(MoviePageSuccess(data: res.data!));
    } else {
      emit(MoviePageFail(message: res.error ?? "", code: res.code));
    }
  }
}
