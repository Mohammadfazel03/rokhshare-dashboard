import 'package:dashboard/feature/movie/data/remote/model/comment.dart';
import 'package:dashboard/feature/season_episode/data/remote/model/episode.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:flutter/foundation.dart';

abstract class EpisodeRepository {
  Future<DataResponse<String>> saveEpisode({
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
  });

  Future<DataResponse<Episode>> getEpisode(int id);

  Future<DataResponse<String>> editEpisode({
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
  });

  Future<DataResponse<PageResponse<Comment>>> getComments(
      {required int episodeId, int page = 1});

  Future<DataResponse<void>> changeCommentState(
      {required int commentId, required int state});
}
