part of 'season_page_cubit.dart';

@immutable
sealed class SeasonPageState {}

final class SeasonPageInitial extends SeasonPageState {}

final class SeasonPageLoading extends SeasonPageState {
  final int code;

  SeasonPageLoading({this.code = 1});
}

final class SeasonPageError extends SeasonPageState {
  final String error;
  final int? code;
  final String? title;

  SeasonPageError({required this.error, this.title, this.code});
}

final class SeasonPageSuccess extends SeasonPageState {
  final PageResponse<Season> data;

  SeasonPageSuccess({required this.data});
}

final class SeasonPageRefresh extends SeasonPageState {}
