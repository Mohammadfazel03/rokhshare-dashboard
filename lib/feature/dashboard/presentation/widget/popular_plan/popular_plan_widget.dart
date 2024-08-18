import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/popular_plan/bloc/popular_plan_cubit.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/popular_plan/entity/plan_data_grid.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:toastification/toastification.dart';

class PopularPlanWidget extends StatefulWidget {
  const PopularPlanWidget({super.key});

  @override
  State<PopularPlanWidget> createState() => _PopularPlanWidgetState();
}

class _PopularPlanWidgetState extends State<PopularPlanWidget> {
  late final PlanDataGrid _planDataGrid;

  @override
  void initState() {
    _planDataGrid = PlanDataGrid(context: context);
    BlocProvider.of<PopularPlanCubit>(context).getData();
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
          child: Text(
            "طرح های محبوب",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        BlocConsumer<PopularPlanCubit, PopularPlanState>(
          listener: (context, state) {
            if (state is PopularPlanError) {
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
                        title: "خطا در دریافت طرح های محبوب",
                        message: state.error,
                      );
                    });
              }
            } else if (state is PopularPlanSuccessful) {
              _planDataGrid.buildDataGridRows(plans: state.data);
            }
          },
          builder: (context, state) {
            if (state is PopularPlanSuccessful) {
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
            } else if (state is PopularPlanLoading) {
              if (_planDataGrid.rows.isEmpty) {
                return Expanded(
                    child: Center(
                        child: RepaintBoundary(
              child: SpinKitThreeBounce(
                  color: CustomColor.loginBackgroundColor.getColor(context),
                ))));
              } else {
                return Expanded(child: planTable());
              }
            } else if (state is PopularPlanError) {
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
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 100,
              columnName: 'time',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('مدت زمان',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 150,
              columnName: 'price',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('قیمت',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 150,
              columnName: 'status',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('وضعیت',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer)))),
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
                  BlocProvider.of<PopularPlanCubit>(context).getData();
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
