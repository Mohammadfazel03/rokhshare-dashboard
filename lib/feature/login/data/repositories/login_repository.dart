import 'dart:async';

import 'package:dashboard/utils/data_response.dart';

import '../remote/model/login_response.dart';

abstract class LoginRepository {

  Future<DataResponse<LoginResponse>> login(String username, String password);
}