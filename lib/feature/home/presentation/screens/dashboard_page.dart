import 'dart:math';

import 'package:dashboard/feature/home/data/remote/model/comment.dart';
import 'package:dashboard/feature/home/data/remote/model/plan.dart';
import 'package:dashboard/feature/home/data/remote/model/user.dart';
import 'package:dashboard/feature/home/presentation/common/custom_grid_column_sizer.dart';
import 'package:dashboard/feature/home/presentation/entities/comment_data_grid.dart';
import 'package:dashboard/feature/home/presentation/entities/plan_data_grid.dart';
import 'package:dashboard/feature/home/presentation/entities/user_data_grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
  late final PlanDataGrid _planDataGrid;
  late final CommentDataGrid _commentDataGrid;

  late final CustomGridColumnSizer _gridColumnSizer;

  @override
  void initState() {
    _gridColumnSizer = CustomGridColumnSizer();
    _planDataGrid = PlanDataGrid(context: context);
    _planDataGrid.buildDataGridRows(plans: [
      Plan(title: "طلا", days: 180, price: 180000, isEnable: true),
      Plan(title: "نقره", days: 60, price: 90000, isEnable: false),
      Plan(title: "نقره", days: 60, price: 120000, isEnable: true),
      Plan(title: "برنز", days: 30, price: 90000, isEnable: true)
    ]);

    _commentDataGrid = CommentDataGrid(context: context);
    _commentDataGrid.buildDataGridRows(comments: [
      Comment(
          username: "username",
          media: Media(
              name: "Godzilla x Kong: The New Empire",
              poster:
                  'https://image.tmdb.org/t/p/w500/gmGK5Gw5CIGMPhOmTO0bNA9Q66c.jpg'),
          comment:
              "بسیار فیلم مزخرف و خسته کننده بود. اصلا قشنگ نبود. پیشنهاد نمیکنم که ببینید",
          date: "2024-04-02T08:56:00Z",
          isPublished: 1),
      Comment(
          username: "username",
          media: Media(
              name: "Kung Fu Panda 4",
              poster:
                  'https://image.tmdb.org/t/p/w500/kDp1vUBnMpe8ak4rjgl3cLELqjU.jpg'),
          comment: "فوق العادهههههههههه بود من برگشتم به دوران بچگیم",
          date: "2024-04-02T08:56:00Z",
          isPublished: 1),
      Comment(
          username: "username",
          media: Media(
              name: "Road House",
              poster:
                  'https://image.tmdb.org/t/p/w500/bXi6IQiQDHD00JFio5ZSZOeRSBh.jpg'),
          comment:
              "بسیار فیلم مزخرف و خسته کننده بود. اصلا قشنگ نبود. پیشنهاد نمیکنم که ببینید",
          date: "2024-04-02T08:56:00Z",
          isPublished: 0),
      Comment(
          username: "username",
          media: Media(
              name: "Godzilla x Kong: The New Empire",
              poster:
                  'https://image.tmdb.org/t/p/w500/gmGK5Gw5CIGMPhOmTO0bNA9Q66c.jpg'),
          comment: "شاشی بود کلا",
          date: "2024-04-02T08:56:00Z",
          isPublished: -1),
      Comment(
          username: "username",
          media: Media(
              name: "Madame Web",
              poster:
                  'https://image.tmdb.org/t/p/w500/rULWuutDcN5NvtiZi4FRPzRYWSh.jpg'),
          comment:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Egestas purus viverra accumsan in nisl nisi. Arcu cursus vitae congue mauris rhoncus aenean vel elit scelerisque. In egestas erat imperdiet sed euismod nisi porta lorem mollis. Morbi tristique senectus et netus. Mattis pellentesque id nibh tortor id aliquet lectus proin. Sapien faucibus et molestie ac feugiat sed lectus vestibulum. Ullamcorper velit sed ullamcorper morbi tincidunt ornare massa eget. Dictum varius duis at consectetur lorem. Nisi vitae suscipit tellus mauris a diam maecenas sed enim. Velit ut tortor pretium viverra suspendisse potenti nullam. Et molestie ac feugiat sed lectus. Non nisi est sit amet facilisis magna. Dignissim diam quis enim lobortis scelerisque fermentum. Odio ut enim blandit volutpat maecenas volutpat. Ornare lectus sit amet est placerat in egestas erat. Nisi vitae suscipit tellus mauris a diam maecenas sed. Placerat duis ultricies lacus sed turpis tincidunt id aliquet.",
          date: "2024-04-02T08:56:00Z",
          isPublished: 1),
      Comment(
          username: "username",
          media: Media(
              name: "Godzilla x Kong: The New Empire",
              poster:
                  'https://image.tmdb.org/t/p/w500/gmGK5Gw5CIGMPhOmTO0bNA9Q66c.jpg'),
          comment:
              "خیلی ها این سریال متاسفانه درک نکردن و پایانش را بد میدانند.چون در حالی این سریال تماشا میکردند که در حال تخمه خوردن بودند و به سینما فقط برای سرگرمی وقت میگذارند. تک تک اتفاقات و دیالوگ ها اهمیت داره .در این سریال یاد خواهید گرفت از خانواده خود محافظت کنید.پست ترین انسان ها کسانی هستند که وقتی کسی اندامی ناقص دارد یا هر عیبی در پی تحقیر کردن یا نابود کردنشان هستند.خوش گذران ترین کاراکتر(کوتوله)شهوت ران ترین و مست ترین کاراکتر به کودک آزاری دست نمیزند(ازدواج با سانسا).کسی که زنای محسنه دارد (جیمی لنیستر)برای پاکدامن ماندن یک زن جانش را به خطر می اندازد و دستش قطع میشود.این سریال بی نظیره توقع پایان هالیودی و بالیودی نداشته باشید از آن درس زندگی یاد بگیرید.هر کاری کنی آخر داستان جنگ جهانی این است که در آخر آلمان شکست میخورد بالا بری پایین بیایی ته این داستان همینه هزار تا هم حالا فیلم بسازند.باید از داستانش عبرت گرفت.",
          date: "2024-04-02T08:56:00Z",
          isPublished: 0),
      Comment(
          username: "username",
          media: Media(
              name: "Creation of the Gods I: Kingdom of Storms",
              poster:
                  'https://image.tmdb.org/t/p/w500/kUKEwAoWe4Uyt8sFmtp5S86rlBk.jpg'),
          comment: "عالی",
          date: "2024-04-02T08:56:00Z",
          isPublished: 1),
    ]);
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
                  StaggeredGridTile.extent(
                      crossAxisCellCount: width / 5 >= 150 ? 3 : 5,
                      mainAxisExtent: 410,
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
                                "کاربران فعال اخیر",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            Expanded(child: userTable()),
                          ],
                        ),
                      )),
                  StaggeredGridTile.extent(
                      crossAxisCellCount: width / 5 >= 150 ? 2 : 5,
                      mainAxisExtent: 410,
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
                                "طرح های محبوب",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            Expanded(child: planTable()),
                          ],
                        ),
                      )),
                  StaggeredGridTile.extent(
                      crossAxisCellCount: 5,
                      mainAxisExtent: 410,
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
                                "نظرات اخیر",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            Expanded(child: commentTable()),
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
          gridLineColor: Theme.of(context).dividerColor),
      child: SfDataGrid(
          source: _userDataGrid,
          columnWidthMode: ColumnWidthMode.fill,
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

  Widget planTable() {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          headerColor: Theme.of(context).colorScheme.primary,
          gridLineColor: Theme.of(context).dividerColor),
      child: SfDataGrid(
          source: _planDataGrid,
          columnWidthMode: ColumnWidthMode.fill,
          isScrollbarAlwaysShown: true,
          gridLinesVisibility: GridLinesVisibility.none,
          headerGridLinesVisibility: GridLinesVisibility.none,
          columns: <GridColumn>[
            GridColumn(
                minimumWidth: 100,
                columnName: 'title',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('عنوان',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                minimumWidth: 100,
                columnName: 'time',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('مدت زمان',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                minimumWidth: 150,
                columnName: 'price',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('قیمت',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                minimumWidth: 150,
                columnName: 'status',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('وضعیت',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
          ]),
    );
  }

  Widget commentTable() {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          headerColor: Theme.of(context).colorScheme.primary,
          gridLineColor: Theme.of(context).dividerColor),
      child: SfDataGrid(
          source: _commentDataGrid,
          isScrollbarAlwaysShown: true,
          columnSizer: _gridColumnSizer,
          rowHeight: 150,
          onQueryRowHeight: (RowHeightDetails details) {
            var commentHeight = details.getIntrinsicRowHeight(details.rowIndex,
                excludedColumns: ['username', 'media', 'date', 'status']);
            if (commentHeight > details.rowHeight) {
              return commentHeight;
            }
            return details.rowHeight;
          },
          gridLinesVisibility: GridLinesVisibility.vertical,
          headerGridLinesVisibility: GridLinesVisibility.none,
          columns: <GridColumn>[
            GridColumn(
                minimumWidth: 140,
                columnName: 'username',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('کاربر',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                minimumWidth: 140,
                columnName: 'media',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('فیلم',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                columnWidthMode: ColumnWidthMode.lastColumnFill,
                minimumWidth: 400,
                columnName: 'comment',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('نظر',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                minimumWidth: 140,
                columnName: 'date',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('تاریخ',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                minimumWidth: 140,
                columnName: 'status',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('وضعیت',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
          ]),
    );
  }
}
