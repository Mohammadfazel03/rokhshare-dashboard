import 'dart:math';

import 'package:dashboard/common/paginator_widget/pagination_widget.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/media_collection/presentation/bloc/media_collection_page_cubit.dart';
import 'package:dashboard/feature/media_collection/presentation/entity/media_data_grid.dart';
import 'package:dashboard/feature/media_collection/presentation/widget/media_autocomplete_field/media_autocomplete_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:toastification/toastification.dart';

class MediaCollectionPage extends StatefulWidget {
  final int collectionId;

  const MediaCollectionPage({super.key, required this.collectionId});

  @override
  State<MediaCollectionPage> createState() => _MediaCollectionPageState();
}

class _MediaCollectionPageState extends State<MediaCollectionPage> {
  late final MediaDataGrid _dataGrid;

  int get collectionId => widget.collectionId;

  @override
  void initState() {
    _dataGrid = MediaDataGrid(
        collectionId: collectionId,
        context: context,
        cubit: BlocProvider.of<MediaCollectionPageCubit>(context));
    BlocProvider.of<MediaCollectionPageCubit>(context)
        .getData(collectionId: collectionId);

    super.initState();
  }

  @override
  void dispose() {
    _dataGrid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width - 32;
    if (width > 1024) {
      width -= 332;
    }
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
                      context.pop();
                    },
                    child: Text("فیلم و سریال /",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: CustomColor.navRailTextColor
                                .getColor(context))),
                  ),
                ),
                Text("مجموعه /",
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
                        Flexible(
                          child: Text(
                            "فیلم و سریال ها",
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                        SizedBox(
                            width: min(width * 0.8, 300),
                            child: MediaAutocompleteField(selectMedia: (media) {
                              BlocProvider.of<MediaCollectionPageCubit>(context)
                                  .addMedia(
                                      mediaId: media.id!,
                                      collectionId: collectionId);
                            }))
                      ],
                    ),
                  ),
                  BlocConsumer<MediaCollectionPageCubit,
                      MediaCollectionPageState>(
                    listener: (context, state) {
                      if (state is MediaCollectionPageError) {
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
                                  title: "خطا در دریافت فیلم ها",
                                  message: state.error,
                                );
                              });
                        }
                      } else if (state is MediaCollectionPageSuccess) {
                        _dataGrid.buildDataGridRows(
                            media: state.data.results ?? []);
                      }
                    },
                    builder: (context, state) {
                      if (state is MediaCollectionPageSuccess) {
                        if (_dataGrid.rows.isNotEmpty) {
                          return Expanded(child: table());
                        } else {
                          return Expanded(
                              child: Center(
                            child: Text(
                              "فیلمی وجود ندارد",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ));
                        }
                      } else if (state is MediaCollectionPageLoading) {
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
                      } else if (state is MediaCollectionPageError) {
                        if (_dataGrid.rows.isEmpty) {
                          return Expanded(child: _error(state.error));
                        } else {
                          return Expanded(child: table());
                        }
                      }
                      return Expanded(child: _error(null));
                    },
                  ),
                  BlocBuilder<MediaCollectionPageCubit,
                      MediaCollectionPageState>(
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
                                                  .of<MediaCollectionPageCubit>(
                                                      context)
                                              .state
                                          is! MediaCollectionPageLoading) {
                                        BlocProvider.of<
                                                    MediaCollectionPageCubit>(
                                                context)
                                            .getData(
                                                page: page,
                                                collectionId: collectionId);
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
              )),
            ),
          )
        ],
      ),
    );
  }

  Widget table() {
    return SfDataGrid(
        highlightRowOnHover: false,
        source: _dataGrid,
        isScrollbarAlwaysShown: true,
        rowHeight: 56,
        headerRowHeight: 56,
        columnWidthMode: ColumnWidthMode.lastColumnFill,
        gridLinesVisibility: GridLinesVisibility.none,
        headerGridLinesVisibility: GridLinesVisibility.none,
        columns: <GridColumn>[
          GridColumn(
              minimumWidth: 80,
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
              maximumWidth: 200,
              minimumWidth: 200,
              columnName: 'name',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('عنوان',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              maximumWidth: 200,
              minimumWidth: 200,
              columnName: 'genres',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('ژانر',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              maximumWidth: 200,
              minimumWidth: 200,
              columnName: 'countries',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('کشور سازنده',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              maximumWidth: 150,
              minimumWidth: 150,
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
              minimumWidth: 150,
              columnName: 'actions',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('عملیات ها',
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
                  BlocProvider.of<MediaCollectionPageCubit>(context)
                      .getData(collectionId: collectionId);
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
