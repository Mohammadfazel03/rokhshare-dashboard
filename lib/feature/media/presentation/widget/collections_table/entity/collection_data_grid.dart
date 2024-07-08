import 'package:dashboard/config/dio_config.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/slider.dart';
import 'package:dashboard/feature/media/data/remote/model/collection.dart';
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CollectionDataGrid extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final BuildContext _context;

  CollectionDataGrid(
      {List<Collection>? collections, required BuildContext context})
      : _context = context {
    if (collections != null) {
      buildDataGridRows(collections: collections);
    }
  }

  void buildDataGridRows({required List<Collection> collections}) {
    _dataGridRows = collections.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
        DataGridCell<Media>(
            columnName: 'media',
            value: Media(name: dataGridRow.name, poster: dataGridRow.poster)),
        DataGridCell<String>(columnName: 'owner', value: dataGridRow.owner),
        DataGridCell<String>(columnName: 'date', value: dataGridRow.createdAt),
        DataGridCell<bool>(columnName: 'status', value: dataGridRow.isConfirm),
        DataGridCell<Collection>(columnName: 'actions', value: dataGridRow),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        color: effectiveRows.indexOf(row) % 2 == 0
            ? Theme.of(_context).colorScheme.surfaceContainerLow
            : Theme.of(_context).colorScheme.surfaceContainer,
        cells: row.getCells().map((dataGridCell) {
          if (dataGridCell.columnName == "media") {
            return Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      "$baseUrl${dataGridCell.value.poster}",
                      height: 96,
                      width: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 8),
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
          } else if (dataGridCell.columnName == "actions") {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (dataGridCell.value.isConfirm == true)...[
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton.filled(
                      tooltip: "رفع انتشار",
                      onPressed: () {},
                      icon: Icon(
                        Icons.close,
                        size: 16,
                      ),
                      style: ButtonStyle(
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)))),
                    ),
                  ),
                  ] else ...[
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton.filled(
                        tooltip: "انتشار",
                        onPressed: () {},
                        icon: Icon(
                          Icons.check,
                          size: 16,
                        ),
                        style: ButtonStyle(
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)))),
                      ),
                    ),
                  ],
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton.filled(
                      tooltip: "جزئیات",
                      onPressed: () {},
                      icon: Icon(
                        Icons.remove_red_eye_rounded,
                        size: 16,
                      ),
                      style: ButtonStyle(
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)))),
                    ),
                  ),
                  if (dataGridCell.value.canEdit == true) ...[
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton.filled(
                        tooltip: "ویرایش",
                        onPressed: () {},
                        icon: Icon(
                          Icons.edit,
                          size: 16,
                        ),
                        style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)))),
                      ),
                    ),
                  ],
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton.filled(
                      tooltip: "حذف",
                      onPressed: () {},
                      icon: Icon(
                        Icons.delete,
                        size: 16,
                      ),
                      style: ButtonStyle(
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)))),
                    ),
                  ),
                ],
              ),
            );
          } else if (dataGridCell.columnName == "status") {
            return Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: dataGridCell.value
                        ? CustomColor.successBadgeBackgroundColor
                            .getColor(_context)
                        : CustomColor.errorBadgeBackgroundColor
                            .getColor(_context),
                    borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    dataGridCell.value ? "منتشر شده" : "رد شده",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(_context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: dataGridCell.value
                            ? CustomColor.successBadgeTextColor
                                .getColor(_context)
                            : CustomColor.errorBadgeTextColor
                                .getColor(_context)),
                  ),
                ),
              ),
            );
          } else if (dataGridCell.columnName == 'date') {
            var jDate =
                DateTime.parse(dataGridCell.value.toString()).toJalali();
            var f = jDate.formatter;
            return Align(
              child: Text('${f.yyyy}/${f.mm}/${f.dd}',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(_context).textTheme.labelMedium),
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
