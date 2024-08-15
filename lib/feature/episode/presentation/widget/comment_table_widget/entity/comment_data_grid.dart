import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/episode/presentation/widget/comment_table_widget/bloc/comment_table_cubit.dart';
import 'package:dashboard/feature/movie/data/remote/model/comment.dart';
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CommentDataGrid extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final BuildContext _context;
  final CommentTableCubit _cubit;
  final int _mediaId;

  CommentDataGrid(
      {List<Comment>? comments,
      required BuildContext context,
      required CommentTableCubit cubit,
      required int mediaId})
      : _context = context,
        _mediaId = mediaId,
        _cubit = cubit {
    if (comments != null) {
      buildDataGridRows(comments: comments);
    }
  }

  void buildDataGridRows({required List<Comment> comments}) {
    _dataGridRows = comments.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'username', value: dataGridRow.user?.username ?? ""),
        DataGridCell<List<String?>>(
            columnName: 'comment',
            value: [dataGridRow.title, dataGridRow.comment]),
        DataGridCell<String>(columnName: 'date', value: dataGridRow.createdAt),
        DataGridCell<CommentState>(
            columnName: 'status', value: dataGridRow.state),
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
            ? Theme.of(_context).colorScheme.surfaceContainerLow
            : Theme.of(_context).colorScheme.surfaceContainer,
        cells: row.getCells().map((dataGridCell) {
          if (dataGridCell.columnName == "actions") {
            var state = row
                .getCells()
                .firstWhere(
                    (dataGridCell) => dataGridCell.columnName == "status")
                .value;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (state != CommentState.accept) ...[
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton.filled(
                        tooltip: "تایید نظر",
                        onPressed: () {
                          _cubit.changeState(
                              commentId: dataGridCell.value,
                              commentState: CommentState.accept,
                              mediaId: _mediaId);
                        },
                        icon: const Icon(
                          Icons.check_rounded,
                          size: 16,
                        ),
                        style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)))),
                      ),
                    )
                  ],
                  if (state != CommentState.reject) ...[
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton.filled(
                        tooltip: "رد نظر",
                        onPressed: () {
                          _cubit.changeState(
                              commentId: dataGridCell.value,
                              commentState: CommentState.reject,
                              mediaId: _mediaId);
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 16,
                        ),
                        style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)))),
                      ),
                    )
                  ]
                ],
              ),
            );
          } else if (dataGridCell.columnName == "status") {
            return Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: dataGridCell.value == CommentState.accept
                        ? CustomColor.successBadgeBackgroundColor
                            .getColor(_context)
                        : dataGridCell.value == CommentState.pending
                            ? CustomColor.warningBadgeBackgroundColor
                                .getColor(_context)
                            : CustomColor.errorBadgeBackgroundColor
                                .getColor(_context),
                    borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    dataGridCell.value == CommentState.accept
                        ? "تایید شده"
                        : dataGridCell.value == CommentState.pending
                            ? "در انتظار برسی"
                            : "رد شده",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(_context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: dataGridCell.value == CommentState.accept
                            ? CustomColor.successBadgeTextColor
                                .getColor(_context)
                            : dataGridCell.value == CommentState.pending
                                ? CustomColor.warningBadgeTextColor
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
          } else if (dataGridCell.columnName == 'comment') {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dataGridCell.value[0],
                      style: Theme.of(_context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Text(dataGridCell.value[1],
                      style: Theme.of(_context).textTheme.labelMedium),
                ],
              ),
            );
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                dataGridCell.value.toString(),
                textAlign: TextAlign.justify,
                style: Theme.of(_context).textTheme.labelMedium,
              ),
            ),
          );
        }).toList());
  }
}
