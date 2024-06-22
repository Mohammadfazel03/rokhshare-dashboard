import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/first_screen_slider/entity/slider_data_grid.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/first_screen_slider/bloc/first_screen_slider_cubit.dart';
import 'package:dashboard/feature/login/presentation/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class FirstScreenSliderWidget extends StatefulWidget {
  const FirstScreenSliderWidget({super.key});

  @override
  State<FirstScreenSliderWidget> createState() =>
      _FirstScreenSliderWidgetState();
}

class _FirstScreenSliderWidgetState extends State<FirstScreenSliderWidget> {
  late final SliderDataGrid _sliderDataGrid;

  @override
  void initState() {
    _sliderDataGrid = SliderDataGrid(context: context);
    BlocProvider.of<FirstScreenSliderCubit>(context).getData();
    super.initState();
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
            "صفحه اول",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        BlocConsumer<FirstScreenSliderCubit, FirstScreenSliderState>(
          listener: (context, state) {
            if (state is FirstScreenSliderError) {
              if (state.code == 403) {
                getIt.get<LocalStorageService>().logout();
                context.go(RoutePath.login.path);
              }
              if (_sliderDataGrid.rows.isNotEmpty) {
                toastification.showCustom(
                    animationDuration: Duration(milliseconds: 300),
                    context: context,
                    alignment: Alignment.bottomRight,
                    autoCloseDuration: const Duration(seconds: 4),
                    direction: TextDirection.rtl,
                    builder: (BuildContext context, ToastificationItem holder) {
                      return CustomSnackBar(
                        item: holder,
                        title: "خطا در دریافت کاربران اخیر",
                        message: state.error,
                      );
                    });
              }
            } else if (state is FirstScreenSliderSuccessful) {
              _sliderDataGrid.buildDataGridRows(sliders: state.data);
            }
          },
          builder: (context, state) {
            if (state is FirstScreenSliderSuccessful) {
              if (_sliderDataGrid.rows.isNotEmpty) {
                return Expanded(child: sliderTable());
              } else {
                return Expanded(
                    child: Center(
                  child: Text(
                    "فیلمی برای نمایش صفحه اول وجود ندارد.",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ));
              }
            } else if (state is FirstScreenSliderLoading) {
              if (_sliderDataGrid.rows.isEmpty) {
                return Expanded(
                    child: Center(
                        child: SpinKitThreeBounce(
                  color: CustomColor.loginBackgroundColor.getColor(context),
                )));
              } else {
                return Expanded(child: sliderTable());
              }
            } else if (state is FirstScreenSliderError) {
              if (_sliderDataGrid.rows.isEmpty) {
                return Expanded(child: _error(state.error));
              } else {
                return Expanded(child: sliderTable());
              }
            }
            return Expanded(child: _error(null));
          },
        ),
      ],
    );
  }

  Widget sliderTable() {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          headerColor: Theme.of(context).colorScheme.primary,
          gridLineColor: Theme.of(context).dividerColor),
      child: SfDataGrid(
          source: _sliderDataGrid,
          isScrollbarAlwaysShown: true,
          rowHeight: 150,
          onQueryRowHeight: (RowHeightDetails details) {
            var descriptionHeight = details.getIntrinsicRowHeight(
                details.rowIndex,
                excludedColumns: ['title', 'media', 'priority']);
            if (descriptionHeight > details.rowHeight) {
              return descriptionHeight;
            }
            return details.rowHeight;
          },
          columnWidthMode: ColumnWidthMode.lastColumnFill,
          gridLinesVisibility: GridLinesVisibility.vertical,
          headerGridLinesVisibility: GridLinesVisibility.none,
          columns: <GridColumn>[
            GridColumn(
                minimumWidth: 40,
                columnName: 'priority',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('الویت',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                minimumWidth: 140,
                columnName: 'media',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('فیلم',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                minimumWidth: 100,
                columnName: 'title',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('عنوان',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                minimumWidth: 200,
                columnName: 'description',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('توضیحات',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
          ]),
    );
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
            SizedBox(height: 8),
            OutlinedButton(
                onPressed: () {
                  BlocProvider.of<FirstScreenSliderCubit>(context).getData();
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
