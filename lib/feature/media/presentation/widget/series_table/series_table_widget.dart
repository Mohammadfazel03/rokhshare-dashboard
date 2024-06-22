import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/media/presentation/widget/series_table/bloc/series_table_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/series_table/entity/series_data_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:toastification/toastification.dart';

class SeriesTableWidget extends StatefulWidget {
  const SeriesTableWidget({super.key});

  @override
  State<SeriesTableWidget> createState() => _SeriesTableWidgetState();
}

class _SeriesTableWidgetState extends State<SeriesTableWidget> {
  late final SeriesDataGrid _dataGrid;

  @override
  void initState() {
    _dataGrid = SeriesDataGrid(context: context);
    BlocProvider.of<SeriesTableCubit>(context).getData();

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
            "سریال ها",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        BlocConsumer<SeriesTableCubit, SeriesTableState>(
          listener: (context, state) {
            if (state is SeriesTableError) {
              if (state.code == 403) {
                getIt.get<LocalStorageService>().logout();
                context.go(RoutePath.login.path);
              }
              if (_dataGrid.rows.isNotEmpty) {
                toastification.showCustom(
                    animationDuration: Duration(milliseconds: 300),
                    context: context,
                    alignment: Alignment.bottomRight,
                    autoCloseDuration: const Duration(seconds: 4),
                    direction: TextDirection.rtl,
                    builder: (BuildContext context, ToastificationItem holder) {
                      return ErrorSnackBarWidget(
                        item: holder,
                        title: "خطا در دریافت سریال ها",
                        message: state.error,
                      );
                    });
              }
            } else if (state is SeriesTableSuccess) {
              _dataGrid.buildDataGridRows(series: state.data.results ?? []);
            }
          },
          builder: (context, state) {
            if (state is SeriesTableSuccess) {
              if (_dataGrid.rows.isNotEmpty) {
                return Expanded(child: table());
              } else {
                return Expanded(
                    child: Center(
                  child: Text(
                    "سریالی وجود ندارد",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ));
              }
            } else if (state is SeriesTableLoading) {
              if (_dataGrid.rows.isEmpty) {
                return Expanded(
                    child: Center(
                        child: SpinKitThreeBounce(
                  color: CustomColor.loginBackgroundColor.getColor(context),
                )));
              } else {
                return Expanded(child: table());
              }
            } else if (state is SeriesTableError) {
              if (_dataGrid.rows.isEmpty) {
                return Expanded(child: _error(state.error));
              } else {
                return Expanded(child: table());
              }
            }
            return Expanded(child: _error(null));
          },
        ),
      ],
    );
  }

  Widget table() {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          headerColor: Theme.of(context).colorScheme.primary,
          gridLineColor: Theme.of(context).dividerColor),
      child: SfDataGrid(
          highlightRowOnHover: false,
          source: _dataGrid,
          isScrollbarAlwaysShown: true,
          rowHeight: 48,
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
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                maximumWidth: 180,
                minimumWidth: 180,
                columnName: 'name',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('عنوان',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                maximumWidth: 80,
                minimumWidth: 80,
                columnName: 'seasonNumber',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('تعداد فصل',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                maximumWidth: 80,
                minimumWidth: 80,
                columnName: 'episodeNumber',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('تعداد قسمت',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                maximumWidth: 180,
                minimumWidth: 180,
                columnName: 'genres',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('ژانر',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                maximumWidth: 180,
                minimumWidth: 180,
                columnName: 'countries',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('کشور سازنده',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                maximumWidth: 120,
                minimumWidth: 120,
                columnName: 'releaseDate',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('زمان انتشار',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                maximumWidth: 120,
                minimumWidth: 120,
                columnName: 'value',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('ارزش',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                minimumWidth: 140,
                columnName: 'actions',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('عملیات ها',
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
                  BlocProvider.of<SeriesTableCubit>(context).getData();
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