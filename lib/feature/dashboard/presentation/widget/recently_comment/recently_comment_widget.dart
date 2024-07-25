import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/recently_comment/entity/comment_data_grid.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/recently_comment/bloc/recently_comment_cubit.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:toastification/toastification.dart';

class RecentlyCommentWidget extends StatefulWidget {
  const RecentlyCommentWidget({super.key});

  @override
  State<RecentlyCommentWidget> createState() => _RecentlyCommentWidgetState();
}

class _RecentlyCommentWidgetState extends State<RecentlyCommentWidget> {
  late final CommentDataGrid _commentDataGrid;

  // late final CustomGridColumnSizer _gridColumnSizer;

  @override
  void initState() {
    // _gridColumnSizer = CustomGridColumnSizer();
    _commentDataGrid = CommentDataGrid(context: context);
    BlocProvider.of<RecentlyCommentCubit>(context).getData();
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
            "نظرات اخیر",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        BlocConsumer<RecentlyCommentCubit, RecentlyCommentState>(
          listener: (context, state) {
            if (state is RecentlyCommentError) {
              if (state.code == 403) {
                getIt.get<LocalStorageService>().logout();
                context.go(RoutePath.login.fullPath);
              }
              if (_commentDataGrid.rows.isNotEmpty) {
                toastification.showCustom(
                    animationDuration: const Duration(milliseconds: 300),
                    context: context,
                    alignment: Alignment.bottomRight,
                    autoCloseDuration: const Duration(seconds: 4),
                    direction: TextDirection.rtl,
                    builder: (BuildContext context, ToastificationItem holder) {
                      return ErrorSnackBarWidget(
                        item: holder,
                        title: "خطا در دریافت نظرات اخیر",
                        message: state.error,
                      );
                    });
              }
            } else if (state is RecentlyCommentSuccessful) {
              _commentDataGrid.buildDataGridRows(comments: state.data);
            }
          },
          builder: (context, state) {
            if (state is RecentlyCommentSuccessful) {
              if (_commentDataGrid.rows.isNotEmpty) {
                return Expanded(child: commentTable());
              } else {
                return Expanded(
                    child: Center(
                  child: Text(
                    "نظری وجود ندارد.",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ));
              }
            } else if (state is RecentlyCommentLoading) {
              if (_commentDataGrid.rows.isEmpty) {
                return Expanded(
                    child: Center(
                        child: RepaintBoundary(
              child: SpinKitThreeBounce(
                  color: CustomColor.loginBackgroundColor.getColor(context),
                ))));
              } else {
                return Expanded(child: commentTable());
              }
            } else if (state is RecentlyCommentError) {
              if (_commentDataGrid.rows.isEmpty) {
                return Expanded(child: _error(state.error));
              } else {
                return Expanded(child: commentTable());
              }
            }
            return Expanded(child: _error(null));
          },
        ),
      ],
    );
  }

  Widget commentTable() {
    return SfDataGrid(
        source: _commentDataGrid,
        isScrollbarAlwaysShown: true,
        // columnSizer: _gridColumnSizer,
        rowHeight: 150,
        onQueryRowHeight: (RowHeightDetails details) {
          var commentHeight = details.getIntrinsicRowHeight(details.rowIndex,
              excludedColumns: ['username', 'media', 'date', 'status']);
          if (commentHeight > details.rowHeight) {
            return commentHeight;
          }
          return details.rowHeight;
        },
        gridLinesVisibility: GridLinesVisibility.vertical,
        headerGridLinesVisibility: GridLinesVisibility.none,
        columns: <GridColumn>[
          GridColumn(
              minimumWidth: 140,
              columnName: 'username',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('کاربر',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 140,
              columnName: 'media',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('فیلم',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer)))),
          GridColumn(
              columnWidthMode: ColumnWidthMode.lastColumnFill,
              minimumWidth: 400,
              columnName: 'comment',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('نظر',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 140,
              columnName: 'date',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('تاریخ',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 140,
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
                  BlocProvider.of<RecentlyCommentCubit>(context).getData();
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
