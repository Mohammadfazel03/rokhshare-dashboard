part of 'first_screen_slider_cubit.dart';

@immutable
sealed class FirstScreenSliderState {}

final class FirstScreenSliderLoading extends FirstScreenSliderState {}

final class FirstScreenSliderError extends FirstScreenSliderState {
  final String error;
  final int? code;

  FirstScreenSliderError({required this.error, this.code});

}

final class FirstScreenSliderSuccessful extends FirstScreenSliderState {
  final List<SliderModel> data;

  FirstScreenSliderSuccessful({required this.data});
}
