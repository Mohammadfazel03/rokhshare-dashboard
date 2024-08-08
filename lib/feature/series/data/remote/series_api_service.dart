import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SeriesApiService {
  final Dio _dio;

  SeriesApiService({required Dio dio}) : _dio = dio;

  Future<dynamic> saveSeries({
    required List<int> genres,
    required List<int> countries,
    required String releaseDate,
    required Uint8List thumbnail,
    required Uint8List poster,
    required String thumbnailName,
    required String posterName,
    required String synopsis,
    required String name,
    required String value,
    required int trailer,
  }) async {
    var form = {
      'poster': MultipartFile.fromBytes(poster, filename: posterName),
      'thumbnail': MultipartFile.fromBytes(thumbnail, filename: thumbnailName),
      'genres': genres,
      'countries': countries,
      'release_date': releaseDate,
      'name': name,
      'value': value,
      'trailer': trailer,
      'synopsis': synopsis
    };

    return await _dio.post('series/',
        data: FormData.fromMap(form),
        options: Options(headers: {
          "contentType": "multipart/form-data",
        }));
  }

  Future<dynamic> getSeries(int id) async {
    return await _dio.get("series/$id/");
  }

  Future<dynamic> editSeries({
    required int id,
    List<int>? genres,
    List<int>? countries,
    String? releaseDate,
    int? trailer,
    Uint8List? thumbnail,
    Uint8List? poster,
    String? thumbnailName,
    String? posterName,
    String? synopsis,
    String? name,
    String? value,
  }) async {
    Map<String, dynamic> form = {};
    if (poster != null) {
      form['poster'] = MultipartFile.fromBytes(poster, filename: posterName);
    }
    if (thumbnail != null) {
      form['thumbnail'] =
          MultipartFile.fromBytes(thumbnail, filename: thumbnailName);
    }
    if (genres != null) {
      form['genres'] = genres;
    }
    if (countries != null) {
      form['countries'] = countries;
    }
    if (releaseDate != null) {
      form['release_date'] = releaseDate;
    }
    if (trailer != null) {
      form['trailer'] = trailer;
    }
    if (name != null) {
      form['name'] = name;
    }
    if (value != null) {
      form['value'] = value;
    }
    if (synopsis != null) {
      form['synopsis'] = synopsis;
    }

    return await _dio.patch('series/$id/',
        data: FormData.fromMap(form),
        options: Options(headers: {
          "contentType": "multipart/form-data",
        }));
  }

  Future<dynamic> getComments({required int mediaId, int page = 1}) async {
    Map<String, dynamic> query = {"page": page};
    return await _dio.get("comment/media/$mediaId/", queryParameters: query);
  }

  Future<dynamic> changeCommentState(
      {required int commentId, required int state}) async {
    return await _dio.post("comment/$commentId/state/",
        data: FormData.fromMap({"state": state}));
  }
}
