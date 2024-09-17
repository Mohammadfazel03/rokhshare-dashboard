import 'package:dashboard/common/paginator_widget/pagination_widget.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/recently_user/bloc/recently_user_cubit.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/recently_user/entity/user_data_grid.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:toastification/toastification.dart';

class RecentlyUserWidget extends StatefulWidget {
  final bool hasPagination;

  const RecentlyUserWidget({super.key, this.hasPagination = false});

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
  void dispose() {
    _userDataGrid.dispose();
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
            "کاربران فعال اخیر",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        BlocConsumer<RecentlyUserCubit, RecentlyUserState>(
          listener: (context, state) {
            if (state is RecentlyUserError) {
              if (_userDataGrid.rows.isNotEmpty) {
                toastification.showCustom(
                    animationDuration: const Duration(milliseconds: 300),
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
              _userDataGrid.buildDataGridRows(users: state.data.results ?? []);
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
                        child: RepaintBoundary(
                            child: SpinKitThreeBounce(
                  color: CustomColor.loginBackgroundColor.getColor(context),
                ))));
              } else {
                return Expanded(
                    child: Stack(
                  children: [
                    Positioned.fill(child: userTable()),
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
        if (widget.hasPagination) ...[
          BlocBuilder<RecentlyUserCubit, RecentlyUserState>(
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
                              if (BlocProvider.of<RecentlyUserCubit>(context)
                                  .state is! RecentlyUserLoading) {
                                BlocProvider.of<RecentlyUserCubit>(context)
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
        ]
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
            const SizedBox(height: 8),
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
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 150,
              columnName: 'name',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('نام',
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
                  child: Text('وضعیت اشتراک',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 150,
              columnName: 'movieViewed',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('تعداد تماشا',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 150,
              columnName: 'date',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('تاریخ عضویت',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
        ]);
  }
}
