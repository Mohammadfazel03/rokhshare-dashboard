import 'dart:async';
import 'dart:math';

import 'package:dashboard/dashboard_page.dart';
import 'package:dashboard/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final StreamController<bool> sidebarController;

  @override
  void initState() {
    sidebarController = StreamController<bool>.broadcast();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int width = MediaQuery.of(context).size.width.round();
    int height = MediaQuery.of(context).size.height.round();
    return Scaffold(
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
                Expanded(child: DashboardPage())
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget appbar({required int height, required int width}) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: 1,
              spreadRadius: 1,
            )
          ]),
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
                          child: Icon(Icons.menu_rounded)))
                ],
                Text(
                  "داشبورد",
                  style: Theme.of(context).textTheme.headlineSmall,
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.white,
                          border: Border.all(width: 0),
                          image: DecorationImage(
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
      {required bool selected, required String title, required IconData icon}) {
    return DecoratedBox(
      decoration: BoxDecoration(
          boxShadow: [
            if (selected) ...[
              BoxShadow(
                color: Color.fromRGBO(55, 97, 235, 1),
                offset: const Offset(
                  0.0,
                  0.0,
                ),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ]
          ],
          color: selected ? Color.fromRGBO(55, 97, 235, 1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            )
          ],
        ),
      ),
    );
  }

  SidebarMenu sidebarMenu({required int height, required int width}) {
    return SidebarMenu(
      width: min(width / 3 * 2, 300),
      backgroundColor: Theme.of(context).drawerTheme.backgroundColor!,
      shape: Theme.of(context).drawerTheme.shape!,
      padding: EdgeInsets.all(16),
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
                        image: DecorationImage(
                            // scale: 0.1,
                            fit: BoxFit.fill,
                            image: AssetImage(
                              'assets/images/man.png',
                            )))),
              ),
              SizedBox(height: 8),
              Text(
                'محمد صادق فاضل',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'email@email.com',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 13),
              ),
              SizedBox(height: 8),
              sidebarItem(
                  selected: true,
                  icon: Icons.dashboard_rounded,
                  title: "داشبورد"),
              SizedBox(height: 8),
              sidebarItem(
                  selected: false, icon: FontAwesome5.user, title: "کاربران"),
              SizedBox(height: 8),
              sidebarItem(
                  selected: false, icon: FontAwesome5.ad, title: "تبلیغات"),
              SizedBox(height: 8),
              sidebarItem(
                  selected: false,
                  icon: FontAwesome.video,
                  title: "فیلم و سریال"),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
