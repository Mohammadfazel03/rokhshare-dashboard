import 'package:dashboard/feature/series/data/remote/model/series.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:flutter/foundation.dart';

abstract class SeriesRepository {
  Future<DataResponse<String>> saveSeries(
      {required List<int> genres,
      required List<int> countries,
      required String releaseDate,
      required Uint8List thumbnail,
      required Uint8List poster,
      required String thumbnailName,
      required String posterName,
      required String synopsis,
      required String name,
      required String value,
      required int trailer});

  Future<DataResponse<Series>> getSeries({required int id});

  Future<DataResponse<String>> editSeries(
      {required int id,
      List<int>? genres,
      List<int>? countries,
      String? releaseDate,
      Uint8List? thumbnail,
      Uint8List? poster,
      String? thumbnailName,
      String? posterName,
      String? synopsis,
      String? name,
      String? value,
      int? trailer});
}
