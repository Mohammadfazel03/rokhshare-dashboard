import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/feature/404/presentation/screen/not_found_page.dart';
import 'package:dashboard/feature/dashboard/presentation/screen/dashboard_page.dart';
import 'package:dashboard/feature/episode/presentation/bloc/episode_page_cubit.dart';
import 'package:dashboard/feature/episode/presentation/screen/episode_page.dart';
import 'package:dashboard/feature/episode/presentation/widget/comment_table_widget/bloc/comment_table_cubit.dart'
    as episode_comment;
import 'package:dashboard/feature/home/presentation/screen/home_page.dart';
import 'package:dashboard/feature/login/presentation/bloc/login_cubit.dart';
import 'package:dashboard/feature/login/presentation/screen/login_page.dart';
import 'package:dashboard/feature/media/presentation/screen/media_page.dart';
import 'package:dashboard/feature/media/presentation/widget/movies_table/bloc/movies_table_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/series_table/bloc/series_table_cubit.dart';
import 'package:dashboard/feature/media_collection/presentation/bloc/media_collection_page_cubit.dart';
import 'package:dashboard/feature/media_collection/presentation/screen/media_collection_page.dart';
import 'package:dashboard/feature/media_collection/presentation/widget/media_autocomplete_field/bloc/media_autocomplete_field_cubit.dart';
import 'package:dashboard/feature/movie/presentation/bloc/movie_page_cubit.dart';
import 'package:dashboard/feature/movie/presentation/screen/movie_page.dart';
import 'package:dashboard/feature/movie/presentation/widget/artists_section_widget/bloc/artist_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/comment_table_widget/bloc/comment_table_cubit.dart'
    as movie_comment;
import 'package:dashboard/feature/movie/presentation/widget/country_multi_selector_widget/bloc/country_multi_selector_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/date_picker_section_widget/bloc/date_picker_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/gallery_table_widget/bloc/gallery_table_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/genre_section_widget/bloc/genre_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/movie_upload_section_widget/bloc/movie_upload_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/poster_section_widget/bloc/poster_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/synopsis_section_widget/bloc/synopsis_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/thumbnail_section_widget/bloc/thumbnail_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/title_section_widget/bloc/title_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/trailer_upload_section_widget/bloc/trailer_upload_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/value_section_widget/bloc/value_section_cubit.dart';
import 'package:dashboard/feature/season/presentation/bloc/season_page_cubit.dart';
import 'package:dashboard/feature/season/presentation/screen/season_page.dart';
import 'package:dashboard/feature/season/presentation/widget/integer_field_widget/bloc/integer_field_cubit.dart';
import 'package:dashboard/feature/season_episode/presentation/bloc/season_episode_page_cubit.dart';
import 'package:dashboard/feature/season_episode/presentation/screen/season_episode_page.dart';
import 'package:dashboard/feature/series/presentation/bloc/series_page_cubit.dart';
import 'package:dashboard/feature/series/presentation/screen/series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../feature/users/presentation/screen/user_page.dart';

