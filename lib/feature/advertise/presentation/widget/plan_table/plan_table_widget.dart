import 'dart:math';

import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/advertise/presentation/widget/plan_table/bloc/plan_append_cubit.dart';
import 'package:dashboard/feature/advertise/presentation/widget/plan_table/bloc/plan_table_cubit.dart';
import 'package:dashboard/feature/advertise/presentation/widget/plan_table/entity/plan_data_grid.dart';
import 'package:dashboard/feature/advertise/presentation/widget/plan_table/plan_append_dialog_widget.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:toastification/toastification.dart';

class PlanTableWidget extends StatefulWidget {
  const PlanTableWidget({super.key});

  @override
  State<PlanTableWidget> createState() => _PlanTableWidgetState();
}

class _PlanTableWidgetState extends State<PlanTableWidget> {
  late final PlanDataGrid _planDataGrid;

  @override
  void initState() {
    _planDataGrid = PlanDataGrid(
        context: context, cubit: BlocProvider.of<PlanTableCubit>(context));
    BlocProvider.of<PlanTableCubit>(context).getData();
    super.initState();
  }

  @override
  void dispose() {
    _planDataGrid.dispose();
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
                "طرح ها",
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
                                      value: BlocProvider.of<PlanTableCubit>(
                                          context)),
                                  BlocProvider<PlanAppendCubit>(
                                      create: (context) => PlanAppendCubit(
                                          repository: getIt.get())),
                                ],
                                child: PlanAppendDialogWidget(
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
        BlocConsumer<PlanTableCubit, PlanTableState>(
          listener: (context, state) {
            if (state is PlanTableError) {
              if (_planDataGrid.rows.isNotEmpty) {
                toastification.showCustom(
                    animationDuration: const Duration(milliseconds: 300),
                    context: context,
                    alignment: Alignment.bottomRight,
                    autoCloseDuration: const Duration(seconds: 4),
                    direction: TextDirection.rtl,
                    builder: (BuildContext context, ToastificationItem holder) {
                      return ErrorSnackBarWidget(
                        item: holder,
                        title: "خطا در دریافت طرح ها",
                        message: state.error,
                      );
                    });
              }
            } else if (state is PlanTableSuccess) {
              _planDataGrid.buildDataGridRows(plans: state.data.results ?? []);
            }
          },
          builder: (context, state) {
            if (state is PlanTableSuccess) {
              if (_planDataGrid.rows.isNotEmpty) {
                return Expanded(child: planTable());
              } else {
                return Expanded(
                    child: Center(
                  child: Text(
                    "طرحی وجود ندارد.",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ));
              }
            } else if (state is PlanTableLoading) {
              if (_planDataGrid.rows.isEmpty) {
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
                    Positioned.fill(
                        child: Container(
                      color: Colors.black12,
                      child: Center(
                          child: RepaintBoundary(
                              child: SpinKitThreeBounce(
                        color:
                            CustomColor.loginBackgroundColor.getColor(context),
                      ))),
                    )),
                    Positioned.fill(child: planTable()),
                  ],
                ));
              }
            } else if (state is PlanTableError) {
              if (_planDataGrid.rows.isEmpty) {
                return Expanded(child: _error(state.error));
              } else {
                return Expanded(child: planTable());
              }
            }
            return Expanded(child: _error(null));
          },
        ),
      ],
    );
  }

  Widget planTable() {
    return SfDataGrid(
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
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 100,
              columnName: 'time',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('مدت زمان',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 150,
              columnName: 'price',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('قیمت',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 150,
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
                  BlocProvider.of<PlanTableCubit>(context).getData();
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
