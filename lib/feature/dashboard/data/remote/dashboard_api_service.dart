import 'package:dio/dio.dart';

class DashboardApiService {
  final Dio _dio;

  DashboardApiService({required Dio dio}) : _dio = dio;

  Future<dynamic> getHeaderInformation() async {
    return await _dio.get("dashboard/header/");
  }

  Future<dynamic> getRecentlyUser({int page = 1}) async {
    return await _dio.get("user/", queryParameters: {"page": page});
  }

  Future<dynamic> getPopularPlan() async {
    return await _dio.get("dashboard/popular_plan/");
  }

  Future<dynamic> getRecentlyComment() async {
    return await _dio.get("dashboard/recently_comment/");
  }

  Future<dynamic> getSlider() async {
    return await _dio.get("dashboard/slider/");
  }

  Future<dynamic> getAdvertise() async {
    return await _dio.get("dashboard/advertise/");
  }
}
