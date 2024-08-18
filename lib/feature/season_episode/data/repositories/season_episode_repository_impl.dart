import 'package:dashboard/feature/season_episode/data/remote/model/episode.dart';
import 'package:dashboard/feature/season_episode/data/remote/season_episode_api_service.dart';
import 'package:dashboard/feature/season_episode/data/repositories/season_episode_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:dio/dio.dart';

class SeasonEpisodeRepositoryImpl extends SeasonEpisodeRepository {
  final SeasonEpisodeApiService _api;

  SeasonEpisodeRepositoryImpl({required SeasonEpisodeApiService api})
      : _api = api;

  @override
  Future<DataResponse<PageResponse<Episode>>> getEpisodes(
      {required int seasonId, int page = 1}) async {
    try {
      Response response =
          await _api.getEpisodes(seasonId: seasonId, page: page);
      if (response.statusCode == 200) {
        return DataSuccess(
            PageResponse.fromJson(response.data, (s) => Episode.fromJson(s)));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 404) {
          return const DataFailed('صفحه مورد نظر یافت نشد.');
        }
        int cat = ((exception.response?.statusCode ?? 0) / 100).round();
        if (cat == 5) {
          return const DataFailed('سایت در حال تعمیر است بعداً تلاش کنید.');
        }
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    }
  }

  @override
  Future<DataResponse<void>> deleteEpisode({required int id}) async {
    try {
      Response response = await _api.deleteEpisode(id: id);
      if (response.statusCode == 204) {
        return const DataSuccess(null);
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 404) {
          return const DataFailed('صفحه مورد نظر یافت نشد.');
        }
        int cat = ((exception.response?.statusCode ?? 0) / 100).round();
        if (cat == 5) {
          return const DataFailed('سایت در حال تعمیر است بعداً تلاش کنید.');
        }
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    }
  }
}