enum RoutePath {
  dashboard(
      name: "dashboard",
      path: "/dashboard",
      fullPath: "/dashboard/",
      title: "داشبورد"),
  login(name: "login", path: "/login", fullPath: "/login", title: "ورود"),
  editMovie(
      name: "edit_movie",
      path: "movie/:movieId",
      fullPath: "/media/movie/{movieId}/",
      title: "ویرایش فیلم"),
  detailMovie(
      name: "detail_movie",
      path: "movie/:movieId/detail",
      fullPath: "/media/movie/{movieId}/detail/",
      title: "فیلم"),
  addMovie(
      name: "add_movie",
      path: "movie",
      fullPath: "/media/movie/",
      title: "افزودن فیلم"),
  addSeries(
      name: "add_series",
      path: "series",
      fullPath: "/media/series/",
      title: "افزودن سریال"),
  detailSeries(
      name: "detail_series",
      path: "series/:seriesId/detail",
      fullPath: "/media/series/{seriesId}/detail/",
      title: "سریال"),
  editSeries(
      name: "edit_series",
      path: "series/:seriesId",
      fullPath: "/media/series/{seriesId}/",
      title: "ویرایش سریال"),
  season(
      name: "season",
      path: "series/:seriesId/season",
      fullPath: "/media/series/{seriesId}/season/",
      title: "فصل ها"),
  seasonEpisode(
      name: "season_episode",
      path: ":seasonId",
      fullPath: "/media/series/{seriesId}/season/{seasonId}/",
      title: "قسمت ها"),
  addEpisode(
      name: "add_episode",
      path: "episode",
      fullPath: "/media/series/{seriesId}/season/{seasonId}/episode/",
      title: "افزودن قسمت"),
  editEpisode(
      name: "edit_episode",
      path: "episode/:episodeId",
      fullPath:
          "/media/series/{seriesId}/season/{seasonId}/episode/{episodeId}/",
      title: "ویرایش قسمت"),
  detailEpisode(
      name: "detail_episode",
      path: "episode/:episodeId/detail",
      fullPath:
          "/media/series/{seriesId}/season/{seasonId}/episode/{episodeId}/detail/",
      title: "قسمت"),
  collection(
      name: "collection",
      path: "collection/:collectionId",
      fullPath: "/media/collection/{collectionId}/",
      title: "مجموعه"),
  media(
      name: "media",
      path: "/media",
      fullPath: "/media/",
      title: "فیلم و سریال"),
  users(name: "users", path: "/users", fullPath: "/users/", title: "کاربران");

  const RoutePath(
      {required this.name,
      required this.path,
      required this.fullPath,
      this.title});

