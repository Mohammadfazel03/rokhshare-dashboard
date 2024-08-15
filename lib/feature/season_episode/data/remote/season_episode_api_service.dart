import 'package:dio/dio.dart';

class SeasonEpisodeApiService {
  final Dio _dio;

  SeasonEpisodeApiService({required Dio dio}) : _dio = dio;

  Future<dynamic> getEpisodes({required int seasonId, int page = 1}) async {
    return await _dio
        .get("season/$seasonId/episode", queryParameters: {"page": page});
  }

  Future<dynamic> deleteEpisode({required int id}) async {
    return await _dio.delete("episode/$id/");
  }
}
