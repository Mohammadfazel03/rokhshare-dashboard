import 'package:dashboard/config/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../data/remote/model/plan.dart';

class PlanDataGrid extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final BuildContext _context;

  PlanDataGrid({List<Plan>? plans, required BuildContext context})
      : _context = context {
    if (plans != null) {
      buildDataGridRows(plans: plans);
    }
  }

  void buildDataGridRows({required List<Plan> plans}) {
    _dataGridRows = plans.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'title', value: dataGridRow.title),
        DataGridCell<int>(columnName: 'time', value: dataGridRow.days),
        DataGridCell<int>(columnName: 'price', value: dataGridRow.price),
        DataGridCell<bool>(columnName: 'status', value: dataGridRow.isEnable),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map((dataGridCell) {
      if (dataGridCell.columnName == "price") {
        return Center(
          child: Text("${dataGridCell.value} تومان",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(_context).textTheme.labelMedium),
        );
      } else if (dataGridCell.columnName == "time") {
        return Center(
          child: Text("${dataGridCell.value} روز",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(_context).textTheme.labelMedium),
        );
      } else if (dataGridCell.columnName == "status") {
        return Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: dataGridCell.value
                    ? CustomColor.successBadgeBackgroundColor.getColor(_context)
                    : CustomColor.errorBadgeBackgroundColor.getColor(_context),
                borderRadius: BorderRadius.circular(4)),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                dataGridCell.value ? "فعال" : "غیر فعال",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(_context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dataGridCell.value
                        ? CustomColor.successBadgeTextColor.getColor(_context)
                        : CustomColor.errorBadgeTextColor.getColor(_context)),
              ),
            ),
          ),
        );
      }
      return Center(
        child: Text(dataGridCell.value.toString(),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(_context).textTheme.labelMedium),
      );
    }).toList());
  }
}
