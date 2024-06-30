import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/recently_advertise/entity/ads_data_grid.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/recently_advertise/bloc/recently_advertise_cubit.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:toastification/toastification.dart';

class RecentlyAdvertiseWidget extends StatefulWidget {
  const RecentlyAdvertiseWidget({super.key});

  @override
  State<RecentlyAdvertiseWidget> createState() =>
      _RecentlyAdvertiseWidgetState();
}

class _RecentlyAdvertiseWidgetState extends State<RecentlyAdvertiseWidget> {
  late final AdsDataGrid _adsDataGrid;

  @override
  void initState() {
    _adsDataGrid = AdsDataGrid(context: context);
    BlocProvider.of<RecentlyAdvertiseCubit>(context).getData();

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
            "آگهی های اخیر",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        BlocConsumer<RecentlyAdvertiseCubit, RecentlyAdvertiseState>(
          listener: (context, state) {
            if (state is RecentlyAdvertiseError) {
              if (state.code == 403) {
                getIt.get<LocalStorageService>().logout();
                context.go(RoutePath.login.fullPath);
              }
              if (_adsDataGrid.rows.isNotEmpty) {
                toastification.showCustom(
                    animationDuration: Duration(milliseconds: 300),
                    context: context,
                    alignment: Alignment.bottomRight,
                    autoCloseDuration: const Duration(seconds: 4),
                    direction: TextDirection.rtl,
                    builder: (BuildContext context, ToastificationItem holder) {
                      return ErrorSnackBarWidget(
                        item: holder,
                        title: "خطا در دریافت آگهی های اخیر",
                        message: state.error,
                      );
                    });
              }
            } else if (state is RecentlyAdvertiseSuccessful) {
              _adsDataGrid.buildDataGridRows(ads: state.data);
            }
          },
          builder: (context, state) {
            if (state is RecentlyAdvertiseSuccessful) {
              if (_adsDataGrid.rows.isNotEmpty) {
                return Expanded(child: adsTable());
              } else {
                return Expanded(
                    child: Center(
                  child: Text(
                    "آگهی وجود ندارد.",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ));
              }
            } else if (state is RecentlyAdvertiseLoading) {
              if (_adsDataGrid.rows.isEmpty) {
                return Expanded(
                    child: Center(
                        child: SpinKitThreeBounce(
                  color: CustomColor.loginBackgroundColor.getColor(context),
                )));
              } else {
                return Expanded(child: adsTable());
              }
            } else if (state is RecentlyAdvertiseError) {
              if (_adsDataGrid.rows.isEmpty) {
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
                  BlocProvider.of<RecentlyAdvertiseCubit>(context).getData();
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

  Widget adsTable() {
    return SfDataGrid(
        source: _adsDataGrid,
        isScrollbarAlwaysShown: true,
        rowHeight: 150,
        onQueryRowHeight: (RowHeightDetails details) {
          return details.rowHeight;
        },
        columnWidthMode: ColumnWidthMode.lastColumnFill,
        gridLinesVisibility: GridLinesVisibility.vertical,
        headerGridLinesVisibility: GridLinesVisibility.none,
        columns: <GridColumn>[
          GridColumn(
              minimumWidth: 100,
              columnName: 'title',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('عنوان',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall))),
          GridColumn(
              minimumWidth: 140,
              columnName: 'createdAt',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('تاریخ ثبت',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall))),
          GridColumn(
              minimumWidth: 40,
              columnName: 'viewNumber',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('تماشا شده',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall))),
          GridColumn(
              minimumWidth: 40,
              columnName: 'mustPlayed',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('تعداد کل شفارش',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall))),
        ]);
  }
}
