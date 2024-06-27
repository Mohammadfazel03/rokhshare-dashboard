import 'dart:math';

import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/dio_config.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/media/data/remote/model/artist.dart';
import 'package:dashboard/feature/media/presentation/widget/artists_table/artist_append_dialog_widget.dart';
import 'package:dashboard/feature/media/presentation/widget/artists_table/bloc/artist_append_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/artists_table/bloc/artists_table_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ArtistDataGrid extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final BuildContext _context;
  final ArtistsTableCubit _cubit;

  ArtistDataGrid(
      {List<Artist>? artists,
      required BuildContext context,
      required ArtistsTableCubit cubit})
      : _context = context,
        _cubit = cubit {
    if (artists != null) {
      buildDataGridRows(artists: artists);
    }
  }

  void buildDataGridRows({required List<Artist> artists}) {
    _dataGridRows = artists.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
        DataGridCell<Artist>(columnName: 'artist', value: dataGridRow),
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
            ? CustomColor.evenRowBackgroundColor.getColor(_context)
            : CustomColor.oddRowBackgroundColor.getColor(_context),
        cells: row.getCells().map((dataGridCell) {
          if (dataGridCell.columnName == "artist") {
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
                        "$baseUrl${dataGridCell.value.image}",
                        height: 32,
                        width: 32,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(dataGridCell.value.name ?? "",
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
                    child: IconButton.filledTonal(
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
                                        BlocProvider<ArtistAppendCubit>(
                                            create: (context) =>
                                                ArtistAppendCubit(
                                                    repository: getIt.get())),
                                      ],
                                      child: ArtistAppendDialogWidget(
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
                      icon: Icon(
                        Icons.edit,
                        size: 16,
                      ),
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              Theme.of(_context).primaryColorLight),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)))),
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton.filledTonal(
                      tooltip: "حذف",
                      onPressed: () {
                        showDialog(
                            context: _context,
                            builder: (dialogContext) => AlertDialog(
                                    title: Text(
                                      "حذف هنرمند",
                                      style: Theme.of(dialogContext)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    content: Text(
                                        "آیا از حذف هنرمند با شناسه ${dataGridCell.value} اظمینان دارید؟",
                                        style: Theme.of(dialogContext)
                                            .textTheme
                                            .labelSmall),
                                    actions: [
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                        },
                                        child: Text(
                                          "انصراف",
                                        ),
                                        style: ButtonStyle(
                                          side: WidgetStateProperty.all(
                                              BorderSide(
                                                  color: Theme.of(dialogContext)
                                                      .dividerColor)),
                                          foregroundColor:
                                              WidgetStateProperty.all(
                                                  Theme.of(dialogContext)
                                                      .textTheme
                                                      .labelSmall
                                                      ?.color),
                                          textStyle: WidgetStateProperty.all(
                                              Theme.of(dialogContext)
                                                  .textTheme
                                                  .labelSmall),
                                          padding: WidgetStateProperty.all(
                                              EdgeInsets.all(16)),
                                          shape: WidgetStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4))),
                                        ),
                                      ),
                                      FilledButton(
                                          style: ButtonStyle(
                                              foregroundColor:
                                                  WidgetStateProperty.all(
                                                      Theme.of(dialogContext)
                                                          .textTheme
                                                          .titleSmall
                                                          ?.color),
                                              textStyle: WidgetStateProperty.all(
                                                  Theme.of(dialogContext)
                                                      .textTheme
                                                      .labelSmall),
                                              padding: WidgetStateProperty.all(
                                                  EdgeInsets.all(16)),
                                              alignment: Alignment.center,
                                              backgroundColor: WidgetStateProperty.all(
                                                  CustomColor.loginBackgroundColor
                                                      .getColor(dialogContext)),
                                              shape: WidgetStateProperty.all(
                                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)))),
                                          onPressed: () {
                                            _cubit.delete(
                                                id: dataGridCell.value);
                                            Navigator.of(dialogContext).pop();
                                          },
                                          child: Text(
                                            "بله",
                                          )),
                                    ]));
                      },
                      icon: Icon(
                        Icons.delete,
                        size: 16,
                      ),
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              Theme.of(_context).primaryColorLight),
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
