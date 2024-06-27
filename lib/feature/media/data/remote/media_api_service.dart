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

  Future<dynamic> getGenres({int page = 1}) async {
    return await _dio.get("admin/media/genre/",
        queryParameters: {"page": page},
        options: Options(headers: {"Authorization": "Bearer $_accessToken"}));
  }

  Future<dynamic> getCountry({int page = 1}) async {
    return await _dio.get("admin/media/country/",
        queryParameters: {"page": page},
        options: Options(headers: {"Authorization": "Bearer $_accessToken"}));
  }

  Future<dynamic> getSlider({int page = 1}) async {
    return await _dio.get("admin/media/slider/",
        queryParameters: {"page": page},
        options: Options(headers: {"Authorization": "Bearer $_accessToken"}));
  }

  Future<dynamic> getArtist({int page = 1}) async {
    return await _dio.get("admin/media/artist/",
        queryParameters: {"page": page},
        options: Options(headers: {"Authorization": "Bearer $_accessToken"}));
  }

  Future<dynamic> getCollection({int page = 1}) async {
    return await _dio.get("admin/media/collection/",
        queryParameters: {"page": page},
        options: Options(headers: {"Authorization": "Bearer $_accessToken"}));
  }

  Future<dynamic> postGenre({required title, required poster}) async {
    return await _dio.post("genre/",
        options: Options(headers: {
          "Authorization": "Bearer $_accessToken",
          "contentType": "multipart/form-data",
        }),
        data: FormData.fromMap({
          "poster": MultipartFile.fromBytes(poster, filename: "poster.png"),
          "title": title
        }));
  }

  Future<dynamic> deleteGenre({required int id}) async {
    return await _dio.delete("genre/$id/",
        options: Options(headers: {
          "Authorization": "Bearer $_accessToken",
          "contentType": "multipart/form-data",
        }));
  }

  Future<dynamic> getGenre({required int id}) async {
    return await _dio.get("genre/$id/",
        options: Options(headers: {
          "Authorization": "Bearer $_accessToken",
          "contentType": "multipart/form-data",
        }));
  }

  Future<dynamic> updateGenre({required int id, poster, title}) async {
    Map<String, dynamic> form = {};
    if (poster != null) {
      form['poster'] = MultipartFile.fromBytes(poster, filename: "poster.png");
    }
    if (title != null) {
      form['title'] = title;
    }
    return await _dio.patch("genre/$id/",
        options: Options(headers: {
          "Authorization": "Bearer $_accessToken",
          "contentType": "multipart/form-data",
        }),
        data: FormData.fromMap(form));
  }
}
