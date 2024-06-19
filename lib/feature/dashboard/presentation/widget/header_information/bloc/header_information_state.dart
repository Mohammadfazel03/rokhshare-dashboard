part of 'header_information_bloc.dart';

@immutable
sealed class HeaderInformationState {}

final class HeaderInformationLoading extends HeaderInformationState {}

final class HeaderInformationError extends HeaderInformationState {
  final String error;
  final int? code;

  HeaderInformationError({required this.error, this.code});
}

final class HeaderInformationSuccess extends HeaderInformationState {
  final HeaderInformation data;

  HeaderInformationSuccess({required this.data});
}