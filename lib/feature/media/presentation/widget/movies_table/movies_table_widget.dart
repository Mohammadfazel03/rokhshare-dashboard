import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/login/presentation/widget/custom_snackbar.dart';
import 'package:dashboard/feature/media/presentation/entities/movie_data_grid.dart';
import 'package:dashboard/feature/media/presentation/widget/movies_table/bloc/movies_table_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:toastification/toastification.dart';

class MoviesTableWidget extends StatefulWidget {
  const MoviesTableWidget({super.key});

  @override
  State<MoviesTableWidget> createState() => _MoviesTableWidgetState();
}

class _MoviesTableWidgetState extends State<MoviesTableWidget> {
  late final MovieDataGrid _dataGrid;

  @override
  void initState() {
    _dataGrid = MovieDataGrid(context: context);
    BlocProvider.of<MoviesTableCubit>(context).getData();

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
            "فیلم ها",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        BlocConsumer<MoviesTableCubit, MoviesTableState>(
          listener: (context, state) {
            if (state is MoviesTableError) {
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
                      return CustomSnackBar(
                        item: holder,
                        title: "خطا در دریافت کاربران اخیر",
                        message: state.error,
                      );
                    });
              }
            } else if (state is MoviesTableSuccess) {
              _dataGrid.buildDataGridRows(movie: state.data.results ?? []);
            }
          },
          builder: (context, state) {
            if (state is MoviesTableSuccess) {
              if (_dataGrid.rows.isNotEmpty) {
                return Expanded(child: adsTable());
              } else {
                return Expanded(
                    child: Center(
                  child: Text(
                    "فیلمی وجود ندارد",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ));
              }
            } else if (state is MoviesTableLoading) {
              if (_dataGrid.rows.isEmpty) {
                return Expanded(
                    child: Center(
                        child: SpinKitThreeBounce(
                  color: CustomColor.loginBackgroundColor.getColor(context),
                )));
              } else {
                return Expanded(child: adsTable());
              }
            } else if (state is MoviesTableError) {
              if (_dataGrid.rows.isEmpty) {
                return Expanded(child: _error(state.error));
              } else {
                return Expanded(child: adsTable());
              }
            }
            return Expanded(child: _error(null));
          },
        ),
      ],
    );
  }

  Widget adsTable() {
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
                maximumWidth: 200,
                minimumWidth: 200,
                columnName: 'name',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('عنوان',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                maximumWidth: 200,
                minimumWidth: 200,
                columnName: 'genres',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('ژانر',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                maximumWidth: 200,
                minimumWidth: 200,
                columnName: 'countries',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('کشور سازنده',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                maximumWidth: 150,
                minimumWidth: 150,
                columnName: 'releaseDate',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('زمان انتشار',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                maximumWidth: 150,
                minimumWidth: 150,
                columnName: 'value',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('ارزش',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                minimumWidth: 180,
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
                  BlocProvider.of<MoviesTableCubit>(context).getData();
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
