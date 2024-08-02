import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class MovieApiService {
  final Dio _dio;

  MovieApiService({required Dio dio}) : _dio = dio;

  Future<dynamic> getArtists({int page = 1, String? search = ""}) async {
    Map<String, dynamic> query = {"page": page};
    if (search?.isNotEmpty ?? false) {
      query['search'] = search;
    }
    return await _dio.get("artist/", queryParameters: query);
  }

  Future<dynamic> getCountries() async {
    return await _dio.get("admin/media/country/");
  }

  Future<dynamic> getGenres() async {
    return await _dio.get("admin/media/genre/");
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
          "contentType": "multipart/form-data",
        }));
  }

  Future<dynamic> saveMovie({
    required int time,
    required List<int> genres,
    required List<int> countries,
    required int video,
    required String releaseDate,
    required int trailer,
    required Uint8List thumbnail,
    required Uint8List poster,
    required String thumbnailName,
    required String posterName,
    required List<Map<String, String?>> casts,
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
          "contentType": "multipart/form-data",
        }));
  }

  Future<dynamic> getMovie(int id) async {
    return await _dio.get("movie/$id/");
  }

  Future<dynamic> editMovie({
    required int id,
    int? time,
    List<int>? genres,
    List<int>? countries,
    int? video,
    String? releaseDate,
    int? trailer,
    Uint8List? thumbnail,
    Uint8List? poster,
    String? thumbnailName,
    String? posterName,
    List<Map<String, String?>>? casts,
    String? synopsis,
    String? name,
    String? value,
  }) async {
    Map<String, dynamic> form = {};
    if (time != null) {
      form['time'] = time;
    }
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
    if (video != null) {
      form['video'] = video;
    }
    if (releaseDate != null) {
      form['release_date'] = releaseDate;
    }
    if (trailer != null) {
      form['trailer'] = trailer;
    }
    if (casts != null) {
      form['casts'] = jsonEncode(casts);
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

    return await _dio.patch('movie/$id/',
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
