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
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      int width = constraints.constrainWidth().round();
      int height = constraints.constrainHeight().round();
      return SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: SizedBox(
                width: width.toDouble(),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text("فیلم و سریال / ", style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: CustomColor.navRailTextColorDisable.getColor(context)
                    ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: StaggeredGrid.count(
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                crossAxisCount: 10,
                children: [
                  StaggeredGridTile.extent(
                      crossAxisCellCount: 10,
                      mainAxisExtent: 410,
                      child: Card(
                        child: BlocProvider(
                          create: (context) => MoviesTableCubit(repository: getIt.get()),
                          child: const MoviesTableWidget(),
                        ),
                      )),
                  StaggeredGridTile.extent(
                      crossAxisCellCount: 10,
                      mainAxisExtent: 410,
                      child: Card(
                        child: BlocProvider(
                          create: (context) => SeriesTableCubit(repository: getIt.get()),
                          child: const SeriesTableWidget(),
                        ),
                      )),
                  StaggeredGridTile.extent(
                      crossAxisCellCount: 10,
                      mainAxisExtent: 410,
                      child: Card(
                        child: BlocProvider(
                          create: (context) => CollectionsTableCubit(repository: getIt.get()),
                          child: const CollectionsTableWidget(),
                        ),
                      )),
                  StaggeredGridTile.extent(
                      crossAxisCellCount: width / 2 >= 440 ? 5 : 10,
                      mainAxisExtent: 410,
                      child: Card(
                        child: BlocProvider(
                          create: (context) => GenresTableCubit(repository: getIt.get()),
                          child: const GenresTableWidget(),
                        ),
                      )),
                  StaggeredGridTile.extent(
                      crossAxisCellCount: width / 2 >= 440 ? 5 : 10,
                      mainAxisExtent: 410,
                      child: Card(
                        child: BlocProvider(
                          create: (context) => CountriesTableCubit(repository: getIt.get()),
                          child: const CountriesTableWidget(),
                        ),
                      )),
                  StaggeredGridTile.extent(
                      crossAxisCellCount: width / 2 >= 440 ? 5 : 10,
                      mainAxisExtent: 410,
                      child: Card(
                        child: BlocProvider(
                          create: (context) => SlidersTableCubit(repository: getIt.get()),
                          child: const SlidersTableWidget(),
                        ),
                      )),
                  StaggeredGridTile.extent(
                      crossAxisCellCount: width / 2 >= 440 ? 5 : 10,
                      mainAxisExtent: 410,
                      child: Card(
                        child: BlocProvider(
                          create: (context) => ArtistsTableCubit(repository: getIt.get()),
                          child: const ArtistsTableWidget(),
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
