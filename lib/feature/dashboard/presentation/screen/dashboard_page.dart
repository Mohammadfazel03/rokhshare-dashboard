import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/header_information/bloc/header_information_cubit.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/header_information/header_information_widget.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/popular_plan/bloc/popular_plan_cubit.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/popular_plan/popular_plan_widget.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/recently_comment/bloc/recently_comment_cubit.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/recently_comment/recently_comment_widget.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/recently_user/bloc/recently_user_cubit.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/recently_user/recently_user_widget.dart';
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
import '../../data/remote/model/slider.dart';
import '../entities/ads_data_grid.dart';
import '../entities/slider_data_grid.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final SliderDataGrid _sliderDataGrid;
  late final AdsDataGrid _adsDataGrid;

  @override
  void initState() {
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 1,
                                  spreadRadius: 0.1,
                                )
                              ]),
                          child: BlocProvider(
                            create: (context) => getIt.get<RecentlyUserCubit>(),
                            child: const RecentlyUserWidget(),
                          ))),
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
                        child: BlocProvider(
                          create: (context) => getIt.get<PopularPlanCubit>(),
                          child: const PopularPlanWidget(),
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
                        child: BlocProvider(
  create: (context) => getIt.get<RecentlyCommentCubit>(),
  child: const RecentlyCommentWidget(),
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
