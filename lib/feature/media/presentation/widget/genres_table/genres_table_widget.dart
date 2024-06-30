import 'dart:math';
import 'package:dashboard/common/paginator_widget/pagination_widget.dart';
import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/media/presentation/widget/genres_table/bloc/genre_append_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/genres_table/genre_append_dialog_widget.dart';
import 'package:dashboard/feature/media/presentation/widget/genres_table/bloc/genres_table_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/genres_table/entity/genre_data_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:toastification/toastification.dart';

class GenresTableWidget extends StatefulWidget {
  const GenresTableWidget({super.key});

  @override
  State<GenresTableWidget> createState() => _GenresTableWidgetState();
}

class _GenresTableWidgetState extends State<GenresTableWidget> {
  late final GenreDataGrid _dataGrid;

  @override
  void initState() {
    _dataGrid = GenreDataGrid(
        context: context, cubit: BlocProvider.of<GenresTableCubit>(context));
    BlocProvider.of<GenresTableCubit>(context).getData();

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
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "ژانر ها",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              FilledButton.tonalIcon(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return Dialog(
                          clipBehavior: Clip.hardEdge,
                          child: SizedBox(
                              width: min(
                                  MediaQuery.sizeOf(context).width * 0.8,
                                  560),
                              child: MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(
                                      value:
                                          BlocProvider.of<GenresTableCubit>(
                                              context)),
                                  BlocProvider<GenreAppendCubit>(
                                      create: (context) => GenreAppendCubit(
                                          repository: getIt.get())),
                                ],
                                child: GenreAppendDialogWidget(
                                    width: min(
                                        MediaQuery.sizeOf(context).width *
                                            0.8,
                                        560)),
                              )),
                        );
                      });
                },
                label: Text(
                  "ژانر جدید",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontSize: 12),
                ),
                icon: Icon(Icons.add),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.primary),
                  padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
                ),
              )
            ],
          ),
        ),
        BlocConsumer<GenresTableCubit, GenresTableState>(
          listener: (context, state) {
            if (state is GenresTableError) {
              if (state.code == 403) {
                getIt.get<LocalStorageService>().logout();
                context.go(RoutePath.login.fullPath);
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
                        title: state.title,
                        message: state.error,
                      );
                    });
              }
            } else if (state is GenresTableSuccess) {
              _dataGrid.buildDataGridRows(genres: state.data.results ?? []);
            }
          },
          builder: (context, state) {
            if (state is GenresTableSuccess) {
              if (_dataGrid.rows.isNotEmpty) {
                return Expanded(child: table());
              } else {
                return Expanded(
                    child: Center(
                  child: Text(
                    "ژانری وجود ندارد",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ));
              }
            } else if (state is GenresTableLoading) {
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
            } else if (state is GenresTableError) {
              if (_dataGrid.rows.isEmpty) {
                return Expanded(child: _error(state.error));
              } else {
                return Expanded(child: table());
              }
            }
            return Expanded(child: _error(null));
          },
        ),
        BlocBuilder<GenresTableCubit, GenresTableState>(
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
                            if (BlocProvider.of<GenresTableCubit>(context).state
                                is! GenresTableLoading) {
                              BlocProvider.of<GenresTableCubit>(context)
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
    return SfDataGrid(
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
              minimumWidth: 180,
              columnName: 'name',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('عنوان',
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
            SizedBox(height: 8),
            OutlinedButton(
                onPressed: () {
                  BlocProvider.of<GenresTableCubit>(context).getData();
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
