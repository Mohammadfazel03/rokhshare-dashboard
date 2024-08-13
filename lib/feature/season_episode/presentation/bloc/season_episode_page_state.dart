part of 'season_episode_page_cubit.dart';

@immutable
sealed class SeasonEpisodePageState {
  final int numberPages;
  final int pageIndex;

  const SeasonEpisodePageState(
      {required this.numberPages, required this.pageIndex});
}

final class SeasonEpisodePageLoading extends SeasonEpisodePageState {
  const SeasonEpisodePageLoading({int numberPages = 0, int pageIndex = 0})
      : super(numberPages: numberPages, pageIndex: pageIndex);
}

final class SeasonEpisodePageError extends SeasonEpisodePageState {
  final String error;
  final String? title;
  final int? code;

  const SeasonEpisodePageError(
      {required this.error,
      this.title,
      this.code,
      int numberPages = 0,
      int pageIndex = 0})
      : super(numberPages: numberPages, pageIndex: pageIndex);
}

final class SeasonEpisodePageSuccess extends SeasonEpisodePageState {
  final PageResponse<Episode> data;

  const SeasonEpisodePageSuccess(
      {required this.data, int pageIndex = 0, int numberPages = 0})
      : super(numberPages: numberPages, pageIndex: pageIndex);
}
