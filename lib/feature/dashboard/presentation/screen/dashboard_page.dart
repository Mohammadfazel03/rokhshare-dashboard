import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/header_information/bloc/header_information_cubit.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/header_information/header_information_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../data/remote/model/ads.dart';
import '../../data/remote/model/comment.dart';
import '../../data/remote/model/plan.dart';
import '../../data/remote/model/slider.dart';
import '../../data/remote/model/user.dart';
import '../common/custom_grid_column_sizer.dart';
import '../entities/ads_data_grid.dart';
import '../entities/comment_data_grid.dart';
import '../entities/plan_data_grid.dart';
import '../entities/slider_data_grid.dart';
import '../entities/user_data_grid.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final UserDataGrid _userDataGrid;
  late final PlanDataGrid _planDataGrid;
  late final CommentDataGrid _commentDataGrid;
  late final SliderDataGrid _sliderDataGrid;
  late final AdsDataGrid _adsDataGrid;

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

    _sliderDataGrid = SliderDataGrid(context: context);
    _sliderDataGrid.buildDataGridRows(sliders: [
      SliderMovie(
          title: "Godzilla Vs Kong",
          priority: 1,
          description: "میان خشم و قدرتی ویرانگر",
          media: Media(
              name: "Godzilla x Kong: The New Empire",
              poster:
                  "https://image.tmdb.org/t/p/w500/gmGK5Gw5CIGMPhOmTO0bNA9Q66c.jpg")),
      SliderMovie(
          title: "پاندای کونگفوکار",
          priority: 1,
          description: "چطوری!!؟؟ نمیدونم",
          media: Media(
              name: "Kung Fu Panda 4",
              poster:
                  "https://image.tmdb.org/t/p/w500/kDp1vUBnMpe8ak4rjgl3cLELqjU.jpg")),
      SliderMovie(
          title: "زن اینترنت",
          priority: 1,
          description: "برای زندگی",
          media: Media(
              name: "Madame Web",
              poster:
                  "https://image.tmdb.org/t/p/w500/rULWuutDcN5NvtiZi4FRPzRYWSh.jpg")),
      SliderMovie(
          title: "خلق پادشاهی",
          priority: 1,
          description: "برای میراثمون!",
          media: Media(
              name: "Creation of the Gods I: Kingdom of Storms",
              poster:
                  "https://image.tmdb.org/t/p/w500/kUKEwAoWe4Uyt8sFmtp5S86rlBk.jpg")),
    ]);

    _adsDataGrid = AdsDataGrid(context: context);
    _adsDataGrid.buildDataGridRows(sliders: [
      Advertise(
          title: "شیزآلات شودر",
          createdAt: "2024-04-02T08:56:00Z",
          viewNumber: 88,
          mustPlayed: 65),
      Advertise(
          title: "فیلیمو",
          createdAt: "2021-04-02T08:56:00Z",
          viewNumber: 555555,
          mustPlayed: 65),
      Advertise(
          title: "نماوا",
          createdAt: "2020-10-02T08:56:00Z",
          viewNumber: 88,
          mustPlayed: 5),
      Advertise(
          title: "اینجا هوم",
          createdAt: "2024-04-08T08:56:00Z",
          viewNumber: 788,
          mustPlayed: 6555),
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
            BlocProvider(
              create: (context) => getIt.get<HeaderInformationCubit>(),
              child: HeaderInformationWidget(width: width),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: StaggeredGrid.count(
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                crossAxisCount: 10,
                children: [
                  StaggeredGridTile.extent(
                      crossAxisCellCount: width / 10 >= 75 ? 6 : 10,
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
                      crossAxisCellCount: width / 10 >= 75 ? 4 : 10,
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
                      crossAxisCellCount: 10,
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
                  StaggeredGridTile.extent(
                      crossAxisCellCount: width / 10 > 80 ? 5 : 10,
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
                                "صفحه اول",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            Expanded(child: sliderTable()),
                          ],
                        ),
                      )),
                  StaggeredGridTile.extent(
                      crossAxisCellCount: width / 10 > 80 ? 5 : 10,
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
                                "تبلیغات",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            Expanded(child: adsTable()),
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

  Widget sliderTable() {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          headerColor: Theme.of(context).colorScheme.primary,
          gridLineColor: Theme.of(context).dividerColor),
      child: SfDataGrid(
          source: _sliderDataGrid,
          isScrollbarAlwaysShown: true,
          rowHeight: 150,
          onQueryRowHeight: (RowHeightDetails details) {
            var descriptionHeight = details.getIntrinsicRowHeight(
                details.rowIndex,
                excludedColumns: ['title', 'media', 'priority']);
            if (descriptionHeight > details.rowHeight) {
              return descriptionHeight;
            }
            return details.rowHeight;
          },
          columnWidthMode: ColumnWidthMode.lastColumnFill,
          gridLinesVisibility: GridLinesVisibility.vertical,
          headerGridLinesVisibility: GridLinesVisibility.none,
          columns: <GridColumn>[
            GridColumn(
                minimumWidth: 40,
                columnName: 'priority',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('الویت',
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
                minimumWidth: 100,
                columnName: 'title',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('عنوان',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                minimumWidth: 200,
                columnName: 'description',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('توضیحات',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
          ]),
    );
  }

  Widget adsTable() {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          headerColor: Theme.of(context).colorScheme.primary,
          gridLineColor: Theme.of(context).dividerColor),
      child: SfDataGrid(
          source: _adsDataGrid,
          isScrollbarAlwaysShown: true,
          rowHeight: 150,
          onQueryRowHeight: (RowHeightDetails details) {
            return details.rowHeight;
          },
          columnWidthMode: ColumnWidthMode.lastColumnFill,
          gridLinesVisibility: GridLinesVisibility.vertical,
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
                minimumWidth: 140,
                columnName: 'createdAt',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('تاریخ ثبت',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                minimumWidth: 40,
                columnName: 'viewNumber',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('تماشا شده',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                minimumWidth: 40,
                columnName: 'mustPlayed',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('تعداد کل شفارش',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
          ]),
    );
  }
}
