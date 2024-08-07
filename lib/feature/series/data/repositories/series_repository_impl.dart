import 'dart:typed_data';

import 'package:dashboard/feature/series/data/remote/series_api_service.dart';
import 'package:dashboard/feature/series/data/repositories/series_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dio/dio.dart';

class SeriesRepositoryImpl extends SeriesRepository {
  final SeriesApiService _api;

  SeriesRepositoryImpl({required SeriesApiService api}) : _api = api;

  @override
  Future<DataResponse<String>> saveSeries(
      {required List<int> genres,
      required List<int> countries,
      required String releaseDate,
      required Uint8List thumbnail,
      required Uint8List poster,
      required String thumbnailName,
      required String posterName,
      required String synopsis,
      required String name,
      required int trailer,
      required String value}) async {
    try {
      Response response = await _api.saveSeries(
          genres: genres,
          countries: countries,
          releaseDate: releaseDate,
          thumbnail: thumbnail,
          poster: poster,
          thumbnailName: thumbnailName,
          posterName: posterName,
          synopsis: synopsis,
          name: name,
          trailer: trailer,
          value: value);
      if (response.statusCode == 201) {
        return const DataSuccess("OK");
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        print(e.response?.data);
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
}
