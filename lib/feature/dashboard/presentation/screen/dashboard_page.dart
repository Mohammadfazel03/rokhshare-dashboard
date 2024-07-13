import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/theme/colors.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.constrainWidth();
      double height = constraints.constrainHeight();
      return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            sliver: SliverToBoxAdapter(
              child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text("داشبورد / ",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                                color: CustomColor
                                    .navRailTextColorDisable
                                    .getColor(context)))
                  ]),
            ),
          ),
          BlocProvider(
            create: (context) =>
                HeaderInformationCubit(repository: getIt.get()),
            child: HeaderInformationWidget(width: width.round()),
          ),
          if (width >= 750) ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              sliver: SliverCrossAxisGroup(slivers: [
                SliverCrossAxisExpanded(
                    flex: 4,
                    sliver: SliverToBoxAdapter(
                        child: SizedBox(
                            height: 410,
                            child: Card(
                                child: BlocProvider(
                              create: (context) =>
                                  PopularPlanCubit(repository: getIt.get()),
                              child: const PopularPlanWidget(),
                            ))))),
                SliverCrossAxisExpanded(
                    flex: 6,
                    sliver: SliverToBoxAdapter(
                        child: SizedBox(
                            height: 410,
                            child: Card(
                                child: BlocProvider(
                              create: (context) =>
                                  RecentlyUserCubit(repository: getIt.get()),
                              child: const RecentlyUserWidget(),
                            )))))
              ]),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverToBoxAdapter(
                  child: SizedBox(
                      height: 410,
                      child: Card(
                          child: BlocProvider(
                              create: (context) =>
                                  RecentlyCommentCubit(repository: getIt.get()),
                              child: const RecentlyCommentWidget())))),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverCrossAxisGroup(slivers: [
                SliverCrossAxisExpanded(
                    flex: 5,
                    sliver: SliverToBoxAdapter(
                        child: SizedBox(
                            height: 410,
                            child: Card(
                                child: BlocProvider(
                                    create: (context) =>
                                        FirstScreenSliderCubit(repository: getIt.get()),
                                    child: const FirstScreenSliderWidget()))))),
                SliverCrossAxisExpanded(
                    flex: 5,
                    sliver: SliverToBoxAdapter(
                        child: SizedBox(
                            height: 410,
                            child: Card(
                                child: BlocProvider(
                                    create: (context) =>
                                        RecentlyAdvertiseCubit(repository: getIt.get()),
                                    child: const RecentlyAdvertiseWidget())))))
              ]),
            ),
          ]
          else ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              sliver: SliverToBoxAdapter(
                  child: SizedBox(
                      height: 410,
                      child: Card(
                          child: BlocProvider(
                              create: (context) =>
                                  RecentlyUserCubit(repository: getIt.get()),
                              child: const RecentlyUserWidget())))),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverToBoxAdapter(
                  child: SizedBox(
                      height: 410,
                      child: Card(
                          child: BlocProvider(
                              create: (context) =>
                                  PopularPlanCubit(repository: getIt.get()),
                              child: const PopularPlanWidget())))),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverToBoxAdapter(
                  child: SizedBox(
                      height: 410,
                      child: Card(
                          child: BlocProvider(
                              create: (context) =>
                                  RecentlyCommentCubit(repository: getIt.get()),
                              child: const RecentlyCommentWidget())))),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverToBoxAdapter(
                  child: SizedBox(
                      height: 410,
                      child: Card(
                          child: BlocProvider(
                              create: (context) =>
                                  RecentlyAdvertiseCubit(repository: getIt.get()),
                              child: const RecentlyAdvertiseWidget())))),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverToBoxAdapter(
                  child: SizedBox(
                      height: 410,
                      child: Card(
                          child: BlocProvider(
                              create: (context) =>
                                  FirstScreenSliderCubit(repository: getIt.get()),
                              child: const FirstScreenSliderWidget())))),
            ),
          ]
        ],
      );
    });
  }
}
