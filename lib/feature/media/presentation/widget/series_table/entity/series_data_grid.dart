import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/feature/media/data/remote/model/country.dart';
import 'package:dashboard/feature/media/data/remote/model/genre.dart';
import 'package:dashboard/feature/media/data/remote/model/series.dart';
import 'package:dashboard/feature/media/presentation/widget/series_table/bloc/series_table_cubit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SeriesDataGrid extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final BuildContext _context;
  final SeriesTableCubit _cubit;

  SeriesDataGrid(
      {List<Series>? series,
      required BuildContext context,
      required SeriesTableCubit cubit})
      : _context = context,
        _cubit = cubit {
    if (series != null) {
      buildDataGridRows(series: series);
    }
  }

  void buildDataGridRows({required List<Series> series}) {
    _dataGridRows = series.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
        DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
        DataGridCell<int>(
            columnName: 'seasonNumber', value: dataGridRow.seasonNumber),
        DataGridCell<int>(
            columnName: 'episodeNumber', value: dataGridRow.episodeNumber),
        DataGridCell<List<Genre>>(
            columnName: 'genres', value: dataGridRow.genres),
        DataGridCell<List<Country>>(
            columnName: 'countries', value: dataGridRow.countries),
        DataGridCell<String>(
            columnName: 'releaseDate', value: dataGridRow.releaseDate),
        DataGridCell<String>(columnName: 'value', value: dataGridRow.value),
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
          if (dataGridCell.columnName == 'releaseDate') {
            var jDate =
                DateTime.parse(dataGridCell.value.toString()).toJalali();
            var f = jDate.formatter;
            return Align(
              child: Text('${f.yyyy}/${f.mm}/${f.dd}',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(_context).textTheme.labelMedium),
            );
          } else if (dataGridCell.columnName == "countries") {
            List<Country> countries = dataGridCell.value;
            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: [
                      for (int i = 0; i < countries.length; i++) ...[
                        RawChip(
                            selectedColor:
                                Theme.of(_context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            side: BorderSide.none,
                            elevation: 1,
                            pressElevation: 2,
                            showCheckmark: false,
                            selected: true,
                            onSelected: (s) {},
                            label: Text(countries[i].name ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(_context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                        color: Theme.of(_context)
                                            .colorScheme
                                            .onPrimary)))
                      ]
                    ],
                  ),
                ),
              ),
            );
          } else if (dataGridCell.columnName == "genres") {
            List<Genre> genres = dataGridCell.value;
            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: [
                      for (int i = 0; i < genres.length; i++) ...[
                        RawChip(
                          selectedColor: Theme.of(_context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          side: BorderSide.none,
                          elevation: 1,
                          pressElevation: 2,
                          showCheckmark: false,
                          selected: true,
                          onSelected: (s) {},
                          label: Text(genres[i].title ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(_context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                      color: Theme.of(_context)
                                          .colorScheme
                                          .onPrimary)),
                        )
                      ]
                    ],
                  ),
                ),
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
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton.filled(
                      tooltip: "جزئیات",
                      onPressed: () {
                        _context.go(
                            "${RoutePath.detailSeries.fullPath}${dataGridCell.value}",
                            extra: _cubit);
                      },
                      icon: const Icon(
                        Icons.message_rounded,
                        size: 16,
                      ),
                      style: ButtonStyle(
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)))),
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton.filled(
                      tooltip: "ویرایش",
                      onPressed: () {
                        _context.go(
                            "${RoutePath.editSeries.fullPath}${dataGridCell.value}",
                            extra: _cubit);
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 16,
                      ),
                      style: ButtonStyle(
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)))),
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton.filled(
                      tooltip: "حذف",
                      onPressed: () {
                        showDialog(
                            context: _context,
                            builder: (dialogContext) => AlertDialog(
                                    title: Text(
                                      "حذف سریال",
                                      style: Theme.of(dialogContext)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    content: Text(
                                        "آیا از حذف سریال با شناسه ${dataGridCell.value} اظمینان دارید؟",
                                        style: Theme.of(dialogContext)
                                            .textTheme
                                            .bodyMedium),
                                    actions: [
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                        },
                                        style: ButtonStyle(
                                          textStyle: WidgetStateProperty.all(
                                              Theme.of(dialogContext)
                                                  .textTheme
                                                  .labelSmall),
                                          padding: WidgetStateProperty.all(
                                              const EdgeInsets.all(16)),
                                          shape: WidgetStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4))),
                                        ),
                                        child: const Text(
                                          "انصراف",
                                        ),
                                      ),
                                      FilledButton(
                                          style: ButtonStyle(
                                              textStyle:
                                                  WidgetStateProperty.all(
                                                      Theme.of(dialogContext)
                                                          .textTheme
                                                          .labelSmall),
                                              padding: WidgetStateProperty.all(
                                                  const EdgeInsets.all(16)),
                                              alignment: Alignment.center,
                                              shape: WidgetStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4)))),
                                          onPressed: () {
                                            _cubit.delete(
                                                id: dataGridCell.value);
                                            Navigator.of(dialogContext).pop();
                                          },
                                          child: const Text(
                                            "بله",
                                          )),
                                    ]));
                      },
                      icon: const Icon(
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
