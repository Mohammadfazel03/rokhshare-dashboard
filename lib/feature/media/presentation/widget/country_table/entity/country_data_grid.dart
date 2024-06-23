import 'package:dashboard/config/dio_config.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/media/data/remote/model/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CountryDataGrid extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final BuildContext _context;

  CountryDataGrid({List<Country>? series, required BuildContext context})
      : _context = context {
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
            ? CustomColor.evenRowBackgroundColor.getColor(_context)
            : CustomColor.oddRowBackgroundColor.getColor(_context),
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
                        "$baseUrl${dataGridCell.value.flag}",
                        height: 32,
                        width: 32,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 8),
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
                    child: IconButton.filledTonal(
                      tooltip: "ویرایش",
                      onPressed: () {},
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
                      onPressed: () {},
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
