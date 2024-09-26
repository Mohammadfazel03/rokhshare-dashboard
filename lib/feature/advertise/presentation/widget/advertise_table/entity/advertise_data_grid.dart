import 'dart:math';

import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/feature/advertise/presentation/widget/advertise_table/advertise_append_dialog_widget.dart';
import 'package:dashboard/feature/advertise/presentation/widget/advertise_table/bloc/advertise_append_cubit.dart';
import 'package:dashboard/feature/advertise/presentation/widget/advertise_table/bloc/advertise_table_cubit.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AdvertiseDataGrid extends DataGridSource {
  final List<DataGridRow> _dataGridRows = [];
  final BuildContext _context;
  final AdvertiseTableCubit _cubit;

  final List<ValueNotifier<bool>> _hoveringItems = [];

  AdvertiseDataGrid(
      {List<Advertise>? advertise,
      required BuildContext context,
      required AdvertiseTableCubit cubit})
      : _context = context,
        _cubit = cubit {
    if (advertise != null) {
      buildDataGridRows(advertise: advertise);
    }
  }

  void buildDataGridRows({required List<Advertise> advertise}) {
    for (var h in _hoveringItems) {
      h.dispose();
    }
    _hoveringItems.clear();
    _dataGridRows.clear();
    for (var dataGridRow in advertise) {
      _hoveringItems.add(ValueNotifier(false));
      _dataGridRows.add(DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
        DataGridCell<Advertise>(columnName: 'advertise', value: dataGridRow),
        DataGridCell<String>(
            columnName: 'releaseDate', value: dataGridRow.createdAt),
        DataGridCell<int>(
            columnName: 'mustPlayed', value: dataGridRow.mustPlayed),
        DataGridCell<int>(
            columnName: 'viewNumber', value: dataGridRow.viewNumber),
      ]));
    }
  }

  @override
  void dispose() {
    for (var h in _hoveringItems) {
      h.dispose();
    }
    _hoveringItems.clear();
    super.dispose();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int index = effectiveRows.indexOf(row);
    return DataGridRowAdapter(
        color: index % 2 == 0
            ? Theme.of(_context).colorScheme.surfaceContainerLow
            : Theme.of(_context).colorScheme.surfaceContainer,
        cells: row.getCells().map((dataGridCell) {
          if (dataGridCell.columnName == 'releaseDate') {
            var jDate =
                DateTime.parse(dataGridCell.value.toString()).toJalali();
            var f = jDate.formatter;
            return MouseRegion(
              onEnter: (_) {
                if (_hoveringItems[index].value == false) {
                  _hoveringItems[index].value = !_hoveringItems[index].value;
                }
              },
              onExit: (_) {
                if (_hoveringItems[index].value == true) {
                  _hoveringItems[index].value = !_hoveringItems[index].value;
                }
              },
              child: Align(
                child: Text('${f.yyyy}/${f.mm}/${f.dd}',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(_context).textTheme.labelMedium),
              ),
            );
          } else if (dataGridCell.columnName == "advertise") {
            Advertise advertise = dataGridCell.value;
            return MouseRegion(
                onEnter: (_) {
                  if (_hoveringItems[index].value == false) {
                    _hoveringItems[index].value = !_hoveringItems[index].value;
                  }
                },
                onExit: (_) {
                  if (_hoveringItems[index].value == true) {
                    _hoveringItems[index].value = !_hoveringItems[index].value;
                  }
                },
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Stack(
                              children: [
                                if (advertise.file?.thumbnail != null) ...[
                                  Positioned.fill(
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                            "${advertise.file!.thumbnail}")),
                                  )
                                ] else ...[
                                  Positioned.fill(
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          color: Colors.black,
                                        )),
                                  )
                                ],
                                if (advertise.humanizeTime != null)
                                  Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: const Color.fromRGBO(
                                                  0, 0, 0, 0.8)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Text(advertise.humanizeTime!,
                                                style: Theme.of(_context)
                                                    .textTheme
                                                    .labelMedium
                                                    ?.copyWith(
                                                        color: Colors.white)),
                                          )))
                              ],
                            )),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ValueListenableBuilder(
                              valueListenable: _hoveringItems[index],
                              builder: (BuildContext context, bool value,
                                  Widget? child) {
                                return Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(advertise.title ?? "",
                                        style: Theme.of(_context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                                color: Theme.of(_context)
                                                    .colorScheme
                                                    .onSurface)),
                                    if (value) ...[
                                      const Expanded(child: SizedBox()),
                                      Wrap(
                                        runAlignment: WrapAlignment.center,
                                        alignment: WrapAlignment.center,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        spacing: 8,
                                        runSpacing: 4,
                                        children: [
                                          IconButton(
                                            tooltip: "جزئیات",
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                      dialogContext) {
                                                    return Dialog(
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      child: SizedBox(
                                                          width: min(
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  0.8,
                                                              560),
                                                          child:
                                                              MultiBlocProvider(
                                                            providers: [
                                                              BlocProvider.value(
                                                                  value:
                                                                      _cubit),
                                                              BlocProvider<
                                                                      AdvertiseAppendCubit>(
                                                                  create: (context) =>
                                                                      AdvertiseAppendCubit(
                                                                          repository:
                                                                              getIt.get())),
                                                            ],
                                                            child: AdvertiseAppendDialogWidget(
                                                                readOnly: true,
                                                                id: advertise
                                                                    .id,
                                                                width: min(
                                                                    MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.8,
                                                                    560)),
                                                          )),
                                                    );
                                                  });
                                            },
                                            icon: const Icon(
                                              Icons.remove_red_eye_rounded,
                                            ),
                                            style: ButtonStyle(
                                                shape: WidgetStateProperty.all(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)))),
                                          ),
                                          IconButton(
                                            tooltip: "ویرایش",
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                      dialogContext) {
                                                    return Dialog(
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      child: SizedBox(
                                                          width: min(
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  0.8,
                                                              560),
                                                          child:
                                                              MultiBlocProvider(
                                                            providers: [
                                                              BlocProvider.value(
                                                                  value:
                                                                      _cubit),
                                                              BlocProvider<
                                                                      AdvertiseAppendCubit>(
                                                                  create: (context) =>
                                                                      AdvertiseAppendCubit(
                                                                          repository:
                                                                              getIt.get())),
                                                            ],
                                                            child: AdvertiseAppendDialogWidget(
                                                                id: advertise
                                                                    .id,
                                                                width: min(
                                                                    MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.8,
                                                                    560)),
                                                          )),
                                                    );
                                                  });
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                            ),
                                            style: ButtonStyle(
                                                shape: WidgetStateProperty.all(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)))),
                                          ),
                                          IconButton(
                                            tooltip: "حذف",
                                            onPressed: () {
                                              showDialog(
                                                  context: _context,
                                                  builder: (dialogContext) =>
                                                      AlertDialog(
                                                          title: Text(
                                                            "حذف قسمت",
                                                            style: Theme.of(
                                                                    dialogContext)
                                                                .textTheme
                                                                .headlineSmall,
                                                          ),
                                                          content: Text(
                                                              "آیا از حذف تبلیغ با شناسه ${dataGridCell.value.id} اظمینان دارید؟",
                                                              style: Theme.of(
                                                                      dialogContext)
                                                                  .textTheme
                                                                  .bodyMedium),
                                                          actions: [
                                                            OutlinedButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        dialogContext)
                                                                    .pop();
                                                              },
                                                              style:
                                                                  ButtonStyle(
                                                                textStyle: WidgetStateProperty
                                                                    .all(Theme.of(
                                                                            dialogContext)
                                                                        .textTheme
                                                                        .labelSmall),
                                                                padding: WidgetStateProperty.all(
                                                                    const EdgeInsets
                                                                        .all(
                                                                        16)),
                                                                shape: WidgetStateProperty.all(
                                                                    RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(4))),
                                                              ),
                                                              child: const Text(
                                                                "انصراف",
                                                              ),
                                                            ),
                                                            FilledButton(
                                                                style: ButtonStyle(
                                                                    textStyle: WidgetStateProperty.all(Theme.of(
                                                                            dialogContext)
                                                                        .textTheme
                                                                        .labelSmall),
                                                                    padding: WidgetStateProperty.all(
                                                                        const EdgeInsets
                                                                            .all(
                                                                            16)),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    shape: WidgetStateProperty.all(
                                                                        RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(4)))),
                                                                onPressed: () {
                                                                  _cubit.delete(
                                                                      id: dataGridCell
                                                                          .value
                                                                          .id);
                                                                  Navigator.of(
                                                                          dialogContext)
                                                                      .pop();
                                                                },
                                                                child: const Text(
                                                                  "بله",
                                                                )),
                                                          ]));
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                            ),
                                            style: ButtonStyle(
                                                shape: WidgetStateProperty.all(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)))),
                                          ),
                                        ],
                                      )
                                    ]
                                  ],
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    )));
          }
          return MouseRegion(
            onEnter: (_) {
              if (_hoveringItems[index].value == false) {
                _hoveringItems[index].value = !_hoveringItems[index].value;
              }
            },
            onExit: (_) {
              if (_hoveringItems[index].value == true) {
                _hoveringItems[index].value = !_hoveringItems[index].value;
              }
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(dataGridCell.value.toString(),
                    textAlign: TextAlign.justify,
                    style: Theme.of(_context).textTheme.labelMedium),
              ),
            ),
          );
        }).toList());
  }
}
