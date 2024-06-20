import 'package:dashboard/feature/dashboard/data/remote/dashboard_api_service.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/header_information.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/user.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dio/dio.dart';

import 'dashboard_repository.dart';

class DashboardRepositoryImpl extends DashboardRepository {
  final DashboardApiService _api;

  DashboardRepositoryImpl({required DashboardApiService apiService})
      : _api = apiService;

  @override
  Future<DataResponse<HeaderInformation>> getHeaderInformation() async {
    try {
      Response response = await _api.getHeaderInformation();
      if (response.statusCode == 200) {
        return DataSuccess(HeaderInformation.fromJson(response.data));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
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
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    }
  }

  @override
  Future<DataResponse<List<User>>> getRecentlyUser() async {
    try {
      Response response = await _api.getRecentlyUser();
      if (response.statusCode == 200) {
        List<User> users =
            ((response.data) as List).map((e) => User.fromJson(e)).toList();
        return DataSuccess(users);
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
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
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    }
  }
}
