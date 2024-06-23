import 'package:dashboard/common/paginator_widget/pagination_widget.dart';
import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/media/presentation/widget/country_table/bloc/countries_table_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/country_table/entity/country_data_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:toastification/toastification.dart';

class CountriesTableWidget extends StatefulWidget {
  const CountriesTableWidget({super.key});

  @override
  State<CountriesTableWidget> createState() => _CountriesTableWidgetState();
}

class _CountriesTableWidgetState extends State<CountriesTableWidget> {
  late final CountryDataGrid _dataGrid;

  @override
  void initState() {
    _dataGrid = CountryDataGrid(context: context);
    BlocProvider.of<CountriesTableCubit>(context).getData();

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
            "کشور ها",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        BlocConsumer<CountriesTableCubit, CountriesTableState>(
          listener: (context, state) {
            if (state is CountriesTableError) {
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
                        title: "خطا در دریافت کشور ها",
                        message: state.error,
                      );
                    });
              }
            } else if (state is CountriesTableSuccess) {
              _dataGrid.buildDataGridRows(series: state.data.results ?? []);
            }
          },
          builder: (context, state) {
            if (state is CountriesTableSuccess) {
              if (_dataGrid.rows.isNotEmpty) {
                return Expanded(child: table());
              } else {
                return Expanded(
                    child: Center(
                  child: Text(
                    "کشوری وجود ندارد",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ));
              }
            } else if (state is CountriesTableLoading) {
              if (_dataGrid.rows.isEmpty) {
                return Expanded(
                    child: Center(
                        child: SpinKitThreeBounce(
                  color: CustomColor.loginBackgroundColor.getColor(context),
                )));
              } else {
                return Expanded(
                    child: Stack(
                  children: [
                    Positioned.fill(child: table()),
                    Positioned.fill(
                        child: Container(
                      color: Colors.black12,
                      child: Center(
                          child: SpinKitThreeBounce(
                        color:
                            CustomColor.loginBackgroundColor.getColor(context),
                      )),
                    ))
                  ],
                ));
              }
            } else if (state is CountriesTableError) {
              if (_dataGrid.rows.isEmpty) {
                return Expanded(child: _error(state.error));
              } else {
                return Expanded(child: table());
              }
            }
            return Expanded(child: _error(null));
          },
        ),
        BlocBuilder<CountriesTableCubit, CountriesTableState>(
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
                            if (BlocProvider.of<CountriesTableCubit>(context).state
                                is! CountriesTableLoading) {
                              BlocProvider.of<CountriesTableCubit>(context)
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
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          headerColor: Theme.of(context).colorScheme.primary,
          gridLineColor: Theme.of(context).dividerColor),
      child: SfDataGrid(
          highlightRowOnHover: false,
          source: _dataGrid,
          isScrollbarAlwaysShown: true,
          rowHeight: 56,
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
                        style: Theme.of(context).textTheme.titleSmall))),
            GridColumn(
                minimumWidth: 220,
                columnName: 'country',
                label: Container(
                    alignment: Alignment.center,
                    child: Text('کشور',
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
                  BlocProvider.of<CountriesTableCubit>(context).getData();
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