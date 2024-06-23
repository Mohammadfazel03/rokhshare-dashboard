import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/media/data/remote/model/genre.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class GenreDataGrid extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final BuildContext _context;

  GenreDataGrid({List<Genre>? series, required BuildContext context})
      : _context = context {
    if (series != null) {
      buildDataGridRows(series: series);
    }
  }

  void buildDataGridRows({required List<Genre> series}) {
    _dataGridRows = series.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
        DataGridCell<String>(columnName: 'name', value: dataGridRow.title),
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
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit,
                        size: 16,
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Theme.of(_context).primaryColorLight),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)))),
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton.filledTonal(
                      tooltip: "حذف",
                      onPressed: () {},
                      icon: Icon(
                        Icons.delete,
                        size: 16,
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Theme.of(_context).primaryColorLight),
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
