import 'package:dashboard/feature/media/data/remote/media_api_service.dart';
import 'package:dashboard/feature/media/data/remote/model/movie.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:dio/dio.dart';

class MediaRepositoryImpl extends MediaRepository {
  final MediaApiService _api;

  MediaRepositoryImpl({required MediaApiService apiService})
      : _api = apiService;

  @override
  Future<DataResponse<PageResponse<Movie>>> getMovies() async {
    try {
      Response response = await _api.getMovies();
      if (response.statusCode == 200) {
        return DataSuccess(
            PageResponse.fromJson(response.data, (s) => Movie.fromJson(s)));
      }
      return const DataFailed('در برقرای ارتباط مشک999لی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        }
        int cat = ((exception.response?.statusCode ?? 0) / 100).round();
        if (cat == 5) {
          return const DataFailed('سایت در حال تعمیر است بعداً تلاش کنید.');
        }
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آ5555مده است.');
    }
  }
}
