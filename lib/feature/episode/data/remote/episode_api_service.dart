import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class EpisodeApiService {
  final Dio _dio;

  EpisodeApiService({required Dio dio}) : _dio = dio;

  Future<dynamic> saveEpisode({
    required int seasonId,
    required int time,
    required int number,
    required int video,
    required String releaseDate,
    required int trailer,
    required Uint8List thumbnail,
    required Uint8List poster,
    required String thumbnailName,
    required String posterName,
    required List<Map<String, String?>> casts,
    String? synopsis,
    String? name,
  }) async {
    var form = {
      'poster': MultipartFile.fromBytes(poster, filename: posterName),
      'thumbnail': MultipartFile.fromBytes(thumbnail, filename: thumbnailName),
      'time': time,
      'video': video,
      'publication_date': releaseDate,
      'trailer': trailer,
      'casts': jsonEncode(casts),
      'number': number,
      'season': seasonId
    };

    if (name != null) {
      form['name'] = name;
    }
    if (synopsis != null) {
      form['synopsis'] = synopsis;
    }

    return await _dio.post('episode/',
        data: FormData.fromMap(form),
        options: Options(headers: {
          "contentType": "multipart/form-data",
        }));
  }

  Future<dynamic> getEpisode(int id) async {
    return await _dio.get("episode/$id/");
  }

  Future<dynamic> editEpisode({
    required int id,
    int? time,
    int? number,
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
  }) async {
    Map<String, dynamic> form = {};
    if (time != null) {
      form['time'] = time;
    }
    if (number != null) {
      form['number'] = number;
    }
    if (poster != null) {
      form['poster'] = MultipartFile.fromBytes(poster, filename: posterName);
    }
    if (thumbnail != null) {
      form['thumbnail'] =
          MultipartFile.fromBytes(thumbnail, filename: thumbnailName);
    }
    if (video != null) {
      form['video'] = video;
    }
    if (releaseDate != null) {
      form['publication_date'] = releaseDate;
    }
    if (trailer != null) {
      form['trailer'] = trailer;
    }
    if (casts != null) {
      form['casts'] = jsonEncode(casts);
    }
    form['name'] = name;
    form['synopsis'] = synopsis;

    return await _dio.patch('episode/$id/',
        data: FormData.fromMap(form),
        options: Options(headers: {
          "contentType": "multipart/form-data",
        }));
  }

  Future<dynamic> getComments({required int episodeId, int page = 1}) async {
    Map<String, dynamic> query = {"page": page};
    return await _dio.get("comment/episode/$episodeId/",
        queryParameters: query);
  }

  Future<dynamic> changeCommentState(
      {required int commentId, required int state}) async {
    return await _dio.post("comment/$commentId/state/",
        data: FormData.fromMap({"state": state}));
  }
}
