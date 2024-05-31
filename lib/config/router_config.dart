import 'package:dashboard/feature/dashboard/presentation/screen/dashboard_page.dart';
import 'package:dashboard/feature/home/presentation/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum RoutePath {
  dashboard(name: "dashboard", path: "/dashboard", title: "داشبورد");

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
      ],
    )
  ],
);
