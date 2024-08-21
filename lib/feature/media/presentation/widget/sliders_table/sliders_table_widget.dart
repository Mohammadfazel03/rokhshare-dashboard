import 'dart:math';

import 'package:dashboard/common/paginator_widget/pagination_widget.dart';
import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/media/presentation/widget/sliders_table/bloc/slider_append_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/sliders_table/bloc/sliders_table_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/sliders_table/entity/slider_data_grid.dart';
import 'package:dashboard/feature/media/presentation/widget/sliders_table/slider_append_dialog_widget.dart';
import 'package:dashboard/feature/media_collection/presentation/widget/media_autocomplete_field/bloc/media_autocomplete_field_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/poster_section_widget/bloc/poster_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/synopsis_section_widget/bloc/synopsis_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/thumbnail_section_widget/bloc/thumbnail_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/title_section_widget/bloc/title_section_cubit.dart';
import 'package:dashboard/feature/season/presentation/widget/integer_field_widget/bloc/integer_field_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:toastification/toastification.dart';

class SlidersTableWidget extends StatefulWidget {
  const SlidersTableWidget({super.key});

  @override
  State<SlidersTableWidget> createState() => _SlidersTableWidgetState();
}

class _SlidersTableWidgetState extends State<SlidersTableWidget> {
  late final SliderDataGrid _dataGrid;

  @override
  void initState() {
    _dataGrid = SliderDataGrid(context: context);
    BlocProvider.of<SlidersTableCubit>(context).getData();

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
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "صفجه اول",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              FilledButton.icon(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return Dialog(
                          clipBehavior: Clip.hardEdge,
                          child: SizedBox(
                              width: min(
                                  MediaQuery.sizeOf(context).width * 0.8, 560),
                              child: MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(
                                      value: BlocProvider.of<SlidersTableCubit>(
                                          context)),
                                  BlocProvider<SliderAppendCubit>(
                                      create: (context) => SliderAppendCubit(
                                          repository: getIt.get())),
                                  BlocProvider<TitleSectionCubit>(
                                      create: (context) => TitleSectionCubit()),
                                  BlocProvider<SynopsisSectionCubit>(
                                      create: (context) =>
                                          SynopsisSectionCubit()),
                                  BlocProvider<ThumbnailSectionCubit>(
                                      create: (context) =>
                                          ThumbnailSectionCubit()),
                                  BlocProvider<PosterSectionCubit>(
                                      create: (context) =>
                                          PosterSectionCubit()),
                                  BlocProvider<IntegerFieldCubit>(
                                      create: (context) => IntegerFieldCubit()),
                                  BlocProvider<MediaAutocompleteFieldCubit>(
                                      create: (context) =>
                                          MediaAutocompleteFieldCubit(
                                              repository: getIt.get())),
                                ],
                                child: SliderAppendDialogWidget(
                                    width: min(
                                        MediaQuery.sizeOf(context).width * 0.8,
                                        660)),
                              )),
                        );
                      });
                },
                label: const Text(
                  "افزودن",
                ),
                icon: const Icon(Icons.add),
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 16)),
                  textStyle: WidgetStateProperty.all(
                      Theme.of(context).textTheme.labelMedium),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
                ),
              ),
            ],
          ),
        ),
        BlocConsumer<SlidersTableCubit, SlidersTableState>(
          listener: (context, state) {
            if (state is SlidersTableError) {
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
                        title: "خطا در دریافت فیلم های صفحه اول",
                        message: state.error,
                      );
                    });
              }
            } else if (state is SlidersTableSuccess) {
              _dataGrid.buildDataGridRows(sliders: state.data.results ?? []);
            }
          },
          builder: (context, state) {
            if (state is SlidersTableSuccess) {
              if (_dataGrid.rows.isNotEmpty) {
                return Expanded(child: table());
              } else {
                return Expanded(
                    child: Center(
                  child: Text(
                    "فیلمی وجود ندارد",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ));
              }
            } else if (state is SlidersTableLoading) {
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
            } else if (state is SlidersTableError) {
              if (_dataGrid.rows.isEmpty) {
                return Expanded(child: _error(state.error));
              } else {
                return Expanded(child: table());
              }
            }
            return Expanded(child: _error(null));
          },
        ),
        BlocBuilder<SlidersTableCubit, SlidersTableState>(
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
                            if (BlocProvider.of<SlidersTableCubit>(context)
                                .state is! SlidersTableLoading) {
                              BlocProvider.of<SlidersTableCubit>(context)
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
        rowHeight: 150,
        headerRowHeight: 56,
        columnWidthMode: ColumnWidthMode.fill,
        gridLinesVisibility: GridLinesVisibility.none,
        headerGridLinesVisibility: GridLinesVisibility.none,
        columns: <GridColumn>[
          GridColumn(
              minimumWidth: 40,
              columnName: 'priority',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('الویت',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 140,
              columnName: 'media',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('فیلم',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 100,
              columnName: 'title',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('عنوان',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer)))),
          GridColumn(
              minimumWidth: 140,
              columnName: 'actions',
              label: Container(
                  alignment: Alignment.center,
                  child: Text('عملیات',
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
                  BlocProvider.of<SlidersTableCubit>(context).getData();
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