  final String name;
  final String path;
  final String fullPath;
  final String? title;
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerConfig = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePath.dashboard.path,
    errorBuilder: (BuildContext context, GoRouterState state) =>
        const NotFoundPage(),
    routes: [
      GoRoute(
          path: RoutePath.login.path,
          name: RoutePath.login.name,
          pageBuilder: (BuildContext context, GoRouterState state) {
            String? temp;
            if (state.extra != null && state.extra.runtimeType == String) {
              temp = state.extra as String;
            }
            return NoTransitionPage(
                child: BlocProvider<LoginCubit>(
                    create: (context) =>
                        LoginCubit(loginRepository: getIt.get()),
                    child: LoginPage(errorMessage: temp)));
          }),
      StatefulShellRoute.indexedStack(
          builder: (BuildContext context, GoRouterState state, child) {
            return HomePage(pageScreen: child);
          },
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(
                  path: RoutePath.dashboard.path,
                  name: RoutePath.dashboard.name,
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      const NoTransitionPage(child: DashboardPage()))
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: RoutePath.users.path,
                  name: RoutePath.users.name,
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      const NoTransitionPage(child: UserPage()))
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: RoutePath.media.path,
                  name: RoutePath.media.name,
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      const NoTransitionPage(child: MediaPage()),
                  routes: [
                    GoRoute(
                        path: RoutePath.detailMovie.path,
                        name: RoutePath.detailMovie.name,
                        pageBuilder:
                            (BuildContext context, GoRouterState state) {
                          int id = int.parse(state.pathParameters['movieId']!);
                          return NoTransitionPage(
                              child: MultiBlocProvider(providers: [
                            BlocProvider(
                                create: (context) => MovieUploadSectionCubit(
                                    repository: getIt.get())),
                            BlocProvider(
                                create: (context) =>
                                    movie_comment.CommentTableCubit(
                                        repository: getIt.get())),
                            BlocProvider.value(
                                value: state.extra as MoviesTableCubit),
                            BlocProvider(
                                create: (context) => TrailerUploadSectionCubit(
                                    repository: getIt.get())),
                            BlocProvider(
                                create: (context) => PosterSectionCubit()),
                            BlocProvider(
                                create: (context) => ThumbnailSectionCubit()),
                            BlocProvider(
                                create: (context) => DatePickerSectionCubit()),
                            BlocProvider(
                                create: (context) => SynopsisSectionCubit()),
                            BlocProvider(
                                create: (context) => TitleSectionCubit()),
                            BlocProvider(
                                create: (context) => ValueSectionCubit()),
                            BlocProvider(
                                create: (context) => CountryMultiSelectorCubit(
                                    repository: getIt.get())),
                            BlocProvider(
                                create: (context) =>
                                    GenreSectionCubit(repository: getIt.get())),
                            BlocProvider(
                                create: (context) => ArtistSectionCubit()),
                            BlocProvider(
                                create: (context) =>
                                    GalleryTableCubit(repository: getIt.get())),
                            BlocProvider(
                                create: (context) =>
                                    MoviePageCubit(repository: getIt.get())),
                          ], child: MoviePage(movieId: id, isDetail: true)));
                        }),
                    GoRoute(
                        path: RoutePath.editMovie.path,
                        name: RoutePath.editMovie.name,
                        pageBuilder:
                            (BuildContext context, GoRouterState state) {
                          int id = int.parse(state.pathParameters['movieId']!);
                          return NoTransitionPage(
                              child: MultiBlocProvider(providers: [
                            BlocProvider(
                                create: (context) => MovieUploadSectionCubit(
                                    repository: getIt.get())),
                            BlocProvider.value(
                                value: state.extra as MoviesTableCubit),
                            BlocProvider(
                                create: (context) => TrailerUploadSectionCubit(
                                    repository: getIt.get())),
                            BlocProvider(
                                create: (context) => PosterSectionCubit()),
                            BlocProvider(
                                create: (context) => ThumbnailSectionCubit()),
                            BlocProvider(
                                create: (context) => DatePickerSectionCubit()),
                            BlocProvider(
                                create: (context) => SynopsisSectionCubit()),
                            BlocProvider(
                                create: (context) => TitleSectionCubit()),
                            BlocProvider(
                                create: (context) => ValueSectionCubit()),
                            BlocProvider(
                                create: (context) => CountryMultiSelectorCubit(
                                    repository: getIt.get())),
                            BlocProvider(
                                create: (context) =>
                                    GenreSectionCubit(repository: getIt.get())),
                            BlocProvider(
                                create: (context) => ArtistSectionCubit()),
                            BlocProvider(
                                create: (context) =>
                                    MoviePageCubit(repository: getIt.get())),
                          ], child: MoviePage(movieId: id, isDetail: false)));
                        }),
                    GoRoute(
                        path: RoutePath.addMovie.path,
                        name: RoutePath.addMovie.name,
                        pageBuilder: (BuildContext context,
                                GoRouterState state) =>
                            NoTransitionPage(
                                child: MultiBlocProvider(providers: [
                              BlocProvider(
                                  create: (context) => MovieUploadSectionCubit(
                                      repository: getIt.get())),
                              BlocProvider.value(
                                  value: state.extra as MoviesTableCubit),
                              BlocProvider(
                                  create: (context) =>
                                      TrailerUploadSectionCubit(
                                          repository: getIt.get())),
                              BlocProvider(
                                  create: (context) => PosterSectionCubit()),
                              BlocProvider(
                                  create: (context) => ThumbnailSectionCubit()),
                              BlocProvider(
                                  create: (context) =>
                                      DatePickerSectionCubit()),
                              BlocProvider(
                                  create: (context) => SynopsisSectionCubit()),
                              BlocProvider(
                                  create: (context) => TitleSectionCubit()),
                              BlocProvider(
                                  create: (context) => ValueSectionCubit()),
                              BlocProvider(
                                  create: (context) =>
                                      CountryMultiSelectorCubit(
                                          repository: getIt.get())),
                              BlocProvider(
                                  create: (context) => GenreSectionCubit(
                                      repository: getIt.get())),
                              BlocProvider(
                                  create: (context) => ArtistSectionCubit()),
                              BlocProvider(
                                  create: (context) =>
                                      MoviePageCubit(repository: getIt.get())),
                            ], child: const MoviePage(isDetail: false)))),
                    GoRoute(
                        path: RoutePath.addSeries.path,
                        name: RoutePath.addSeries.name,
                        pageBuilder: (BuildContext context,
                                GoRouterState state) =>
                            NoTransitionPage(
                                child: MultiBlocProvider(providers: [
                              BlocProvider(
                                  create: (context) =>
                                      TrailerUploadSectionCubit(
                                          repository: getIt.get())),
                              BlocProvider.value(
                                  value: state.extra as SeriesTableCubit),
                              BlocProvider(
                                  create: (context) => PosterSectionCubit()),
                              BlocProvider(
                                  create: (context) => ThumbnailSectionCubit()),
                              BlocProvider(
                                  create: (context) =>
                                      DatePickerSectionCubit()),
                              BlocProvider(
                                  create: (context) => SynopsisSectionCubit()),
                              BlocProvider(
                                  create: (context) => TitleSectionCubit()),
                              BlocProvider(
                                  create: (context) => ValueSectionCubit()),
                              BlocProvider(
                                  create: (context) =>
                                      CountryMultiSelectorCubit(
                                          repository: getIt.get())),
                              BlocProvider(
                                  create: (context) => GenreSectionCubit(
                                      repository: getIt.get())),
                              BlocProvider(
                                  create: (context) =>
                                      SeriesPageCubit(repository: getIt.get())),
                            ], child: const SeriesPage(isDetail: false)))),
                    GoRoute(
                        path: RoutePath.editSeries.path,
                        name: RoutePath.editSeries.name,
                        pageBuilder:
                            (BuildContext context, GoRouterState state) {
                          int id = int.parse(state.pathParameters['seriesId']!);
                          return NoTransitionPage(
                              child: MultiBlocProvider(providers: [
                            BlocProvider(
                                create: (context) => TrailerUploadSectionCubit(
                                    repository: getIt.get())),
                            BlocProvider.value(
                                value: state.extra as SeriesTableCubit),
                            BlocProvider(
                                create: (context) => PosterSectionCubit()),
                            BlocProvider(
                                create: (context) => ThumbnailSectionCubit()),
                            BlocProvider(
                                create: (context) => DatePickerSectionCubit()),
                            BlocProvider(
                                create: (context) => SynopsisSectionCubit()),
                            BlocProvider(
                                create: (context) => TitleSectionCubit()),
                            BlocProvider(
                                create: (context) => ValueSectionCubit()),
                            BlocProvider(
                                create: (context) => CountryMultiSelectorCubit(
                                    repository: getIt.get())),
                            BlocProvider(
                                create: (context) =>
                                    GenreSectionCubit(repository: getIt.get())),
                            BlocProvider(
                                create: (context) =>
                                    SeriesPageCubit(repository: getIt.get())),
                          ], child: SeriesPage(isDetail: false, seriesId: id)));
                        }),
                    GoRoute(
                        path: RoutePath.detailSeries.path,
                        name: RoutePath.detailSeries.name,
                        pageBuilder:
                            (BuildContext context, GoRouterState state) {
                          int id = int.parse(state.pathParameters['seriesId']!);
                          return NoTransitionPage(
                              child: MultiBlocProvider(providers: [
                            BlocProvider(
                                create: (context) =>
                                    movie_comment.CommentTableCubit(
                                        repository: getIt.get())),
                            BlocProvider(
                                create: (context) => TrailerUploadSectionCubit(
                                    repository: getIt.get())),
                            BlocProvider.value(
                                value: state.extra as SeriesTableCubit),
                            BlocProvider(
                                create: (context) => PosterSectionCubit()),
                            BlocProvider(
                                create: (context) => ThumbnailSectionCubit()),
                            BlocProvider(
                                create: (context) => DatePickerSectionCubit()),
                            BlocProvider(
                                create: (context) => SynopsisSectionCubit()),
                            BlocProvider(
                                create: (context) => TitleSectionCubit()),
                            BlocProvider(
                                create: (context) => ValueSectionCubit()),
                            BlocProvider(
                                create: (context) => CountryMultiSelectorCubit(
                                    repository: getIt.get())),
                            BlocProvider(
                                create: (context) =>
                                    GenreSectionCubit(repository: getIt.get())),
                            BlocProvider(
                                create: (context) =>
                                    GalleryTableCubit(repository: getIt.get())),
                            BlocProvider(
                                create: (context) =>
                                    SeriesPageCubit(repository: getIt.get())),
                          ], child: SeriesPage(isDetail: true, seriesId: id)));
                        }),
                    GoRoute(
                        path: RoutePath.season.path,
                        name: RoutePath.season.name,
                        pageBuilder:
                            (BuildContext context, GoRouterState state) {
                          int id = int.parse(state.pathParameters['seriesId']!);
                          return NoTransitionPage(
                              child: BlocProvider(
                                  create: (context) =>
                                      SeasonPageCubit(repository: getIt.get()),
                                  child: SeasonPage(seriesId: id)));
                        },
                        routes: [
                          GoRoute(
                              path: RoutePath.seasonEpisode.path,
                              name: RoutePath.seasonEpisode.name,
                              pageBuilder:
                                  (BuildContext context, GoRouterState state) {
                                int seasonId = int.parse(
                                    state.pathParameters['seasonId']!);
                                int seriesId = int.parse(
                                    state.pathParameters['seriesId']!);
                                return NoTransitionPage(
                                    child: BlocProvider(
                                        create: (context) =>
                                            SeasonEpisodePageCubit(
                                                repository: getIt.get()),
                                        child: SeasonEpisodePage(
                                            seasonId: seasonId,
                                            seriesId: seriesId)));
                              },
                              routes: [
                                GoRoute(
                                    path: RoutePath.addEpisode.path,
                                    name: RoutePath.addEpisode.name,
                                    pageBuilder: (BuildContext context,
                                        GoRouterState state) {
                                      int seasonId = int.parse(
                                          state.pathParameters['seasonId']!);
                                      return NoTransitionPage(
                                          child: MultiBlocProvider(
                                              providers: [
                                            BlocProvider(
                                                create: (context) =>
                                                    MovieUploadSectionCubit(
                                                        repository:
                                                            getIt.get())),
                                            BlocProvider.value(
                                                value: state.extra
                                                    as SeasonEpisodePageCubit),
                                            BlocProvider(
                                                create: (context) =>
                                                    TrailerUploadSectionCubit(
                                                        repository:
                                                            getIt.get())),
                                            BlocProvider(
                                                create: (context) =>
                                                    IntegerFieldCubit()),
                                            BlocProvider(
                                                create: (context) =>
                                                    PosterSectionCubit()),
                                            BlocProvider(
                                                create: (context) =>
                                                    ThumbnailSectionCubit()),
                                            BlocProvider(
                                                create: (context) =>
                                                    DatePickerSectionCubit()),
                                            BlocProvider(
                                                create: (context) =>
                                                    SynopsisSectionCubit()),
                                            BlocProvider(
                                                create: (context) =>
                                                    TitleSectionCubit()),
                                            BlocProvider(
                                                create: (context) =>
                                                    ArtistSectionCubit()),
                                            BlocProvider(
                                                create: (context) =>
                                                    EpisodePageCubit(
                                                        repository:
                                                            getIt.get())),
                                          ],
                                              child: EpisodePage(
                                                  seasonId: seasonId)));
                                    }),
                                GoRoute(
                                    path: RoutePath.editEpisode.path,
                                    name: RoutePath.editEpisode.name,
                                    pageBuilder: (BuildContext context,
                                        GoRouterState state) {
                                      int seasonId = int.parse(
                                          state.pathParameters['seasonId']!);
                                      int episodeId = int.parse(
                                          state.pathParameters['episodeId']!);
                                      return NoTransitionPage(
                                          child: MultiBlocProvider(
                                              providers: [
                                            BlocProvider(
                                                create: (context) =>
                                                    MovieUploadSectionCubit(
                                                        repository:
                                                            getIt.get())),
                                            BlocProvider.value(
                                                value: state.extra
                                                    as SeasonEpisodePageCubit),
                                            BlocProvider(
                                                create: (context) =>
                                                    TrailerUploadSectionCubit(
                                                        repository:
                                                            getIt.get())),
                                            BlocProvider(
                                                create: (context) =>
                                                    IntegerFieldCubit()),
                                            BlocProvider(
                                                create: (context) =>
                                                    PosterSectionCubit()),
                                            BlocProvider(
                                                create: (context) =>
                                                    ThumbnailSectionCubit()),
                                            BlocProvider(
                                                create: (context) =>
                                                    DatePickerSectionCubit()),
                                            BlocProvider(
                                                create: (context) =>
                                                    SynopsisSectionCubit()),
                                            BlocProvider(
                                                create: (context) =>
                                                    TitleSectionCubit()),
                                            BlocProvider(
                                                create: (context) =>
                                                    ArtistSectionCubit()),
                                            BlocProvider(
                                                create: (context) =>
                                                    EpisodePageCubit(
                                                        repository:
                                                            getIt.get())),
                                          ],
                                              child: EpisodePage(
                                                  seasonId: seasonId,
                                                  episodeId: episodeId)));
                                    }),
                                GoRoute(
                                    path: RoutePath.detailEpisode.path,
                                    name: RoutePath.detailEpisode.name,
                                    pageBuilder: (BuildContext context,
                                        GoRouterState state) {
                                      int seasonId = int.parse(
                                          state.pathParameters['seasonId']!);
                                      int episodeId = int.parse(
                                          state.pathParameters['episodeId']!);
                                      return NoTransitionPage(
                                          child: MultiBlocProvider(
                                              providers: [
                                            BlocProvider(
                                                create: (context) =>
                                                    MovieUploadSectionCubit(
                                                        repository:
                                                            getIt.get())),
                                            BlocProvider(
                                                create: (context) =>
                                                    episode_comment
                                                        .CommentTableCubit(
                                                            repository:
                                                                getIt.get())),
                                            BlocProvider.value(
                                                value: state.extra
                                                    as SeasonEpisodePageCubit),
                                            BlocProvider(
                                                create: (context) =>
                                                    TrailerUploadSectionCubit(
                                                        repository:
                                                            getIt.get())),
                                            BlocProvider(
                                                create: (context) =>
                                                    IntegerFieldCubit()),
                                            BlocProvider(
                                                create: (context) =>
                                                    PosterSectionCubit()),
                                            BlocProvider(
                                                create: (context) =>
                                                    ThumbnailSectionCubit()),
                                            BlocProvider(
                                                create: (context) =>
                                                    DatePickerSectionCubit()),
                                            BlocProvider(
                                                create: (context) =>
                                                    SynopsisSectionCubit()),
                                            BlocProvider(
                                                create: (context) =>
                                                    TitleSectionCubit()),
                                            BlocProvider(
                                                create: (context) =>
                                                    ArtistSectionCubit()),
                                            BlocProvider(
                                                create: (context) =>
                                                    GalleryTableCubit(
                                                        repository:
                                                            getIt.get())),
                                            BlocProvider(
                                                create: (context) =>
                                                    EpisodePageCubit(
                                                        repository:
                                                            getIt.get())),
                                          ],
                                              child: EpisodePage(
                                                seasonId: seasonId,
                                                episodeId: episodeId,
                                                isDetail: true,
                                              )));
                                    }),
                              ])
                        ]),
                    GoRoute(
                        path: RoutePath.collection.path,
                        name: RoutePath.collection.name,
                        pageBuilder:
                            (BuildContext context, GoRouterState state) {
                          int id =
                              int.parse(state.pathParameters['collectionId']!);
                          return NoTransitionPage(
                              child: MultiBlocProvider(providers: [
                            BlocProvider(
                                create: (context) => MediaCollectionPageCubit(
                                    repository: getIt.get())),
                            BlocProvider(
                                create: (_) => MediaAutocompleteFieldCubit(
                                    repository: getIt.get()))
                          ], child: MediaCollectionPage(collectionId: id)));
                        }),
                  ])
            ]),
          ])
    ],
    redirect: (BuildContext context, GoRouterState state) async {
      try {
        if (await getIt.get<LocalStorageService>().getAccessToken() == null) {
          return RoutePath.login.path;
        }
        if (state.uri.path == RoutePath.login.path) {
          return RoutePath.dashboard.path;
        }

        return null;
      } catch (e) {
        return '/none';
      }
    },
    debugLogDiagnostics: false);
