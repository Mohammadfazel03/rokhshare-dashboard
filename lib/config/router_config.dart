import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/feature/404/presentation/screen/not_found_page.dart';
import 'package:dashboard/feature/dashboard/presentation/screen/dashboard_page.dart';
import 'package:dashboard/feature/home/presentation/screen/home_page.dart';
import 'package:dashboard/feature/login/presentation/bloc/login_cubit.dart';
import 'package:dashboard/feature/login/presentation/screen/login_page.dart';
import 'package:dashboard/feature/media/presentation/screen/media_page.dart';
import 'package:dashboard/feature/media/presentation/widget/movies_table/bloc/movies_table_cubit.dart';
import 'package:dashboard/feature/movie/presentation/bloc/movie_page_cubit.dart';
import 'package:dashboard/feature/movie/presentation/screen/movie_page.dart';
import 'package:dashboard/feature/movie/presentation/widget/artists_section_widget/bloc/artist_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/comment_table_widget/bloc/comment_table_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/country_multi_selector_widget/bloc/country_multi_selector_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/date_picker_section_widget/bloc/date_picker_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/genre_section_widget/bloc/genre_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/movie_upload_section_widget/bloc/movie_upload_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/poster_section_widget/bloc/poster_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/synopsis_section_widget/bloc/synopsis_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/thumbnail_section_widget/bloc/thumbnail_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/title_section_widget/bloc/title_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/trailer_upload_section_widget/bloc/trailer_upload_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/value_section_widget/bloc/value_section_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../feature/users/presentation/screen/user_page.dart';

enum RoutePath {
  dashboard(
      name: "dashboard",
      path: "/dashboard",
      fullPath: "/dashboard",
      title: "داشبورد"),
  login(name: "login", path: "/login", fullPath: "/login", title: "ورود"),
  editMovie(
      name: "edit_movie",
      path: "movie/:id",
      fullPath: "/media/movie/",
      title: "ویرایش فیلم"),
  detailMovie(
      name: "detail_movie",
      path: "movie/detail/:id",
      fullPath: "/media/movie/detail/",
      title: "فیلم"),
  addMovie(
      name: "add_movie",
      path: "movie",
      fullPath: "/media/movie",
      title: "افزودن فیلم"),
  media(
      name: "media", path: "/media", fullPath: "/media", title: "فیلم و سریال"),
  users(name: "users", path: "/users", fullPath: "/users", title: "کاربران");

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
          path: RoutePath.login.fullPath,
          name: RoutePath.login.name,
          pageBuilder: (BuildContext context, GoRouterState state) =>
              NoTransitionPage(
                  child: BlocProvider<LoginCubit>(
                      create: (context) =>
                          LoginCubit(loginRepository: getIt.get()),
                      child: const LoginPage()))),
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
                          int id = int.parse(state.pathParameters['id']!);
                          return NoTransitionPage(
                              child: MultiBlocProvider(providers: [
                            BlocProvider(
                                create: (context) => MovieUploadSectionCubit(
                                    repository: getIt.get())),
                            BlocProvider(
                                create: (context) =>
                                    CommentTableCubit(repository: getIt.get())),
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
                          ], child: MoviePage(movieId: id, isDetail: true)));
                        }),
                    GoRoute(
                        path: RoutePath.editMovie.path,
                        name: RoutePath.editMovie.name,
                        pageBuilder:
                            (BuildContext context, GoRouterState state) {
                          int id = int.parse(state.pathParameters['id']!);
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
                            ], child: const MoviePage(isDetail: false))))
                  ])
            ]),
          ])
    ],
    redirect: (BuildContext context, GoRouterState state) async {
      try {
        if (await getIt.get<LocalStorageService>().getAccessToken() == null) {
          return RoutePath.login.fullPath;
        }
        if (state.uri.path == RoutePath.login.fullPath) {
          return RoutePath.dashboard.fullPath;
        }

        return null;
      } catch (e) {
        return '/none';
      }
    },
    debugLogDiagnostics: false);
