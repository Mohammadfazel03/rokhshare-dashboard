part of 'episode_page_cubit.dart';

@immutable
sealed class EpisodePageState {}

final class EpisodePageInitial extends EpisodePageState {}

final class EpisodePageLoading extends EpisodePageState {}

final class EpisodePageSuccess extends EpisodePageState {
  final Episode data;

  EpisodePageSuccess({required this.data});
}

final class EpisodePageSuccessAppend extends EpisodePageState {}

final class EpisodePageSuccessUpdate extends EpisodePageState {}

final class EpisodePageFail extends EpisodePageState {
  final String message;
  final int? code;

  EpisodePageFail({required this.message, this.code});
}

final class EpisodePageFailAppend extends EpisodePageState {
  final String message;
  final int? code;

  EpisodePageFailAppend({required this.message, this.code});
}
