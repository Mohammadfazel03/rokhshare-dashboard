import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CustomGridColumnSizer extends ColumnSizer {
  final BuildContext context;

  CustomGridColumnSizer({required this.context});

  @override
  double computeCellHeight(GridColumn column, DataGridRow row,
      Object? cellValue, TextStyle textStyle) {
    if (cellValue is List) {
      var title = super.computeCellHeight(
          column,
          row,
          cellValue[0],
          Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontWeight: FontWeight.bold) ??
              const TextStyle(
                fontFamily: 'iran-sans',
                fontSize: 14,
              ));
      var comment = super.computeCellHeight(
          column,
          row,
          cellValue[1],
          Theme.of(context).textTheme.labelMedium ??
              const TextStyle(
                fontFamily: 'iran-sans',
                fontSize: 14,
              ));
      return title + comment;
    }
    return super.computeCellHeight(
        column,
        row,
        cellValue,
        Theme.of(context).textTheme.labelMedium ??
            const TextStyle(
              fontFamily: 'iran-sans',
              fontSize: 14,
            ));
  }
}
