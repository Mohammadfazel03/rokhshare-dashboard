import 'dart:async';
import 'dart:math';

import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/config/theme/theme_cubit.dart';
import 'package:dashboard/feature/home/presentation/widget/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class HomePage extends StatefulWidget {
  final StatefulNavigationShell pageScreen;

  const HomePage({super.key, required this.pageScreen});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final StreamController<bool> sidebarController;
  late String? _routeName;

  @override
  void initState() {
    sidebarController = StreamController<bool>.broadcast();
    super.initState();
  }

  @override
  void dispose() {
    sidebarController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int width = MediaQuery.of(context).size.width.round();
    int height = MediaQuery.of(context).size.height.round();
    try {
      _routeName = GoRouter.of(context)
          .routerDelegate
          .currentConfiguration
          .last
          .route
          .name;
    } catch (e) {
      _routeName = null;
    }
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          headerColor: Theme.of(context).colorScheme.secondaryContainer,
          gridLineColor: Theme.of(context).dividerColor),
      child: Scaffold(
        body: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (width > 1024) ...[sidebarMenu(height: height, width: width)],
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: appbar(width: width, height: height),
                  ),
                  Expanded(child: widget.pageScreen)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget appbar({required int height, required int width}) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(8),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (width <= 1024) ...[
                  IconButton(
                      onPressed: () {
                        sidebarController.add(true);
                      },
                      icon: Sidebar(
                          controller: sidebarController,
                          sidebarMenu:
                              sidebarMenu(height: height, width: width),
                          child: Icon(
                            Icons.menu_rounded,
                            color: Theme.of(context).colorScheme.onSurface,
                          ))),
                  const SizedBox(width: 8)
                ],
                Text(
                  getTitleByPath(_routeName ?? "") ?? "",
                  style: Theme.of(context).textTheme.titleLarge,
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      BlocProvider.of<ThemeCubit>(context).changeTheme(
                          Theme.of(context).brightness == Brightness.dark
                              ? ThemeMode.light
                              : ThemeMode.dark);
                    },
                    icon: Icon(
                      Theme.of(context).brightness == Brightness.dark
                          ? Iconic.sun_inv
                          : Iconic.moon_inv,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
                const SizedBox(width: 8),
                SizedBox(
                  width: 32,
                  height: 32,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.white,
                          border: Border.all(width: 0),
                          image: const DecorationImage(
                              // scale: 0.1,
                              fit: BoxFit.fill,
                              image: AssetImage(
                                'assets/images/man.png',
                              )))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget sidebarItem(
      {Function()? onClick,
      required bool selected,
      required String title,
      required IconData icon}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          sidebarController.add(false);
          if (onClick != null) {
            onClick();
          }
        },
        child: Material(
          elevation: selected ? 2 : 0,
          color: selected
              ? Theme.of(context).colorScheme.secondaryContainer
              : Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: selected
                      ? Theme.of(context).colorScheme.onSecondaryContainer
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: selected
                          ? Theme.of(context).colorScheme.onSecondaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  SidebarMenu sidebarMenu({required int height, required int width}) {
    return SidebarMenu(
      width: min(width / 3 * 2, 300),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: Theme.of(context).drawerTheme.shape!,
      padding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: min(min(width / 3 * 2, 300) / 2, 150),
                height: min(min(width / 3 * 2, 300) / 2, 150),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            min(min(width / 3 * 2, 300) / 2, 150)),
                        color: Colors.white,
                        border: Border.all(width: 0),
                        image: const DecorationImage(
                            // scale: 0.1,
                            fit: BoxFit.fill,
                            image: AssetImage(
                              'assets/images/man.png',
                            )))),
              ),
              const SizedBox(height: 8),
              Text('محمد صادق فاضل',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              Text(
                'email@email.com',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 8),
              sidebarItem(
                  selected: widget.pageScreen.currentIndex == 0,
                  icon: Icons.dashboard_rounded,
                  title: "داشبورد",
                  onClick: () {
                    widget.pageScreen.goBranch(0);
                  }),
              const SizedBox(height: 8),
              sidebarItem(
                  selected: widget.pageScreen.currentIndex == 1,
                  icon: FontAwesome5.user,
                  title: "کاربران",
                  onClick: () {
                    widget.pageScreen.goBranch(1);
                  }),
              const SizedBox(height: 8),
              sidebarItem(
                  selected: widget.pageScreen.currentIndex == 2,
                  icon: FontAwesome5.ad,
                  title: "تبلیغات",
                  onClick: () {
                    widget.pageScreen.goBranch(2);
                  }),
              const SizedBox(height: 8),
              sidebarItem(
                  selected: widget.pageScreen.currentIndex == 3,
                  icon: FontAwesome.video,
                  title: "فیلم و سریال",
                  onClick: () {
                    widget.pageScreen.goBranch(3);
                  }),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  String? getTitleByPath(String name) {
    try {
      return RoutePath.values.firstWhere((e) => e.name == name).title;
    } catch (e) {
      return "";
    }
  }
}
