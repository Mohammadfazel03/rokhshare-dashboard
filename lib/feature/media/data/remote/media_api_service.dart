import 'package:dio/dio.dart';

class MediaApiService {
  final Dio _dio;
  final String _accessToken;

  MediaApiService({required Dio dio, required String accessToken})
      : _dio = dio,
        _accessToken = accessToken;

  Future<dynamic> getMovies({int page = 1}) async {
    return await _dio.get("admin/media/movie/",
        queryParameters: {"page": page},
        options: Options(headers: {"Authorization": "Bearer $_accessToken"}));
  }

  Future<dynamic> getSeries({int page = 1}) async {
    return await _dio.get("admin/media/series/",
        queryParameters: {"page": page},
        options: Options(headers: {"Authorization": "Bearer $_accessToken"}));
  }

  Future<dynamic> getGenre({int page = 1}) async {
    return await _dio.get("admin/media/genre/",
        queryParameters: {"page": page},
        options: Options(headers: {"Authorization": "Bearer $_accessToken"}));
  }
}
