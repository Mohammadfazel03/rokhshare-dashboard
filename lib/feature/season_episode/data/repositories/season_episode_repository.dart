import 'package:dashboard/feature/season_episode/data/remote/model/episode.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';

abstract class SeasonEpisodeRepository {
  Future<DataResponse<PageResponse<Episode>>> getEpisodes(
      {required int seasonId, int page = 1});

  Future<DataResponse<void>> deleteEpisode({required int id});
}
