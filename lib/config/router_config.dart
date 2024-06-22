import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/feature/404/presentation/screen/not_found_page.dart';
import 'package:dashboard/feature/dashboard/presentation/screen/dashboard_page.dart';
import 'package:dashboard/feature/home/presentation/screen/home_page.dart';
import 'package:dashboard/feature/login/presentation/bloc/login_cubit.dart';
import 'package:dashboard/feature/login/presentation/screen/login_page.dart';
import 'package:dashboard/feature/media/presentation/screen/media_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../feature/users/presentation/screen/user_page.dart';

enum RoutePath {
  dashboard(name: "dashboard", path: "/dashboard", title: "داشبورد"),
  login(name: "login", path: "/login", title: "ورود"),
  media(name: "media", path: "/media", title: "فیلم و سریال"),
  users(name: "users", path: "/users", title: "کاریران");

  const RoutePath({required this.name, required this.path, this.title});

  final String name;
  final String path;
  final String? title;
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerConfig = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePath.dashboard.path,
    errorBuilder: (BuildContext context, GoRouterState state) => NotFoundPage(),
    routes: [
      GoRoute(
          path: RoutePath.login.path,
          name: RoutePath.login.name,
          pageBuilder: (BuildContext context, GoRouterState state) =>
              NoTransitionPage(
                  child: BlocProvider<LoginCubit>(
                create: (context) => getIt.get<LoginCubit>(),
                child: const LoginPage(),
              ))),
      StatefulShellRoute.indexedStack(
          builder: (BuildContext context, GoRouterState state, Widget child) {
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
                      const NoTransitionPage(child: MediaPage()))
            ]),
          ])
    ],
    redirect: (BuildContext context, GoRouterState state) async {
      try {
        if (getIt.get<LocalStorageService>().getAccessToken() == null) {
          return RoutePath.login.path;
        }
        if (state.uri.path == RoutePath.login.path) {
          return RoutePath.dashboard.path;
        }

        return null;
      } catch (e) {
        // print(e);
        return '/none';
      }
    },
    debugLogDiagnostics: true);
