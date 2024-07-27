import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/media/presentation/widget/artists_table/artists_table_widget.dart';
import 'package:dashboard/feature/media/presentation/widget/artists_table/bloc/artists_table_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/collections_table/bloc/collections_table_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/collections_table/collections_table_widget.dart';
import 'package:dashboard/feature/media/presentation/widget/country_table/bloc/countries_table_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/country_table/countries_table_widget.dart';
import 'package:dashboard/feature/media/presentation/widget/genres_table/bloc/genres_table_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/genres_table/genres_table_widget.dart';
import 'package:dashboard/feature/media/presentation/widget/movies_table/bloc/movies_table_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/movies_table/movies_table_widget.dart';
import 'package:dashboard/feature/media/presentation/widget/series_table/bloc/series_table_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/series_table/series_table_widget.dart';
import 'package:dashboard/feature/media/presentation/widget/sliders_table/bloc/sliders_table_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/sliders_table/sliders_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MediaPage extends StatelessWidget {
  const MediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      int width = constraints.constrainWidth().round();
      int height = constraints.constrainHeight().round();
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
                  Text("فیلم و سریال / ",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CustomColor.navRailTextColorDisable
                              .getColor(context)))
                ],
              ),
            ),
          ),
          SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                  child: SizedBox(
                      height: 410,
                      child: Card(
                          child: BlocProvider(
                              create: (context) =>
                                  MoviesTableCubit(repository: getIt.get()),
                              child: const MoviesTableWidget()))))),
          SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverToBoxAdapter(
                  child: SizedBox(
                      height: 410,
                      child: Card(
                        child: BlocProvider(
                          create: (context) =>
                              SeriesTableCubit(repository: getIt.get()),
                          child: const SeriesTableWidget(),
                        ),
                      )))),
          SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverToBoxAdapter(
                  child: SizedBox(
                      height: 410,
                      child: Card(
                        child: BlocProvider(
                          create: (context) =>
                              CollectionsTableCubit(repository: getIt.get()),
                          child: const CollectionsTableWidget(),
                        ),
                      )))),
          if (width > 880) ...[
            SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverCrossAxisGroup(slivers: [
                  SliverCrossAxisExpanded(
                      flex: 1,
                      sliver: SliverToBoxAdapter(
                          child: SizedBox(
                              height: 410,
                              child: Card(
                                child: BlocProvider(
                                  create: (context) =>
                                      GenresTableCubit(repository: getIt.get()),
                                  child: const GenresTableWidget(),
                                ),
                              )))),
                  SliverCrossAxisExpanded(
                    flex: 1,
                    sliver: SliverToBoxAdapter(
                        child: SizedBox(
                            height: 410,
                            child: Card(
                              child: BlocProvider(
                                create: (context) => CountriesTableCubit(
                                    repository: getIt.get()),
                                child: const CountriesTableWidget(),
                              ),
                            ))),
                  )
                ])),
            SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverCrossAxisGroup(slivers: [
                  SliverCrossAxisExpanded(
                      flex: 1,
                      sliver: SliverToBoxAdapter(
                          child: SizedBox(
                              height: 410,
                              child: Card(
                                child: BlocProvider(
                                  create: (context) => SlidersTableCubit(
                                      repository: getIt.get()),
                                  child: const SlidersTableWidget(),
                                ),
                              )))),
                  SliverCrossAxisExpanded(
                    flex: 1,
                    sliver: SliverToBoxAdapter(
                        child: SizedBox(
                            height: 410,
                            child: Card(
                              child: BlocProvider(
                                create: (context) =>
                                    ArtistsTableCubit(repository: getIt.get()),
                                child: const ArtistsTableWidget(),
                              ),
                            ))),
                  )
                ])),
          ]
          else ...[
            SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverToBoxAdapter(
                    child: SizedBox(
                        height: 410,
                        child: Card(
                          child: BlocProvider(
                            create: (context) =>
                                CountriesTableCubit(repository: getIt.get()),
                            child: const CountriesTableWidget(),
                          ),
                        )))),
            SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverToBoxAdapter(
                    child: SizedBox(
                        height: 410,
                        child: Card(
                          child: BlocProvider(
                            create: (context) =>
                                GenresTableCubit(repository: getIt.get()),
                            child: const GenresTableWidget(),
                          ),
                        )))),
            SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverToBoxAdapter(
                    child: SizedBox(
                        height: 410,
                        child: Card(
                          child: BlocProvider(
                            create: (context) =>
                                ArtistsTableCubit(repository: getIt.get()),
                            child: const ArtistsTableWidget(),
                          ),
                        )))),
            SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverToBoxAdapter(
                    child: SizedBox(
                        height: 410,
                        child: Card(
                          child: BlocProvider(
                            create: (context) =>
                                SlidersTableCubit(repository: getIt.get()),
                            child: const SlidersTableWidget(),
                          ),
                        )))),
          ]
        ],
      );
    });
  }
}
