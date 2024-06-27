part of 'country_append_cubit.dart';

@immutable
sealed class CountryAppendState {}

final class CountryAppendInitial extends CountryAppendState {}

final class CountryAppendLoading extends CountryAppendState {}

final class CountryAppendSuccessAppend extends CountryAppendState {}

final class CountryAppendSuccessUpdate extends CountryAppendState {}

final class CountryAppendSuccess extends CountryAppendState {
  final Country country;

  CountryAppendSuccess({required this.country});
}

final class CountryAppendFailed extends CountryAppendState {
  final String message;
  final int? code;

  CountryAppendFailed({required this.message, this.code});
}
