import 'dart:io';

import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/config/router_config.dart';
import 'package:dio/dio.dart';

const baseUrl = "http://127.0.0.1:8000/";

class DioInterceptor extends Interceptor {
  final Dio _dio;

  DioInterceptor({required Dio dio}) : _dio = dio;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var accessToken = await getIt.get<LocalStorageService>().getAccessToken();
    if (accessToken != null) {
      options.headers.addAll({"Authorization": "Bearer $accessToken"});
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.shouldLogout) {
      await getIt.get<LocalStorageService>().logout();
      routerConfig.go(RoutePath.login.fullPath,
          extra: "این نشست غیر فعال شده است. لطفا دوباره وارد شوید.");
      return;
    }
    if (!err.shouldRetry || err.requestOptions.isRetriedAttempt) {
      handler.next(err);
      return;
    }
    if (await refreshToken()) {
      try {
        final options = err.requestOptions;
        final data = options.data;
        final newOptions = options.retryWith(
          data: data is FormData ? data.clone() : data,
        );
        final response = await _dio.fetch(newOptions);
        handler.resolve(response);
      } on DioException catch (e) {
        handler.next(e);
      }
    } else {
      handler.next(err);
    }
  }

  Future<bool> refreshToken() async {
    try {
      var response = await _dio.post("auth/refresh/", data: {
        "refresh": await getIt.get<LocalStorageService>().getRefreshToken()
      });
      if (response.statusCode == 200) {
        await getIt
            .get<LocalStorageService>()
            .updateAccessToken(response.data['access']);
        return true;
      }
    } catch (e) {
      await getIt.get<LocalStorageService>().logout();
      routerConfig.go(RoutePath.login.fullPath,
          extra: "این نشست غیر فعال شده است. لطفا دوباره وارد شوید.");
    }
    return false;
  }
}

const _retryExtraTag = 'isRetry';

extension on RequestOptions {
  RequestOptions retryWith({
    Object? data,
  }) {
    return copyWith(
      extra: {
        _retryExtraTag: true,
        ...extra,
      },
      data: data ?? this.data,
    );
  }

  bool get isRetriedAttempt => extra[_retryExtraTag] == true;
}

extension on DioException {
  bool get shouldRetry =>
      response?.statusCode == HttpStatus.forbidden &&
      response?.data['code'] == 'token_not_valid';

  bool get shouldLogout =>
      response?.statusCode == HttpStatus.forbidden &&
      response?.data['code'] == 'user_not_found';
}

Dio getDioConfiguration() {
  var options = BaseOptions(baseUrl: '${baseUrl}api/v1/');
  final dio = Dio(options);
  dio.interceptors.add(DioInterceptor(dio: dio));
  return dio;
}
