import 'dart:math';

import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/feature/media/data/remote/model/country.dart';
import 'package:dashboard/feature/media/presentation/widget/country_table/bloc/countries_table_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/country_table/bloc/country_append_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/country_table/country_append_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CountryDataGrid extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final BuildContext _context;
  final CountriesTableCubit _cubit;

  CountryDataGrid(
      {List<Country>? series,
      required BuildContext context,
      required CountriesTableCubit cubit})
      : _context = context,
        _cubit = cubit {
    if (series != null) {
      buildDataGridRows(series: series);
    }
  }

  void buildDataGridRows({required List<Country> series}) {
    _dataGridRows = series.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
        DataGridCell<Country>(columnName: 'country', value: dataGridRow),
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
          if (dataGridCell.columnName == "country") {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Image.network(
                        dataGridCell.value.flag,
                        height: 32,
                        width: 32,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(dataGridCell.value.name,
                        textAlign: TextAlign.justify,
                        style: Theme.of(_context).textTheme.labelMedium),
                  ],
                ),
              ),
            );
          }
          if (dataGridCell.columnName == "actions") {
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
                                        BlocProvider.value(value: _cubit),
                                        BlocProvider<CountryAppendCubit>(
                                            create: (context) =>
                                                CountryAppendCubit(
                                                    repository: getIt.get())),
                                      ],
                                      child: CountryAppendDialogWidget(
                                          id: dataGridCell.value,
                                          width: min(
                                              MediaQuery.sizeOf(_context)
                                                      .width *
                                                  0.8,
                                              560)),
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
                                      "حذف کشور",
                                      style: Theme.of(dialogContext)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    content: Text(
                                        "آیا از حذف کشور با شناسه ${dataGridCell.value} اظمینان دارید؟",
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
                                              textStyle: WidgetStateProperty.all(
                                                  Theme.of(dialogContext)
                                                      .textTheme
                                                      .labelSmall),
                                              padding: WidgetStateProperty.all(
                                                  const EdgeInsets.all(16)),
                                              alignment: Alignment.center,
                                              shape: WidgetStateProperty.all(
                                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)))),
                                          onPressed: () {
                                            _cubit.delete(
                                                id: dataGridCell.value);
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
