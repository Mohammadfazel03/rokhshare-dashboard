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
}
