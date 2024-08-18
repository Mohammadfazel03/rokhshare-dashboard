import 'package:dashboard/common/paginator_widget/pagination_widget.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/dashboard/presentation/common/custom_grid_column_sizer.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/comment_table_widget/bloc/comment_table_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/comment_table_widget/entity/comment_data_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:toastification/toastification.dart';

class CommentTableWidget extends StatefulWidget {
  final int mediaId;

  const CommentTableWidget({super.key, required this.mediaId});

  @override
  State<CommentTableWidget> createState() => _CommentTableWidgetState();
}

class _CommentTableWidgetState extends State<CommentTableWidget> {
  late final CommentDataGrid _dataGrid;
  late final CustomGridColumnSizer _gridColumnSizer;

  @override
  void initState() {
    _gridColumnSizer = CustomGridColumnSizer(context: context);
    _dataGrid = CommentDataGrid(
        context: context,
        cubit: BlocProvider.of<CommentTableCubit>(context),
        mediaId: widget.mediaId);
    BlocProvider.of<CommentTableCubit>(context)
        .getData(mediaId: widget.mediaId);

    super.initState();
  }

  @override
  void dispose() {
    _dataGrid.dispose();
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
            "نظرات",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        BlocConsumer<CommentTableCubit, CommentTableState>(
          listener: (context, state) {
            if (state is CommentTableError) {
              if (_dataGrid.rows.isNotEmpty) {
                toastification.showCustom(
                    animationDuration: const Duration(milliseconds: 300),
                    context: context,
                    alignment: Alignment.bottomRight,
                    autoCloseDuration: const Duration(seconds: 4),
                    direction: TextDirection.rtl,
                    builder: (BuildContext context, ToastificationItem holder) {
                      return ErrorSnackBarWidget(
                        item: holder,
                        title: state.title ?? "خطا در دریافت نظرات",
                        message: state.error,
                      );
                    });
              }
            } else if (state is CommentTableSuccess) {
              _dataGrid.buildDataGridRows(comments: state.data.results ?? []);
            }
          },
          builder: (context, state) {
            if (state is CommentTableSuccess) {
              if (_dataGrid.rows.isNotEmpty) {
                return Expanded(child: table());
              } else {
                return Expanded(
                    child: Center(
                  child: Text(
                    "نظری وجود ندارد",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ));
              }
            } else if (state is CommentTableLoading) {
              if (_dataGrid.rows.isEmpty) {
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
                    Positioned.fill(child: table()),
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
            } else if (state is CommentTableError) {
              if (_dataGrid.rows.isEmpty) {
                return Expanded(child: _error(state.error));
              } else {
                return Expanded(child: table());
              }
            }
            return Expanded(child: _error(null));
          },
        ),
        BlocBuilder<CommentTableCubit, CommentTableState>(
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
                            if (BlocProvider.of<CommentTableCubit>(context)
                                .state is! CommentTableLoading) {
                              BlocProvider.of<CommentTableCubit>(context)
                                  .getData(page: page, mediaId: widget.mediaId);
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
    return SfDataGrid(
        source: _dataGrid,
        isScrollbarAlwaysShown: true,
        columnSizer: _gridColumnSizer,
        // rowHeight: 150,
        onQueryRowHeight: (RowHeightDetails details) {
          var commentHeight = details.getIntrinsicRowHeight(details.rowIndex,
              excludedColumns: ['username', 'actions', 'date', 'status']);

          if (commentHeight > details.rowHeight) {
            return commentHeight;
          }
          return details.rowHeight;
        },
        gridLinesVisibility: GridLinesVisibility.none,
        headerGridLinesVisibility: GridLinesVisibility.none,
        columns: <GridColumn>[
          GridColumn(
              minimumWidth: 140,
              columnName: 'username',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('کاربر',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              columnWidthMode: ColumnWidthMode.lastColumnFill,
              minimumWidth: 200,
              columnName: 'comment',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('نظر',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 140,
              columnName: 'date',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('تاریخ',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 140,
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
              minimumWidth: 180,
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
                  BlocProvider.of<CommentTableCubit>(context)
                      .getData(mediaId: widget.mediaId);
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
