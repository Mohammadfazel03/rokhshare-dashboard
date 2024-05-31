import 'package:dashboard/feature/dashboard/presentation/screen/dashboard_page.dart';
import 'package:dashboard/feature/home/presentation/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../feature/users/presentation/screen/user_page.dart';

enum RoutePath {
  dashboard(name: "dashboard", path: "/dashboard", title: "داشبورد"),
  users(name: "users", path: "/users", title: "کاریران");

  const RoutePath({required this.name, required this.path, this.title});

  final String name;
  final String path;
  final String? title;

}

final routerConfig = GoRouter(
  initialLocation: RoutePath.dashboard.path,
  initialExtra: RoutePath.dashboard,
  routes: [
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return HomePage(pageScreen: child);
      },
      routes: [
        GoRoute(
            path: RoutePath.dashboard.path,
            name: RoutePath.dashboard.name,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                const NoTransitionPage(child: DashboardPage())),
        GoRoute(
            path: RoutePath.users.path,
            name: RoutePath.users.name,
            pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage(child: UserPage())),
      ],
    )
  ],
);
