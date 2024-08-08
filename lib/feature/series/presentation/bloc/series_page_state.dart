part of 'series_page_cubit.dart';

@immutable
sealed class SeriesPageState {}

final class SeriesPageInitial extends SeriesPageState {}

final class SeriesPageLoading extends SeriesPageState {}

final class SeriesPageSuccess extends SeriesPageState {
  final Series data;

  SeriesPageSuccess({required this.data});
}

final class SeriesPageSuccessAppend extends SeriesPageState {}

final class SeriesPageSuccessUpdate extends SeriesPageState {}

final class SeriesPageFail extends SeriesPageState {
  final String message;
  final int? code;

  SeriesPageFail({required this.message, this.code});
}

final class SeriesPageFailAppend extends SeriesPageState {
  final String message;
  final int? code;

  SeriesPageFailAppend({required this.message, this.code});
}
