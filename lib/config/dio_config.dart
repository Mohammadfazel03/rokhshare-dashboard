import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/local_storage_service.dart';
import 'package:dio/dio.dart';

const baseUrl = "http://127.0.0.1:8000/";

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var accessToken = getIt.get<LocalStorageService>().getAccessToken();
    if (accessToken != null) {
      options.headers.addAll({"Authorization": "Bearer $accessToken"});
    }
    handler.next(options);
  }
}

Dio getDioConfiguration() {
  var options = BaseOptions(baseUrl: '${baseUrl}api/v1/');
  final dio = Dio(options);
  dio.interceptors.add(DioInterceptor());
  return dio;
}
