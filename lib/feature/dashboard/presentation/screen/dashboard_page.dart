import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/first_screen_slider/bloc/first_screen_slider_cubit.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/first_screen_slider/first_screen_slider_widget.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/header_information/bloc/header_information_cubit.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/header_information/header_information_widget.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/popular_plan/bloc/popular_plan_cubit.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/popular_plan/popular_plan_widget.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/recently_advertise/bloc/recently_advertise_cubit.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/recently_advertise/recently_advertise_widget.dart';
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

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
                          create: (context) =>
                              getIt.get<RecentlyCommentCubit>(),
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
                        child: BlocProvider(
                          create: (context) =>
                              getIt.get<FirstScreenSliderCubit>(),
                          child: const FirstScreenSliderWidget(),
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
                        child: BlocProvider(
                          create: (context) =>
                              getIt.get<RecentlyAdvertiseCubit>(),
                          child: const RecentlyAdvertiseWidget(),
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
}
