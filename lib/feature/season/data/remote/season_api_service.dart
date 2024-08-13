import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SeasonApiService {
  final Dio _dio;

  SeasonApiService({required Dio dio}) : _dio = dio;

  Future<dynamic> getSeasons({required int seriesId, int page = 1}) async {
    Map<String, dynamic> query = {"page": page};
    return await _dio.get("/series/$seriesId/season/", queryParameters: query);
  }

  Future<dynamic> getSeason({required int id}) async {
    return await _dio.get("season/$id/");
  }

  Future<dynamic> deleteSeason({required int id}) async {
    return await _dio.delete("season/$id/");
  }

  Future<dynamic> saveSeasons(
      {required int seriesId,
      required Uint8List poster,
      required Uint8List thumbnail,
      required int number,
      required String publicationDate,
      String? name}) async {
    Map<String, dynamic> form = {
      "poster": MultipartFile.fromBytes(poster, filename: "poster.png"),
      "thumbnail":
          MultipartFile.fromBytes(thumbnail, filename: "thumbnail.png"),
      "series": seriesId,
      "number": number,
      "publication_date": publicationDate
    };
    if (name != null) {
      form['name'] = name;
    }
    return await _dio.post("season/",
        options: Options(headers: {
          "contentType": "multipart/form-data",
        }),
        data: FormData.fromMap(form));
  }

  Future<dynamic> editSeasons(
      {required int id,
      Uint8List? poster,
      Uint8List? thumbnail,
      int? number,
      String? publicationDate,
      String? name}) async {
    Map<String, dynamic> form = {};
    form['name'] = name;
    if (number != null) {
      form['number'] = number;
    }
    if (publicationDate != null) {
      form['publication_date'] = publicationDate;
    }
    if (thumbnail != null) {
      form['thumbnail'] =
          MultipartFile.fromBytes(thumbnail, filename: "thumbnail.png");
    }
    if (poster != null) {
      form['poster'] = MultipartFile.fromBytes(poster, filename: "poster.png");
    }
    return await _dio.patch("season/$id/",
        options: Options(headers: {
          "contentType": "multipart/form-data",
        }),
        data: FormData.fromMap(form));
  }
}
