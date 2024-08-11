part of 'season_append_cubit.dart';

@immutable
sealed class SeasonAppendState {}

final class SeasonAppendInitial extends SeasonAppendState {}

final class SeasonAppendLoading extends SeasonAppendState {}

final class SeasonAppendSuccessAppend extends SeasonAppendState {}

final class SeasonAppendSuccessUpdate extends SeasonAppendState {}

final class SeasonAppendSuccess extends SeasonAppendState {
  final Season season;

  SeasonAppendSuccess({required this.season});
}

final class SeasonAppendFailed extends SeasonAppendState {
  final String message;
  final int? code;

  SeasonAppendFailed({required this.message, this.code});
}
