import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/recently_user/entity/user_data_grid.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/recently_user/bloc/recently_user_cubit.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:toastification/toastification.dart';

class RecentlyUserWidget extends StatefulWidget {
  const RecentlyUserWidget({super.key});

  @override
  State<RecentlyUserWidget> createState() => _RecentlyUserWidgetState();
}

class _RecentlyUserWidgetState extends State<RecentlyUserWidget> {
  late final UserDataGrid _userDataGrid;

  @override
  void initState() {
    _userDataGrid = UserDataGrid(context: context);
    BlocProvider.of<RecentlyUserCubit>(context).getData();
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
            "کاربران فعال اخیر",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        BlocConsumer<RecentlyUserCubit, RecentlyUserState>(
          listener: (context, state) {
            if (state is RecentlyUserError) {
              if (state.code == 403) {
                getIt.get<LocalStorageService>().logout();
                context.go(RoutePath.login.fullPath);
              }
              if (_userDataGrid.rows.isNotEmpty) {
                toastification.showCustom(
                    animationDuration: Duration(milliseconds: 300),
                    context: context,
                    alignment: Alignment.bottomRight,
                    autoCloseDuration: const Duration(seconds: 4),
                    direction: TextDirection.rtl,
                    builder: (BuildContext context, ToastificationItem holder) {
                      return ErrorSnackBarWidget(
                        item: holder,
                        title: "خطا در دریافت کاربران اخیر",
                        message: state.error,
                      );
                    });
              }
            } else if (state is RecentlyUserSuccess) {
              _userDataGrid.buildDataGridRows(users: state.data);
            }
          },
          builder: (context, state) {
            if (state is RecentlyUserSuccess) {
              if (_userDataGrid.rows.isNotEmpty) {
                return Expanded(child: userTable());
              } else {
                return Expanded(
                    child: Center(
                  child: Text(
                    "کاربری وجود ندارد.",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ));
              }
            } else if (state is RecentlyUserLoading) {
              if (_userDataGrid.rows.isEmpty) {
                return Expanded(
                    child: Center(
                        child: SpinKitThreeBounce(
                  color: CustomColor.loginBackgroundColor.getColor(context),
                )));
              } else {
                return Expanded(child: userTable());
              }
            } else if (state is RecentlyUserError) {
              if (_userDataGrid.rows.isEmpty) {
                return Expanded(child: _error(state.error));
              } else {
                return Expanded(child: userTable());
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
                  BlocProvider.of<RecentlyUserCubit>(context).getData();
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

  Widget userTable() {
    return SfDataGrid(
        source: _userDataGrid,
        columnWidthMode: ColumnWidthMode.fill,
        isScrollbarAlwaysShown: true,
        gridLinesVisibility: GridLinesVisibility.none,
        headerGridLinesVisibility: GridLinesVisibility.none,
        columns: <GridColumn>[
          GridColumn(
              minimumWidth: 150,
              columnName: 'username',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('نام کاربری',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 150,
              columnName: 'name',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('نام',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 150,
              columnName: 'status',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('وضعیت اشتراک',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 150,
              columnName: 'movieViewed',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('تعداد تماشا',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 150,
              columnName: 'date',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('تاریخ عضویت',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer)))),
        ]);
  }
}
