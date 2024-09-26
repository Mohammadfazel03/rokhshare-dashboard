import 'dart:math';

import 'package:dashboard/common/paginator_widget/pagination_widget.dart';
import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/advertise/presentation/widget/advertise_table/advertise_append_dialog_widget.dart';
import 'package:dashboard/feature/advertise/presentation/widget/advertise_table/bloc/advertise_append_cubit.dart';
import 'package:dashboard/feature/advertise/presentation/widget/advertise_table/bloc/advertise_table_cubit.dart';
import 'package:dashboard/feature/advertise/presentation/widget/advertise_table/entity/advertise_data_grid.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:toastification/toastification.dart';

class AdvertiseTableWidget extends StatefulWidget {
  const AdvertiseTableWidget({super.key});

  @override
  State<AdvertiseTableWidget> createState() => _AdvertiseTableWidgetState();
}

class _AdvertiseTableWidgetState extends State<AdvertiseTableWidget> {
  late final AdvertiseDataGrid _dataGrid;

  @override
  void initState() {
    _dataGrid = AdvertiseDataGrid(
        context: context, cubit: BlocProvider.of<AdvertiseTableCubit>(context));
    BlocProvider.of<AdvertiseTableCubit>(context).getData();
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
                "تبلیغات",
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
                                      value:
                                          BlocProvider.of<AdvertiseTableCubit>(
                                              context)),
                                  BlocProvider<AdvertiseAppendCubit>(
                                      create: (context) => AdvertiseAppendCubit(
                                          repository: getIt.get())),
                                ],
                                child: AdvertiseAppendDialogWidget(
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
                  padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 16)),
                  textStyle: WidgetStateProperty.all(
                      Theme.of(context).textTheme.labelMedium),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
                ),
              ),
            ],
          ),
        ),
        BlocConsumer<AdvertiseTableCubit, AdvertiseTableState>(
          listener: (context, state) {
            if (state is AdvertiseTableError) {
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
                        title: "خطا در دریافت تبلیغ ها",
                        message: state.error,
                      );
                    });
              }
            } else if (state is AdvertiseTableSuccess) {
              _dataGrid.buildDataGridRows(advertise: state.data.results ?? []);
            }
          },
          builder: (context, state) {
            if (state is AdvertiseTableSuccess) {
              if (_dataGrid.rows.isNotEmpty) {
                return Expanded(child: table());
              } else {
                return Expanded(
                    child: Center(
                  child: Text(
                    "تبلیغی وجود ندارد",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ));
              }
            } else if (state is AdvertiseTableLoading) {
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
            } else if (state is AdvertiseTableError) {
              if (_dataGrid.rows.isEmpty) {
                return Expanded(child: _error(state.error));
              } else {
                return Expanded(child: table());
              }
            }
            return Expanded(child: _error(null));
          },
        ),
        BlocBuilder<AdvertiseTableCubit, AdvertiseTableState>(
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
                            if (BlocProvider.of<AdvertiseTableCubit>(context)
                                .state is! AdvertiseTableLoading) {
                              BlocProvider.of<AdvertiseTableCubit>(context)
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
              width: max(125, width / 1000 * 125),
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
                  child: Text('تبلیغ',
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
              minimumWidth: max(125, width / 1000 * 125),
              columnName: 'mustPlayed',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('پخش درخواستی',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              minimumWidth: max(125, width / 1000 * 125),
              columnName: 'viewNumber',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('تعداد پخش',
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
                  BlocProvider.of<AdvertiseTableCubit>(context).getData();
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
