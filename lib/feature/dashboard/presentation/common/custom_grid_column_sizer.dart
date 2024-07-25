import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CustomGridColumnSizer extends ColumnSizer {
  @override
  double computeHeaderCellWidth(GridColumn column, TextStyle style) {
    return super.computeHeaderCellWidth(
        column,
        const TextStyle(
            fontFamily: 'iran-sans',
            fontSize: 14,
            fontWeight: FontWeight.bold));
  }

  @override
  double computeCellHeight(GridColumn column, DataGridRow row,
      Object? cellValue, TextStyle textStyle) {
    return super.computeCellHeight(
        column,
        row,
        cellValue,
        const TextStyle(
          fontFamily: 'iran-sans',
          fontSize: 14,
        ));
  }

  @override
  double computeHeaderCellHeight(GridColumn column, TextStyle textStyle) {
    return super.computeHeaderCellHeight(
        column,
        const TextStyle(
            fontFamily: 'iran-sans',
            fontSize: 14,
            fontWeight: FontWeight.bold));
  }

  @override
  double computeCellWidth(GridColumn column, DataGridRow row, Object? cellValue,
      TextStyle textStyle) {
    return super.computeCellWidth(
        column,
        row,
        cellValue,
        const TextStyle(
          fontFamily: 'iran-sans',
          fontSize: 14,
        ));
  }
}
