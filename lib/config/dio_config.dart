import 'package:dio/dio.dart';

const baseUrl = "http://127.0.0.1:8000/";

Dio getDioConfiguration() {
  var options = BaseOptions(
      baseUrl: '${baseUrl}api/v1/');
  return Dio(options);
}
