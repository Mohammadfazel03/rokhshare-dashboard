import 'package:dashboard/feature/login/data/remote/login_api_service.dart';
import 'package:dashboard/feature/login/data/remote/model/login_response.dart';
import 'package:dashboard/feature/login/data/repositories/login_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dio/dio.dart';

class LoginRepositoryImpl extends LoginRepository {

  final LoginApiService _api;

  LoginRepositoryImpl({required LoginApiService apiService}) : _api = apiService;

  @override
  Future<DataResponse<LoginResponse>> login(String username, String password) async {
    try {
      Response response = await _api.login(username, password);
      if (response.statusCode == 200) {
        return DataSuccess(LoginResponse.fromJson(response.data));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed('نام کاربری یا رمز عبور صجیج نمی یاشد.');
        }
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    }
  }
}