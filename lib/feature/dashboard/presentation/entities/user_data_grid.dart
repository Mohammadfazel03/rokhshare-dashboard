import 'package:dashboard/config/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../data/remote/model/user.dart';

class UserDataGrid extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final BuildContext _context;

  UserDataGrid({List<User>? users, required BuildContext context})
      : _context = context {
    if (users != null) {
      buildDataGridRows(users: users);
    }
  }

  void buildDataGridRows({required List<User> users}) {
    _dataGridRows = users.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'username', value: dataGridRow.username),
        DataGridCell<String>(columnName: 'name', value: dataGridRow.fullName),
        DataGridCell<bool>(columnName: 'status', value: dataGridRow.isPremium),
        DataGridCell<int>(
            columnName: 'movieViewed', value: dataGridRow.seenMovies),
        DataGridCell<String>(columnName: 'date', value: dataGridRow.dateJoined),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map((dataGridCell) {
      if (dataGridCell.columnName == 'date') {
        var jDate = DateTime.parse(dataGridCell.value.toString()).toJalali();
        var f = jDate.formatter;
        return Align(
          child: Text('${f.yyyy}/${f.mm}/${f.dd}',
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
                    fontSize: 12,
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

  void updateDataGridSource() {
    notifyListeners();
  }
}
