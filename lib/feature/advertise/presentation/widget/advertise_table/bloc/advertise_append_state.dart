part of 'advertise_append_cubit.dart';

@immutable
sealed class AdvertiseAppendState {}

final class AdvertiseAppendInitial extends AdvertiseAppendState {}

final class AdvertiseAppendLoading extends AdvertiseAppendState {}

final class AdvertiseAppendSuccessAppend extends AdvertiseAppendState {}

final class AdvertiseAppendSuccessUpdate extends AdvertiseAppendState {}

final class AdvertiseAppendSuccess extends AdvertiseAppendState {
  final Advertise advertise;

  AdvertiseAppendSuccess({required this.advertise});
}

final class AdvertiseAppendFailed extends AdvertiseAppendState {
  final String message;
  final int? code;

  AdvertiseAppendFailed({required this.message, this.code});
}
