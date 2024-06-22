import 'package:dio/dio.dart';

class MediaApiService {
  final Dio _dio;
  final String _accessToken;

  MediaApiService({required Dio dio, required String accessToken})
      : _dio = dio,
        _accessToken = accessToken;

  Future<dynamic> getMovies() async {
    return await _dio.get("admin/media/movie/",
        options: Options(headers: {
          "Authorization":
              "Bearer $_accessToken"
        }));
  }

  Future<dynamic> getSeries() async {
    return await _dio.get("admin/media/series/",
        options: Options(headers: {
          "Authorization":
              "Bearer $_accessToken"
        }));
  }
}
