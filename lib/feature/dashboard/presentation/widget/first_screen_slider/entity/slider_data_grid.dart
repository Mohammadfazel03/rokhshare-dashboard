import 'package:dashboard/feature/dashboard/data/remote/model/slider.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SliderDataGrid extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final BuildContext _context;

  SliderDataGrid({List<SliderModel>? sliders, required BuildContext context})
      : _context = context {
    if (sliders != null) {
      buildDataGridRows(sliders: sliders);
    }
  }

  void buildDataGridRows({required List<SliderModel> sliders}) {
    _dataGridRows = sliders.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'priority', value: dataGridRow.priority),
        DataGridCell<Media>(columnName: 'media', value: dataGridRow.media),
        DataGridCell<String>(columnName: 'title', value: dataGridRow.title),
        DataGridCell<String>(
            columnName: 'description', value: dataGridRow.description),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map((dataGridCell) {
      if (dataGridCell.columnName == "media") {
        return Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  "${dataGridCell.value.poster}",
                  height: 96,
                  width: 64,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  dataGridCell.value.name,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(_context).textTheme.labelSmall,
                  maxLines: 2,
                ),
              )
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
