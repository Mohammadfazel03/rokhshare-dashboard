import 'package:dashboard/config/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../data/remote/model/ads.dart';

class AdsDataGrid extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final BuildContext _context;

  AdsDataGrid({List<Advertise>? sliders, required BuildContext context})
      : _context = context {
    if (sliders != null) {
      buildDataGridRows(sliders: sliders);
    }
  }

  void buildDataGridRows({required List<Advertise> sliders}) {
    _dataGridRows = sliders.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'title', value: dataGridRow.title),
        DataGridCell<String>(
            columnName: 'createdAt', value: dataGridRow.createdAt),
        DataGridCell<int>(
            columnName: 'viewNumber', value: dataGridRow.viewNumber),
        DataGridCell<int>(
            columnName: 'mustPlayed', value: dataGridRow.mustPlayed)
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map((dataGridCell) {
      if (dataGridCell.columnName == 'createdAt') {
        var jDate = DateTime.parse(dataGridCell.value.toString()).toJalali();
        var f = jDate.formatter;
        return Align(
          child: Text('${f.yyyy}/${f.mm}/${f.dd}',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(_context).textTheme.bodyMedium),
        );
      }
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(dataGridCell.value.toString(),
              textAlign: TextAlign.justify,
              style: Theme.of(_context).textTheme.bodyMedium),
        ),
      );
    }).toList());
  }
}
