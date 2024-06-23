import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/media/data/remote/model/country.dart';
import 'package:dashboard/feature/media/data/remote/model/genre.dart';
import 'package:dashboard/feature/media/data/remote/model/movie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MovieDataGrid extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final BuildContext _context;

  MovieDataGrid({List<Movie>? movie, required BuildContext context})
      : _context = context {
    if (movie != null) {
      buildDataGridRows(movie: movie);
    }
  }

  void buildDataGridRows({required List<Movie> movie}) {
    _dataGridRows = movie.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
        DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
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
            ? CustomColor.evenRowBackgroundColor.getColor(_context)
            : CustomColor.oddRowBackgroundColor.getColor(_context),
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
                        Chip(
                            label: Text(countries[i].name ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(_context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: Colors.white)))
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
                        Chip(
                            label: Text(genres[i].title ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(_context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: Colors.white)))
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
                    child: IconButton.filledTonal(
                      tooltip: "جزئیات",
                      onPressed: () {},
                      icon: Icon(
                        Icons.remove_red_eye_rounded,
                        size: 16,
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Theme.of(_context).primaryColorLight),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)))),
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton.filledTonal(
                      tooltip: "ویرایش",
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit,
                        size: 16,
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Theme.of(_context).primaryColorLight),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)))),
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton.filledTonal(
                      tooltip: "حذف",
                      onPressed: () {},
                      icon: Icon(
                        Icons.delete,
                        size: 16,
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Theme.of(_context).primaryColorLight),
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
