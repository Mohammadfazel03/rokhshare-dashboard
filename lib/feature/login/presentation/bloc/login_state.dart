part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoggingIn extends LoginState {}

final class LoginFailed extends LoginState {
  final String error;

  LoginFailed({required this.error});
}

final class LoginSuccessfully extends LoginState {
  final String accessToken;
  final String refreshToken;

  LoginSuccessfully({required this.accessToken, required this.refreshToken});
}
