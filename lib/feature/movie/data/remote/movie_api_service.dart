import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class MovieApiService {
  final Dio _dio;
  final String _accessToken;

  MovieApiService({required Dio dio, required String accessToken})
      : _dio = dio,
        _accessToken = accessToken;

  Future<dynamic> getArtists({int page = 1, String? search = ""}) async {
    Map<String, dynamic> query = {"page": page};
    if (search?.isNotEmpty ?? false) {
      query['search'] = search;
    }
    return await _dio.get("artist/",
        queryParameters: query,
        options: Options(headers: {"Authorization": "Bearer $_accessToken"}));
  }

  Future<dynamic> getCountries() async {
    return await _dio.get("admin/media/country/",
        options: Options(headers: {"Authorization": "Bearer $_accessToken"}));
  }

  Future<dynamic> getGenres() async {
    return await _dio.get("admin/media/genre/",
        options: Options(headers: {"Authorization": "Bearer $_accessToken"}));
  }

  Future<dynamic> uploadFile(
      {required List<int> fileBytes,
      required String filename,
      required int chunkIndex,
      required int totalChunk,
      String? uploadId}) async {
    var form = {
      'file': MultipartFile.fromBytes(fileBytes, filename: filename),
      'chunk_index': chunkIndex,
      'total_chunk': totalChunk
    };

    if (uploadId != null) {
      form['id'] = uploadId;
    }
    return await _dio.post('upload/',
        data: FormData.fromMap(form),
        options: Options(headers: {
          "Authorization": "Bearer $_accessToken",
          "contentType": "multipart/form-data",
        }));
  }

  Future<dynamic> saveMovie(
      {required int time,
      required List<int> genres,
      required List<int> countries,
      required int video,
      required String releaseDate,
      required int trailer,
      required Uint8List thumbnail,
      required Uint8List poster,
      required String thumbnailName,
      required String posterName,
      required List<Map<String, String>> casts,
      required String synopsis,
      required String name,
      required String value,
      }) async {
    var form = {
      'poster': MultipartFile.fromBytes(poster, filename: posterName),
      'thumbnail': MultipartFile.fromBytes(thumbnail, filename: thumbnailName),
      'time': time,
      'genres': genres,
      'countries': countries,
      'video': video,
      'release_date': releaseDate,
      'trailer': trailer,
      'casts': jsonEncode(casts),
      'name': name,
      'value': value,
      'synopsis': synopsis
    };

    return await _dio.post('movie/',
        data: FormData.fromMap(form),
        options: Options(headers: {
          "Authorization": "Bearer $_accessToken",
          "contentType": "multipart/form-data",
        }));
  }
}
