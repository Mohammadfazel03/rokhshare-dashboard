import 'package:dio/dio.dart';

class DashboardApiService {
  final Dio _dio;
  final String _accessToken;

  DashboardApiService({required Dio dio, required String accessToken})
      : _dio = dio,
        _accessToken = accessToken;

  Future<dynamic> getHeaderInformation() async {
    return await _dio.get("dashboard/header/",
        options: Options(headers: {
          "Authorization":
              "Bearer $_accessToken"
        }));
  }

  Future<dynamic> getRecentlyUser() async {
    return await _dio.get("dashboard/recently_user/",
        options: Options(headers: {
          "Authorization":
              "Bearer $_accessToken"
        }));
  }

  Future<dynamic> getPopularPlan() async {
    return await _dio.get("dashboard/popular_plan/",
        options: Options(headers: {
          "Authorization":
              "Bearer $_accessToken"
        }));
  }

  Future<dynamic> getRecentlyComment() async {
    return await _dio.get("dashboard/recently_comment/",
        options: Options(headers: {
          "Authorization":
              "Bearer $_accessToken"
        }));
  }

  Future<dynamic> getSlider() async {
    return await _dio.get("dashboard/slider/",
        options: Options(headers: {
          "Authorization":
              "Bearer $_accessToken"
        }));
  }

  Future<dynamic> getAdvertise() async {
    return await _dio.get("dashboard/advertise/",
        options: Options(headers: {
          "Authorization":
              "Bearer $_accessToken"
        }));
  }
}
