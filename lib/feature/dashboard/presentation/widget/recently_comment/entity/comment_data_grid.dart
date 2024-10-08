import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/comment.dart';
import 'package:dashboard/feature/movie/data/remote/model/comment.dart' as c2;
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';


class CommentDataGrid extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final BuildContext _context;

  CommentDataGrid({List<Comment>? comments, required BuildContext context})
      : _context = context {
    if (comments != null) {
      buildDataGridRows(comments: comments);
    }
  }

  void buildDataGridRows({required List<Comment> comments}) {
    _dataGridRows = comments.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'username', value: dataGridRow.username),
        DataGridCell<Media>(columnName: 'media', value: dataGridRow.media),
        DataGridCell<String>(columnName: 'comment', value: dataGridRow.comment),
        DataGridCell<String>(columnName: 'date', value: dataGridRow.createdAt),
        DataGridCell<c2.CommentState>(
            columnName: 'status', value: dataGridRow.state),
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
      } else if (dataGridCell.columnName == "status") {
        return Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: dataGridCell.value == c2.CommentState.accept
                    ? CustomColor.successBadgeBackgroundColor.getColor(_context)
                    : dataGridCell.value == c2.CommentState.pending
                        ? CustomColor.warningBadgeBackgroundColor
                            .getColor(_context)
                        : CustomColor.errorBadgeBackgroundColor
                            .getColor(_context),
                borderRadius: BorderRadius.circular(4)),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                dataGridCell.value == c2.CommentState.accept
                    ? "تایید شده"
                    : dataGridCell.value == c2.CommentState.pending
                        ? "در انتظار برسی"
                        : "رد شده",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(_context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dataGridCell.value == c2.CommentState.accept
                        ? CustomColor.successBadgeTextColor.getColor(_context)
                        : dataGridCell.value == c2.CommentState.pending
                            ? CustomColor.warningBadgeTextColor
                                .getColor(_context)
                            : CustomColor.errorBadgeTextColor
                                .getColor(_context)),
              ),
            ),
          ),
        );
      } else if (dataGridCell.columnName == 'date') {
        var jDate = DateTime.parse(dataGridCell.value.toString()).toJalali();
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
