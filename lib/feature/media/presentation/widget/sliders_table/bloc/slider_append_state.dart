part of 'slider_append_cubit.dart';

@immutable
sealed class SliderAppendState {}

final class SliderAppendInitial extends SliderAppendState {}

final class SliderAppendLoading extends SliderAppendState {}

final class SliderAppendSuccessAppend extends SliderAppendState {}

final class SliderAppendSuccessUpdate extends SliderAppendState {}

final class SliderAppendSuccess extends SliderAppendState {
  final SliderModel slider;

  SliderAppendSuccess({required this.slider});
}

final class SliderAppendFailed extends SliderAppendState {
  final String message;
  final int? code;

  SliderAppendFailed({required this.message, this.code});
}
