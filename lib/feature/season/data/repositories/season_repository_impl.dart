import 'dart:typed_data';

import 'package:dashboard/feature/season/data/remote/model/season.dart';
import 'package:dashboard/feature/season/data/remote/season_api_service.dart';
import 'package:dashboard/feature/season/data/repositories/season_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:dio/dio.dart';

class SeasonRepositoryImpl extends SeasonRepository {
  final SeasonApiService _api;

  SeasonRepositoryImpl({required SeasonApiService api}) : _api = api;

  @override
  Future<DataResponse<PageResponse<Season>>> getSeasons(
      {required int seriesId, int page = 1}) async {
    try {
      Response response = await _api.getSeasons(seriesId: seriesId, page: page);
      if (response.statusCode == 200) {
        return DataSuccess(
            PageResponse.fromJson(response.data, (s) => Season.fromJson(s)));
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
  Future<DataResponse<String>> saveSeason(
      {required int seriesId,
      required Uint8List poster,
      required Uint8List thumbnail,
      required int number,
      required String publicationDate,
      String? name}) async {
    try {
      Response response = await _api.saveSeasons(
          seriesId: seriesId,
          poster: poster,
          thumbnail: thumbnail,
          number: number,
          publicationDate: publicationDate,
          name: name);
      if (response.statusCode == 201) {
        return const DataSuccess("ok");
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 400) {
          return const DataFailed('مقادیر را به درستی و کامل وارد کنید.');
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
  Future<DataResponse<Season>> getSeason({required int id}) async {
    try {
      Response response = await _api.getSeason(id: id);
      if (response.statusCode == 200) {
        return DataSuccess(Season.fromJson(response.data));
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
  Future<DataResponse<String>> editSeason(
      {required int id,
      Uint8List? poster,
      Uint8List? thumbnail,
      int? number,
      String? publicationDate,
      String? name}) async {
    try {
      Response response = await _api.editSeasons(
          id: id,
          poster: poster,
          thumbnail: thumbnail,
          number: number,
          name: name,
          publicationDate: publicationDate);
      if (response.statusCode == 200) {
        return const DataSuccess("ok");
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 400) {
          return const DataFailed('مقادیر را به درستی و کامل وارد کنید.');
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
  Future<DataResponse<void>> deleteSeason({required int id}) async {
    try {
      Response response = await _api.deleteSeason(id: id);
      if (response.statusCode == 204) {
        return const DataSuccess(null);
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
