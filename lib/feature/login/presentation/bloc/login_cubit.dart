import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/login/data/remote/model/login_response.dart';
import 'package:dashboard/feature/login/data/repositories/login_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:flutter/material.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _loginRepository;

  LoginCubit({required LoginRepository loginRepository})
      : _loginRepository = loginRepository,
        super(LoginInitial());

  Future<void> login(String username, String password) async {
    emit(LoggingIn());
    DataResponse<LoginResponse> response =
        await _loginRepository.login(username, password);
    if (response is DataFailed) {
      emit(LoginFailed(error: response.error ?? "مشکلی پیش آمده است"));
    } else {
      emit(LoginSuccessfully(
          accessToken: response.data?.access ?? "",
          refreshToken: response.data?.refresh ?? ""));
    }
  }
}
