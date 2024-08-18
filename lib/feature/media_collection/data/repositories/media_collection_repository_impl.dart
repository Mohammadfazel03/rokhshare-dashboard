import 'package:dashboard/feature/media_collection/data/remote/media_collection_api_service.dart';
import 'package:dashboard/feature/media_collection/data/repositories/media_collection_repository.dart';
import 'package:dashboard/feature/movie/data/remote/model/movie.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:dio/dio.dart';

class MediaCollectionRepositoryImpl extends MediaCollectionRepository {
  final MediaCollectionApiService _api;

  MediaCollectionRepositoryImpl({required MediaCollectionApiService api})
      : _api = api;

  @override
  Future<DataResponse<void>> addMedia(
      {required int mediaId, required int collectionId}) async {
    try {
      Response response =
          await _api.addMedia(mediaId: [mediaId], collectionId: collectionId);
      if (response.statusCode == 200) {
        return const DataSuccess(null);
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 400) {
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
  Future<DataResponse<PageResponse<Media>>> getMediaOfCollection(
      {required int collectionId, int page = 1}) async {
    try {
      Response response = await _api.getMediaOfCollection(
          collectionId: collectionId, page: page);
      if (response.statusCode == 200) {
        return DataSuccess(
            PageResponse.fromJson(response.data, (s) => Media.fromJson(s)));
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
  Future<DataResponse<PageResponse<Media>>> searchMedia(
      {required String query, int page = 1}) async {
    try {
      Response response = await _api.searchMedia(query: query, page: page);
      if (response.statusCode == 200) {
        return DataSuccess(
            PageResponse.fromJson(response.data, (s) => Media.fromJson(s)));
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
  Future<DataResponse<void>> removeMedia(
      {required int mediaId, required int collectionId}) async {
    try {
      Response response = await _api
          .removeMedia(mediaId: [mediaId], collectionId: collectionId);
      if (response.statusCode == 200) {
        return const DataSuccess(null);
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 400) {
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
}
