import 'package:dio/dio.dart';

Dio getDioConfiguration() {
  var options = BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api/v1/');
  return Dio(options);
}
