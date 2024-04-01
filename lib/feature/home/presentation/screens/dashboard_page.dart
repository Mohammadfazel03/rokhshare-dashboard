import 'dart:math';

import 'package:dashboard/feature/home/data/remote/model/user.dart';
import 'package:dashboard/feature/home/presentation/entities/user_data_grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final UserDataGrid _userDataGrid;

  @override
  void initState() {
    _userDataGrid = UserDataGrid(context: context);
    _userDataGrid.buildDataGridRows(users: [
      User(
          username: "username",
          fullName: "Mohammad Sadeq",
          isPremium: true,
          dateJoined: "2015-02-11T00:00:00Z",
          seenMovies: 345),
      User(
          username: "username",
          fullName: "Narges",
          isPremium: false,
          dateJoined: "2015-02-11T00:00:00Z",
          seenMovies: 345),
      User(
          username: "username",
          fullName: "مریم",
          isPremium: true,
          dateJoined: "2015-02-11T00:00:00Z",
          seenMovies: 345),
      User(
          username: "username",
          fullName: "نگین",
          isPremium: false,
          dateJoined: "2015-02-11T00:00:00Z",
          seenMovies: 102),
      User(
          username: "username",
          fullName: "محسن",
          isPremium: false,
          dateJoined: "2015-02-11T00:00:00Z",
          seenMovies: 345),
      User(
          username: "username",
          fullName: "Mohammad",
          isPremium: true,
          dateJoined: "2024-03-27T08:59:34.575705Z",
          seenMovies: 345),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      int width = constraints.constrainWidth().round();
      int height = constraints.constrainHeight().round();
      return SingleChildScrollView(
        child: Column(
          children: [
            GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: min(4, width ~/ 250),
              scrollDirection: Axis.vertical,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1 / (100 / (width / min(4, width ~/ 250))),
              padding: EdgeInsets.all(16),
              children: [
                informationCard(
                    icon: CupertinoIcons.person_crop_circle_fill,
                    title: "256K",
                    subtitle: "کاربران",
                    percent: "2.1",
                    isProfit: true),
                informationCard(
                    icon: CupertinoIcons.videocam_circle_fill,
                    title: "1M",
                    subtitle: "فیلم و سریال",
                    percent: "0.0",
                    isProfit: false),
                informationCard(
                    icon: Elusive.basket_circled,
                    title: "456",
                    subtitle: "مشترکین",
                    percent: "0.5",
                    isProfit: false),
                informationCard(
                    icon: CupertinoIcons.money_dollar_circle_fill,
                    title: "10",
                    subtitle: "تبلیغات",
                    percent: "5.0",
                    isProfit: true),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: StaggeredGrid.count(
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                crossAxisCount: 5,
                children: [
                  StaggeredGridTile.fit(
                      crossAxisCellCount: 5,
                      child: Container(
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).shadowColor,
                                blurRadius: 1,
                                spreadRadius: 0.1,
                              )
                            ]),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                "کاربران جدید",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            userTable(),
                          ],
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  Widget informationCard(
      {required IconData icon,
      required String title,
      required String subtitle,
      String? percent,
      bool? isProfit}) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: 1,
              spreadRadius: 0.1,
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Icon(icon),
                    ),
                  )),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (isProfit != null && percent != null) ...[
                        Text(
                          "${percent}%",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: isProfit ? Colors.green : Colors.red),
                        ),
                        Icon(
                          isProfit
                              ? Icons.arrow_drop_up_rounded
                              : Icons.arrow_drop_down_rounded,
                          color: isProfit ? Colors.green : Colors.red,
                        )
                      ]
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget userTable() {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          headerColor: Theme.of(context).colorScheme.primary,
        gridLineColor: Theme.of(context).dividerColor
      ),
      child: SfDataGrid(
          source: _userDataGrid,
          columnWidthMode: ColumnWidthMode.fill,
          shrinkWrapRows: true,
          isScrollbarAlwaysShown: true,
          gridLinesVisibility: GridLinesVisibility.none,
          headerGridLinesVisibility: GridLinesVisibility.none,
          columns: <GridColumn>[
            GridColumn(
                minimumWidth: 150,
                columnName: 'username',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('نام کاربری',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                minimumWidth: 150,
                columnName: 'name',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('نام',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                minimumWidth: 150,
                columnName: 'status',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('وضعیت اشتراک',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                minimumWidth: 150,
                columnName: 'movieViewed',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('تعداد تماشا',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                minimumWidth: 150,
                columnName: 'date',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('تاریخ عضویت',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
          ]),
    );
  }
}
