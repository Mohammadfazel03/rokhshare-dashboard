import 'package:dashboard/feature/episode/data/remote/episode_api_service.dart';
import 'package:dashboard/feature/episode/data/repositories/episode_repository.dart';
import 'package:dashboard/feature/movie/data/remote/model/comment.dart';
import 'package:dashboard/feature/season_episode/data/remote/model/episode.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class EpisodeRepositoryImpl extends EpisodeRepository {
  final EpisodeApiService _api;

  EpisodeRepositoryImpl({required EpisodeApiService api}) : _api = api;

  @override
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
  }) async {
    try {
      Response response = await _api.saveEpisode(
          seasonId: seasonId,
          time: time,
          number: number,
          video: video,
          releaseDate: releaseDate,
          trailer: trailer,
          thumbnail: thumbnail,
          poster: poster,
          thumbnailName: thumbnailName,
          posterName: posterName,
          casts: casts);
      if (response.statusCode == 201) {
        return const DataSuccess("OK");
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 400) {
          return const DataFailed('مقادیر را به درستی و کامل وارد کنید.');
        } else if (exception.response?.statusCode == 404) {
          return const DataFailed('صفحه مورد نظر یافت نشد.', code: 404);
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
  Future<DataResponse<Episode>> getEpisode(int id) async {
    try {
      Response response = await _api.getEpisode(id);
      if (response.statusCode == 200) {
        var data = Episode.fromJson(response.data);
        return DataSuccess(data);
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
  Future<DataResponse<String>> editEpisode(
      {required int id,
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
      String? name}) async {
    try {
      Response response = await _api.editEpisode(
          id: id,
          time: time,
          video: video,
          releaseDate: releaseDate,
          trailer: trailer,
          thumbnail: thumbnail,
          poster: poster,
          thumbnailName: thumbnailName,
          posterName: posterName,
          casts: casts,
          synopsis: synopsis,
          name: name);
      if (response.statusCode == 200) {
        return const DataSuccess("OK");
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 400) {
          return const DataFailed('مقادیر را به درستی و کامل وارد کنید.');
        } else if (exception.response?.statusCode == 404) {
          return const DataFailed('صفحه مورد نظر یافت نشد.', code: 404);
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
  Future<DataResponse<PageResponse<Comment>>> getComments(
      {required int episodeId, int page = 1}) async {
    try {
      Response response =
          await _api.getComments(page: page, episodeId: episodeId);
      if (response.statusCode == 200) {
        return DataSuccess(
            PageResponse.fromJson(response.data, (s) => Comment.fromJson(s)));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 404) {
          return const DataFailed('صفحه مورد نظر یافت نشد.', code: 404);
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
  Future<DataResponse<void>> changeCommentState(
      {required int commentId, required int state}) async {
    try {
      Response response =
          await _api.changeCommentState(commentId: commentId, state: state);
      if (response.statusCode == 200) {
        return const DataSuccess(null);
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 404) {
          return const DataFailed('صفحه مورد نظر یافت نشد.', code: 404);
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
