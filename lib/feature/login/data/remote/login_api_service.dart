import 'package:dio/dio.dart';

class LoginApiService {
  final Dio _dio;

  LoginApiService({required Dio dio}) : _dio = dio;

  Future<dynamic> login(String username, String password) async {
    return await _dio.post("auth/login/admin/",
        data: FormData.fromMap({"username": username, "password": password}));
  }
}
