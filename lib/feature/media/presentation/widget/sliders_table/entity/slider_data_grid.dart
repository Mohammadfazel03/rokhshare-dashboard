import 'dart:math';

import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/feature/media/data/remote/model/slider.dart';
import 'package:dashboard/feature/media/presentation/widget/sliders_table/bloc/slider_append_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/sliders_table/bloc/sliders_table_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/sliders_table/slider_append_dialog_widget.dart';
import 'package:dashboard/feature/media_collection/presentation/widget/media_autocomplete_field/bloc/media_autocomplete_field_cubit.dart';
import 'package:dashboard/feature/movie/data/remote/model/movie.dart';
import 'package:dashboard/feature/movie/presentation/widget/poster_section_widget/bloc/poster_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/synopsis_section_widget/bloc/synopsis_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/thumbnail_section_widget/bloc/thumbnail_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/title_section_widget/bloc/title_section_cubit.dart';
import 'package:dashboard/feature/season/presentation/widget/integer_field_widget/bloc/integer_field_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SliderDataGrid extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final BuildContext _context;

  SliderDataGrid({List<SliderModel>? sliders, required BuildContext context})
      : _context = context {
    if (sliders != null) {
      buildDataGridRows(sliders: sliders);
    }
  }

  void buildDataGridRows({required List<SliderModel> sliders}) {
    _dataGridRows = sliders.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'priority', value: dataGridRow.priority),
        DataGridCell<Media>(columnName: 'media', value: dataGridRow.media),
        DataGridCell<String>(columnName: 'title', value: dataGridRow.title),
        DataGridCell<int>(columnName: 'actions', value: dataGridRow.id),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        color: effectiveRows.indexOf(row) % 2 == 0
            ? Theme.of(_context).colorScheme.surfaceContainerLow
            : Theme.of(_context).colorScheme.surfaceContainer,
        cells: row.getCells().map((dataGridCell) {
          if (dataGridCell.columnName == "media") {
            return Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      "${dataGridCell.value.poster}",
                      height: 96,
                      width: 64,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      dataGridCell.value.name,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(_context).textTheme.labelSmall,
                      maxLines: 2,
                    ),
                  )
                ],
              ),
            );
          } else if (dataGridCell.columnName == "actions") {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton.filled(
                      tooltip: "ویرایش",
                      onPressed: () {
                        showDialog(
                            context: _context,
                            builder: (BuildContext dialogContext) {
                              return Dialog(
                                clipBehavior: Clip.hardEdge,
                                child: SizedBox(
                                    width: min(
                                        MediaQuery.sizeOf(_context).width * 0.8,
                                        560),
                                    child: MultiBlocProvider(
                                      providers: [
                                        BlocProvider.value(
                                            value: BlocProvider.of<
                                                SlidersTableCubit>(_context)),
                                        BlocProvider<SliderAppendCubit>(
                                            create: (context) =>
                                                SliderAppendCubit(
                                                    repository: getIt.get())),
                                        BlocProvider<TitleSectionCubit>(
                                            create: (context) =>
                                                TitleSectionCubit()),
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
                                            create: (context) =>
                                                IntegerFieldCubit()),
                                        BlocProvider<
                                                MediaAutocompleteFieldCubit>(
                                            create: (context) =>
                                                MediaAutocompleteFieldCubit(
                                                    repository: getIt.get())),
                                      ],
                                      child: SliderAppendDialogWidget(
                                          id: dataGridCell.value,
                                          width: min(
                                              MediaQuery.sizeOf(_context)
                                                      .width *
                                                  0.8,
                                              660)),
                                    )),
                              );
                            });
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 16,
                      ),
                      style: ButtonStyle(
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)))),
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton.filled(
                      tooltip: "حذف",
                      onPressed: () {
                        showDialog(
                            context: _context,
                            builder: (dialogContext) => AlertDialog(
                                    title: Text(
                                      "حذف صفحه اول",
                                      style: Theme.of(dialogContext)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    content: Text(
                                        "آیا از حذف صفحه اول با شناسه ${dataGridCell.value} اظمینان دارید؟",
                                        style: Theme.of(dialogContext)
                                            .textTheme
                                            .bodyMedium),
                                    actions: [
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                        },
                                        style: ButtonStyle(
                                          textStyle: WidgetStateProperty.all(
                                              Theme.of(dialogContext)
                                                  .textTheme
                                                  .labelSmall),
                                          padding: WidgetStateProperty.all(
                                              const EdgeInsets.all(16)),
                                          shape: WidgetStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4))),
                                        ),
                                        child: const Text(
                                          "انصراف",
                                        ),
                                      ),
                                      FilledButton(
                                          style: ButtonStyle(
                                              textStyle:
                                                  WidgetStateProperty.all(
                                                      Theme.of(dialogContext)
                                                          .textTheme
                                                          .labelSmall),
                                              padding: WidgetStateProperty.all(
                                                  const EdgeInsets.all(16)),
                                              alignment: Alignment.center,
                                              shape: WidgetStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4)))),
                                          onPressed: () {
                                            BlocProvider.of<SlidersTableCubit>(
                                                    _context)
                                                .delete(id: dataGridCell.value);
                                            Navigator.of(dialogContext).pop();
                                          },
                                          child: const Text(
                                            "بله",
                                          )),
                                    ]));
                      },
                      icon: const Icon(
                        Icons.delete,
                        size: 16,
                      ),
                      style: ButtonStyle(
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)))),
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(dataGridCell.value.toString(),
                  textAlign: TextAlign.justify,
                  style: Theme.of(_context).textTheme.labelMedium),
            ),
          );
        }).toList());
  }
}
