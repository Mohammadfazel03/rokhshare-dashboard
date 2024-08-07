import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/series/data/repositories/series_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:flutter/foundation.dart';

part 'series_page_state.dart';

class SeriesPageCubit extends Cubit<SeriesPageState> {
  final SeriesRepository _repository;

  SeriesPageCubit({required SeriesRepository repository})
      : _repository = repository,
        super(SeriesPageInitial());

  void saveSeries({
    required List<int> genres,
    required List<int> countries,
    required String releaseDate,
    required Uint8List thumbnail,
    required Uint8List poster,
    required String thumbnailName,
    required String posterName,
    required String value,
    required String name,
    required String synopsis,
    required int trailer,
  }) async {
    emit(SeriesPageLoading());
    var res = await _repository.saveSeries(
        genres: genres,
        countries: countries,
        releaseDate: releaseDate,
        thumbnail: thumbnail,
        poster: poster,
        thumbnailName: thumbnailName,
        posterName: posterName,
        value: value,
        name: name,
        trailer: trailer,
        synopsis: synopsis);
    if (res is DataSuccess) {
      emit(SeriesPageSuccessAppend());
    } else {
      emit(SeriesPageFailAppend(message: res.error ?? "", code: res.code));
    }
  }

// void editSeries({
//   required int id,
//   int? time,
//   List<int>? genres,
//   List<int>? countries,
//   int? video,
//   String? releaseDate,
//   int? trailer,
//   Uint8List? thumbnail,
//   Uint8List? poster,
//   String? thumbnailName,
//   String? posterName,
//   List<Map<String, String?>>? casts,
//   String? synopsis,
//   String? name,
//   String? value,
// }) async {
//   emit(SeriesPageLoading());
//   var res = await _repository.editSeries(
//       time: time,
//       genres: genres,
//       countries: countries,
//       video: video,
//       releaseDate: releaseDate,
//       trailer: trailer,
//       thumbnail: thumbnail,
//       poster: poster,
//       thumbnailName: thumbnailName,
//       posterName: posterName,
//       casts: casts,
//       value: value,
//       name: name,
//       synopsis: synopsis,
//       id: id);
//   if (res is DataSuccess) {
//     emit(SeriesPageSuccessUpdate());
//   } else {
//     emit(SeriesPageFailAppend(message: res.error ?? "", code: res.code));
//   }
// }

// void getSeries({required int id}) async {
//   emit(SeriesPageLoading());
//   var res = await _repository.getSeries(id);
//   if (res is DataSuccess) {
//     emit(SeriesPageSuccess(data: res.data!));
//   } else {
//     emit(SeriesPageFail(message: res.error ?? "", code: res.code));
//   }
// }
}
