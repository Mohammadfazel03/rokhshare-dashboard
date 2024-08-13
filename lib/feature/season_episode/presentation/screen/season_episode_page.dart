import 'dart:math';

import 'package:dashboard/common/paginator_widget/pagination_widget.dart';
import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/season_episode/presentation/bloc/season_episode_page_cubit.dart';
import 'package:dashboard/feature/season_episode/presentation/entity/season_episode_data_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:toastification/toastification.dart';

class SeasonEpisodePage extends StatefulWidget {
  final int seasonId;

  const SeasonEpisodePage({super.key, required this.seasonId});

  @override
  State<SeasonEpisodePage> createState() => _SeasonEpisodePageState();
}

class _SeasonEpisodePageState extends State<SeasonEpisodePage> {
  late final SeasonEpisodeDataGrid _dataGrid;

  @override
  void initState() {
    _dataGrid = SeasonEpisodeDataGrid(
        context: context,
        cubit: BlocProvider.of<SeasonEpisodePageCubit>(context));
    BlocProvider.of<SeasonEpisodePageCubit>(context)
        .getData(seasonId: widget.seasonId);

    super.initState();
  }

  @override
  void dispose() {
    _dataGrid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
              spacing: 8,
              runSpacing: 4,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      int count = 0;
                      Navigator.of(context).popUntil((_) => count++ >= 2);
                    },
                    child: Text("فیلم و سریال /",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: CustomColor.navRailTextColor
                                .getColor(context))),
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: Text("فصل ها /",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: CustomColor.navRailTextColor
                                .getColor(context))),
                  ),
                ),
                Text("قسمت ها /",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: CustomColor.navRailTextColorDisable
                            .getColor(context)))
              ]),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "قسمت ها",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          FilledButton.icon(
                            onPressed: () {
                              // context.go(RoutePath.addMovie.fullPath,
                              //     extra: BlocProvider.of<EpisodePageCubit>(
                              //         context));
                            },
                            label: const Text(
                              "افزودن",
                            ),
                            icon: const Icon(Icons.add),
                            style: ButtonStyle(
                              padding: WidgetStateProperty.all(
                                  const EdgeInsets.symmetric(horizontal: 16)),
                              textStyle: WidgetStateProperty.all(
                                  Theme.of(context).textTheme.labelMedium),
                              shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    BlocConsumer<SeasonEpisodePageCubit,
                        SeasonEpisodePageState>(
                      listener: (context, state) {
                        if (state is SeasonEpisodePageError) {
                          if (state.code == 403) {
                            getIt
                                .get<LocalStorageService>()
                                .logout()
                                .then((value) {
                              context.go(RoutePath.login.fullPath);
                            });
                          }
                          if (_dataGrid.rows.isNotEmpty) {
                            toastification.showCustom(
                                animationDuration:
                                    const Duration(milliseconds: 300),
                                context: context,
                                alignment: Alignment.bottomRight,
                                autoCloseDuration: const Duration(seconds: 4),
                                direction: TextDirection.rtl,
                                builder: (BuildContext context,
                                    ToastificationItem holder) {
                                  return ErrorSnackBarWidget(
                                    item: holder,
                                    title: "خطا در دریافت قسمت ها",
                                    message: state.error,
                                  );
                                });
                          }
                        } else if (state is SeasonEpisodePageSuccess) {
                          _dataGrid.buildDataGridRows(
                              episode: state.data.results ?? []);
                        }
                      },
                      builder: (context, state) {
                        if (state is SeasonEpisodePageSuccess) {
                          if (_dataGrid.rows.isNotEmpty) {
                            return Expanded(child: table());
                          } else {
                            return Expanded(
                                child: Center(
                              child: Text(
                                "قسمتی وجود ندارد",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ));
                          }
                        } else if (state is SeasonEpisodePageLoading) {
                          if (_dataGrid.rows.isEmpty) {
                            return Expanded(
                                child: Center(
                                    child: RepaintBoundary(
                                        child: SpinKitThreeBounce(
                              color: CustomColor.loginBackgroundColor
                                  .getColor(context),
                            ))));
                          } else {
                            return Expanded(
                                child: Stack(
                              children: [
                                Positioned.fill(child: table()),
                                Positioned.fill(
                                    child: Container(
                                  color: Colors.black12,
                                  child: Center(
                                      child: RepaintBoundary(
                                          child: SpinKitThreeBounce(
                                    color: CustomColor.loginBackgroundColor
                                        .getColor(context),
                                  ))),
                                ))
                              ],
                            ));
                          }
                        } else if (state is SeasonEpisodePageError) {
                          if (_dataGrid.rows.isEmpty) {
                            return Expanded(child: _error(state.error));
                          } else {
                            return Expanded(child: table());
                          }
                        }
                        return Expanded(child: _error(null));
                      },
                    ),
                    BlocBuilder<SeasonEpisodePageCubit, SeasonEpisodePageState>(
                      buildWhen: (current, previous) {
                        return current.numberPages != previous.numberPages ||
                            current.pageIndex != previous.pageIndex;
                      },
                      builder: (context, state) {
                        if (state.numberPages != 0) {
                          return Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: PaginationWidget(
                                      totalPages: state.numberPages,
                                      currentPage: state.pageIndex,
                                      onChangePage: (page) {
                                        if (BlocProvider
                                                    .of<SeasonEpisodePageCubit>(
                                                        context)
                                                .state
                                            is! SeasonEpisodePageLoading) {
                                          BlocProvider.of<
                                                      SeasonEpisodePageCubit>(
                                                  context)
                                              .getData(
                                                  page: page,
                                                  seasonId: widget.seasonId);
                                        }
                                      }),
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox();
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget table() {
    var width = MediaQuery.sizeOf(context).width - 32;
    if (width > 1024) {
      width -= 332;
    }
    return SfDataGrid(
        source: _dataGrid,
        isScrollbarAlwaysShown: true,
        headerRowHeight: 56,
        rowHeight: 100,
        columnWidthMode: ColumnWidthMode.none,
        gridLinesVisibility: GridLinesVisibility.none,
        headerGridLinesVisibility: GridLinesVisibility.none,
        columns: <GridColumn>[
          GridColumn(
              width: max(175, width / 1000 * 175),
              columnName: 'id',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('شناسه',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              minimumWidth: max(425, width / 1000 * 425),
              columnName: 'episode',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('قسمت',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              minimumWidth: max(200, width / 1000 * 200),
              columnName: 'releaseDate',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('زمان انتشار',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              minimumWidth: max(200, width / 1000 * 200),
              columnName: 'commentsCount',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('تعداد کامنت',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
        ]);
  }

  Widget _error(String? error) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              error ?? "خطا در دریافت اطلاعات!",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 8),
            OutlinedButton(
                onPressed: () {
                  BlocProvider.of<SeasonEpisodePageCubit>(context)
                      .getData(seasonId: widget.seasonId);
                },
                child: Text(
                  "تلاش مجدد",
                  style: Theme.of(context).textTheme.labelSmall,
                ))
          ],
        ),
      ],
    );
  }
}
