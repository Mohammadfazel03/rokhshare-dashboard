import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class MediaApiService {
  final Dio _dio;

  MediaApiService({required Dio dio}) : _dio = dio;

  Future<dynamic> getMovies({int page = 1}) async {
    return await _dio
        .get("admin/media/movie/", queryParameters: {"page": page});
  }

  Future<dynamic> deleteMovie({required int id}) async {
    return await _dio.delete("movie/$id/");
  }

  Future<dynamic> getSeries({int page = 1}) async {
    return await _dio
        .get("admin/media/series/", queryParameters: {"page": page});
  }

  Future<dynamic> deleteSeries({required int id}) async {
    return await _dio.delete("series/$id/");
  }

  Future<dynamic> getGenres({int page = 1}) async {
    return await _dio.get("genre/", queryParameters: {"page": page});
  }

  Future<dynamic> getCountries({int page = 1}) async {
    return await _dio.get("country/", queryParameters: {"page": page});
  }

  Future<dynamic> getSliders({int page = 1}) async {
    Map<String, dynamic> query = {"page": page};
    return await _dio.get("slider/", queryParameters: query);
  }

  Future<dynamic> getSlider({required int id}) async {
    return await _dio.get("slider/$id/");
  }

  Future<dynamic> deleteSlider({required int id}) async {
    return await _dio.delete("slider/$id/");
  }

  Future<dynamic> saveSliders(
      {required int mediaId,
      required int priority,
      required String title,
      required String description,
      required Uint8List thumbnail,
      required Uint8List poster,
      required String thumbnailName,
      required String posterName}) async {
    Map<String, dynamic> form = {
      "poster": MultipartFile.fromBytes(poster, filename: posterName),
      "thumbnail": MultipartFile.fromBytes(thumbnail, filename: thumbnailName),
      "media": mediaId,
      "priority": priority,
      "title": title,
      "description": description,
    };
    return await _dio.post("slider/",
        options: Options(headers: {
          "contentType": "multipart/form-data",
        }),
        data: FormData.fromMap(form));
  }

  Future<dynamic> editSliders(
      {required int id,
      int? mediaId,
      int? priority,
      String? title,
      String? description,
      Uint8List? thumbnail,
      Uint8List? poster,
      String? thumbnailName,
      String? posterName}) async {
    Map<String, dynamic> form = {};
    if (title != null) {
      form['title'] = title;
    }
    if (description != null) {
      form['description'] = description;
    }
    if (mediaId != null) {
      form['media'] = mediaId;
    }
    if (priority != null) {
      form['priority'] = priority;
    }
    if (thumbnail != null) {
      form['thumbnail'] =
          MultipartFile.fromBytes(thumbnail, filename: thumbnailName);
    }
    if (poster != null) {
      form['poster'] = MultipartFile.fromBytes(poster, filename: posterName);
    }
    return await _dio.patch("slider/$id/",
        options: Options(headers: {
          "contentType": "multipart/form-data",
        }),
        data: FormData.fromMap(form));
  }

  Future<dynamic> getArtists({int page = 1}) async {
    return await _dio
        .get("admin/media/artist/", queryParameters: {"page": page});
  }

  Future<dynamic> getCollections({int page = 1}) async {
    return await _dio
        .get("admin/media/collection/", queryParameters: {"page": page});
  }

  Future<dynamic> postCollection({required title, required poster}) async {
    return await _dio.post("collection/",
        options: Options(headers: {
          "contentType": "multipart/form-data",
        }),
        data: FormData.fromMap({
          "poster": MultipartFile.fromBytes(poster, filename: "poster.png"),
          "name": title
        }));
  }

  Future<dynamic> deleteCollection({required int id}) async {
    return await _dio.delete("collection/$id/");
  }

  Future<dynamic> getCollection({required int id}) async {
    return await _dio.get("collection/$id/");
  }

  Future<dynamic> updateCollection({required int id, poster, title}) async {
    Map<String, dynamic> form = {};
    if (poster != null) {
      form['poster'] = MultipartFile.fromBytes(poster, filename: "poster.png");
    }
    if (title != null) {
      form['name'] = title;
    }
    return await _dio.patch("collection/$id/",
        options: Options(headers: {
          "contentType": "multipart/form-data",
        }),
        data: FormData.fromMap(form));
  }

  Future<dynamic> postGenre({required title, required poster}) async {
    return await _dio.post("genre/",
        options: Options(headers: {
          "contentType": "multipart/form-data",
        }),
        data: FormData.fromMap({
          "poster": MultipartFile.fromBytes(poster, filename: "poster.png"),
          "title": title
        }));
  }

  Future<dynamic> deleteGenre({required int id}) async {
    return await _dio.delete("genre/$id/");
  }

  Future<dynamic> getGenre({required int id}) async {
    return await _dio.get("genre/$id/");
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
          "contentType": "multipart/form-data",
        }),
        data: FormData.fromMap(form));
  }

  Future<dynamic> postCountry({required name, required flag}) async {
    return await _dio.post("country/",
        options: Options(headers: {
          "contentType": "multipart/form-data",
        }),
        data: FormData.fromMap({
          "flag": MultipartFile.fromBytes(flag, filename: "flag.png"),
          "name": name
        }));
  }

  Future<dynamic> deleteCountry({required int id}) async {
    return await _dio.delete("country/$id/");
  }

  Future<dynamic> getCountry({required int id}) async {
    return await _dio.get("country/$id/");
  }

  Future<dynamic> updateCountry({required int id, flag, name}) async {
    Map<String, dynamic> form = {};
    if (flag != null) {
      form['flag'] = MultipartFile.fromBytes(flag, filename: "flag.png");
    }
    if (name != null) {
      form['name'] = name;
    }
    return await _dio.patch("country/$id/",
        options: Options(headers: {
          "contentType": "multipart/form-data",
        }),
        data: FormData.fromMap(form));
  }

  Future<dynamic> postArtist(
      {required name, required image, required bio}) async {
    return await _dio.post("artist/",
        options: Options(headers: {
          "contentType": "multipart/form-data",
        }),
        data: FormData.fromMap({
          "image": MultipartFile.fromBytes(image, filename: "image.png"),
          "name": name,
          "biography": bio
        }));
  }

  Future<dynamic> deleteArtist({required int id}) async {
    return await _dio.delete("artist/$id/");
  }

  Future<dynamic> getArtist({required int id}) async {
    return await _dio.get("artist/$id/");
  }

  Future<dynamic> updateArtist({required int id, image, name, bio}) async {
    Map<String, dynamic> form = {};
    if (image != null) {
      form['image'] = MultipartFile.fromBytes(image, filename: "image.png");
    }
    if (name != null) {
      form['name'] = name;
    }
    if (bio != null) {
      form['biography'] = bio;
    }
    return await _dio.patch("artist/$id/",
        options: Options(headers: {
          "contentType": "multipart/form-data",
        }),
        data: FormData.fromMap(form));
  }

  Future<dynamic> changeCollectionState(
      {required int collectionId, required int state}) async {
    return await _dio.post("collection/$collectionId/state/",
        data: FormData.fromMap({"state": state}));
  }
}
