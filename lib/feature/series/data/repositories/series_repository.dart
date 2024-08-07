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
}
