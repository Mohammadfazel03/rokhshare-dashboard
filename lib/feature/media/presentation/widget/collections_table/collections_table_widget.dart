import 'dart:math';

import 'package:dashboard/common/paginator_widget/pagination_widget.dart';
import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/media/presentation/widget/collections_table/bloc/collection_append_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/collections_table/bloc/collections_table_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/collections_table/collection_append_dialog_widget.dart';
import 'package:dashboard/feature/media/presentation/widget/collections_table/entity/collection_data_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:toastification/toastification.dart';

class CollectionsTableWidget extends StatefulWidget {
  const CollectionsTableWidget({super.key});

  @override
  State<CollectionsTableWidget> createState() => _CollectionsTableWidgetState();
}

class _CollectionsTableWidgetState extends State<CollectionsTableWidget> {
  late final CollectionDataGrid _dataGrid;

  @override
  void initState() {
    _dataGrid = CollectionDataGrid(
        context: context,
        cubit: BlocProvider.of<CollectionsTableCubit>(context));
    BlocProvider.of<CollectionsTableCubit>(context).getData();

    super.initState();
  }

  @override
  void dispose() {
    _dataGrid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                "مجموعه ها",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              FilledButton.icon(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return Dialog(
                          clipBehavior: Clip.hardEdge,
                          child: SizedBox(
                              width: min(
                                  MediaQuery.sizeOf(context).width * 0.8, 560),
                              child: MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(
                                      value: BlocProvider.of<
                                          CollectionsTableCubit>(context)),
                                  BlocProvider<CollectionAppendCubit>(
                                      create: (context) =>
                                          CollectionAppendCubit(
                                              repository: getIt.get())),
                                ],
                                child: CollectionAppendDialogWidget(
                                    width: min(
                                        MediaQuery.sizeOf(context).width * 0.8,
                                        560)),
                              )),
                        );
                      });
                },
                label: const Text(
                  "افزودن",
                ),
                icon: const Icon(Icons.add),
                style: ButtonStyle(
                  alignment: Alignment.center,
                  padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 16)),
                  textStyle: WidgetStateProperty.all(
                      Theme.of(context).textTheme.labelMedium),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
                ),
              )
            ],
          ),
        ),
        BlocConsumer<CollectionsTableCubit, CollectionsTableState>(
          listener: (context, state) {
            if (state is CollectionsTableError) {
              if (_dataGrid.rows.isNotEmpty) {
                toastification.showCustom(
                    animationDuration: const Duration(milliseconds: 300),
                    context: context,
                    alignment: Alignment.bottomRight,
                    autoCloseDuration: const Duration(seconds: 4),
                    direction: TextDirection.rtl,
                    builder: (BuildContext context, ToastificationItem holder) {
                      return ErrorSnackBarWidget(
                        item: holder,
                        title: "خطا در دریافت مجموعه",
                        message: state.error,
                      );
                    });
              }
            } else if (state is CollectionsTableSuccess) {
              _dataGrid.buildDataGridRows(
                  collections: state.data.results ?? []);
            }
          },
          builder: (context, state) {
            if (state is CollectionsTableSuccess) {
              if (_dataGrid.rows.isNotEmpty) {
                return Expanded(child: table());
              } else {
                return Expanded(
                    child: Center(
                  child: Text(
                    "مجموعه ای وجود ندارد",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ));
              }
            } else if (state is CollectionsTableLoading) {
              if (_dataGrid.rows.isEmpty) {
                return Expanded(
                    child: Center(
                        child: RepaintBoundary(
                            child: SpinKitThreeBounce(
                  color: CustomColor.loginBackgroundColor.getColor(context),
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
                        color:
                            CustomColor.loginBackgroundColor.getColor(context),
                      ))),
                    ))
                  ],
                ));
              }
            } else if (state is CollectionsTableError) {
              if (_dataGrid.rows.isEmpty) {
                return Expanded(child: _error(state.error));
              } else {
                return Expanded(child: table());
              }
            }
            return Expanded(child: _error(null));
          },
        ),
        BlocBuilder<CollectionsTableCubit, CollectionsTableState>(
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
                            if (BlocProvider.of<CollectionsTableCubit>(context)
                                .state is! CollectionsTableLoading) {
                              BlocProvider.of<CollectionsTableCubit>(context)
                                  .getData(page: page);
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
    );
  }

  Widget table() {
    return SfDataGrid(
        highlightRowOnHover: false,
        source: _dataGrid,
        isScrollbarAlwaysShown: true,
        rowHeight: 150,
        headerRowHeight: 56,
        columnWidthMode: ColumnWidthMode.fill,
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
              minimumWidth: 140,
              columnName: 'media',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('مجموعه',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 140,
              columnName: 'owner',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('سازنده',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 140,
              columnName: 'date',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('زمان ساخت',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 140,
              columnName: 'status',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('وضعیت',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 140,
              columnName: 'actions',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('عملیات',
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
                  BlocProvider.of<CollectionsTableCubit>(context).getData();
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
