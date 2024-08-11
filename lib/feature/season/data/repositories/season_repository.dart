import 'package:dashboard/feature/season/data/remote/model/season.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:flutter/foundation.dart';

abstract class SeasonRepository {
  Future<DataResponse<PageResponse<Season>>> getSeasons(
      {required int seriesId, int page = 1});

  Future<DataResponse<Season>> getSeason({required int id});

  Future<DataResponse<String>> saveSeason(
      {required int seriesId,
      required Uint8List poster,
      required Uint8List thumbnail,
      required int number,
      required String publicationDate,
      String? name});

  Future<DataResponse<String>> editSeason(
      {required int id,
      Uint8List? poster,
      Uint8List? thumbnail,
      int? number,
      String? publicationDate,
      String? name});

  Future<DataResponse<void>> deleteSeason({required int id});
}
