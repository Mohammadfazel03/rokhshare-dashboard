import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/feature/season_episode/data/remote/model/episode.dart';
import 'package:dashboard/feature/season_episode/presentation/bloc/season_episode_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:format/format.dart';
import 'package:go_router/go_router.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SeasonEpisodeDataGrid extends DataGridSource {
  final List<DataGridRow> _dataGridRows = [];
  final BuildContext _context;
  final SeasonEpisodePageCubit _cubit;
  final int seasonId;
  final int seriesId;

  final List<ValueNotifier<bool>> _hoveringItems = [];

  SeasonEpisodeDataGrid(
      {List<Episode>? episode,
      required BuildContext context,
      required SeasonEpisodePageCubit cubit,
      required this.seasonId,
      required this.seriesId})
      : _context = context,
        _cubit = cubit {
    if (episode != null) {
      buildDataGridRows(episode: episode);
    }
  }

  void buildDataGridRows({required List<Episode> episode}) {
    for (var h in _hoveringItems) {
      h.dispose();
    }
    _hoveringItems.clear();
    _dataGridRows.clear();
    for (var dataGridRow in episode) {
      _hoveringItems.add(ValueNotifier(false));
      _dataGridRows.add(DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
        DataGridCell<Episode>(columnName: 'episode', value: dataGridRow),
        DataGridCell<String>(
            columnName: 'releaseDate', value: dataGridRow.publicationDate),
        DataGridCell<int>(
            columnName: 'commentsCount', value: dataGridRow.commentsCount),
      ]));
    }
  }

  @override
  void dispose() {
    for (var h in _hoveringItems) {
      h.dispose();
    }
    _hoveringItems.clear();
    super.dispose();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int index = effectiveRows.indexOf(row);
    return DataGridRowAdapter(
        color: index % 2 == 0
            ? Theme.of(_context).colorScheme.surfaceContainerLow
            : Theme.of(_context).colorScheme.surfaceContainer,
        cells: row.getCells().map((dataGridCell) {
          if (dataGridCell.columnName == 'releaseDate') {
            var jDate =
                DateTime.parse(dataGridCell.value.toString()).toJalali();
            var f = jDate.formatter;
            return MouseRegion(
              onEnter: (_) {
                if (_hoveringItems[index].value == false) {
                  _hoveringItems[index].value = !_hoveringItems[index].value;
                }
              },
              onExit: (_) {
                if (_hoveringItems[index].value == true) {
                  _hoveringItems[index].value = !_hoveringItems[index].value;
                }
              },
              child: Align(
                child: Text('${f.yyyy}/${f.mm}/${f.dd}',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(_context).textTheme.labelMedium),
              ),
            );
          } else if (dataGridCell.columnName == "episode") {
            Episode episode = dataGridCell.value;
            return MouseRegion(
                onEnter: (_) {
                  if (_hoveringItems[index].value == false) {
                    _hoveringItems[index].value = !_hoveringItems[index].value;
                  }
                },
                onExit: (_) {
                  if (_hoveringItems[index].value == true) {
                    _hoveringItems[index].value = !_hoveringItems[index].value;
                  }
                },
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                          "${episode.thumbnail}")),
                                ),
                                if (episode.humanizeTime != null)
                                  Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: const Color.fromRGBO(
                                                  0, 0, 0, 0.8)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Text(episode.humanizeTime!,
                                                style: Theme.of(_context)
                                                    .textTheme
                                                    .labelMedium
                                                    ?.copyWith(
                                                        color: Colors.white)),
                                          )))
                              ],
                            )),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ValueListenableBuilder(
                              valueListenable: _hoveringItems[index],
                              builder: (BuildContext context, bool value,
                                  Widget? child) {
                                return Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        episode.name != null
                                            ? "قسمت ${episode.number}: ${episode.name}"
                                            : "قسمت ${episode.number}",
                                        style: Theme.of(_context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                                color: Theme.of(_context)
                                                    .colorScheme
                                                    .onSurface)),
                                    if (!value) ...[
                                      const SizedBox(height: 4),
                                      Text(episode.synopsis ?? "",
                                          style: Theme.of(_context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                  color: Theme.of(_context)
                                                      .colorScheme
                                                      .onSurfaceVariant),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          textAlign: TextAlign.justify)
                                    ] else ...[
                                      const Expanded(child: SizedBox()),
                                      Wrap(
                                        runAlignment: WrapAlignment.center,
                                        alignment: WrapAlignment.center,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        spacing: 8,
                                        runSpacing: 4,
                                        children: [
                                          IconButton(
                                            tooltip: "جزئیات",
                                            onPressed: () {
                                              _context.go(
                                                  format(
                                                      RoutePath.detailEpisode
                                                          .fullPath,
                                                      {
                                                        'episodeId':
                                                            dataGridCell
                                                                .value.id,
                                                        "seasonId": seasonId,
                                                        "seriesId": seriesId
                                                      }),
                                                  extra: _cubit);
                                            },
                                            icon: const Icon(
                                              Icons.message_rounded,
                                            ),
                                            style: ButtonStyle(
                                                shape: WidgetStateProperty.all(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)))),
                                          ),
                                          IconButton(
                                            tooltip: "ویرایش",
                                            onPressed: () {
                                              _context.go(
                                                  format(
                                                      RoutePath
                                                          .editEpisode.fullPath,
                                                      {
                                                        'episodeId':
                                                            dataGridCell
                                                                .value.id,
                                                        "seasonId": seasonId,
                                                        "seriesId": seriesId
                                                      }),
                                                  extra: _cubit);
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                            ),
                                            style: ButtonStyle(
                                                shape: WidgetStateProperty.all(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)))),
                                          ),
                                          IconButton(
                                            tooltip: "حذف",
                                            onPressed: () {
                                              showDialog(
                                                  context: _context,
                                                  builder: (dialogContext) =>
                                                      AlertDialog(
                                                          title: Text(
                                                            "حذف قسمت",
                                                            style: Theme.of(
                                                                    dialogContext)
                                                                .textTheme
                                                                .headlineSmall,
                                                          ),
                                                          content: Text(
                                                              "آیا از حذف قسمت با شناسه ${dataGridCell.value.id} اظمینان دارید؟",
                                                              style: Theme.of(
                                                                      dialogContext)
                                                                  .textTheme
                                                                  .bodyMedium),
                                                          actions: [
                                                            OutlinedButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        dialogContext)
                                                                    .pop();
                                                              },
                                                              style:
                                                                  ButtonStyle(
                                                                textStyle: WidgetStateProperty
                                                                    .all(Theme.of(
                                                                            dialogContext)
                                                                        .textTheme
                                                                        .labelSmall),
                                                                padding: WidgetStateProperty.all(
                                                                    const EdgeInsets
                                                                        .all(
                                                                        16)),
                                                                shape: WidgetStateProperty.all(
                                                                    RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(4))),
                                                              ),
                                                              child: const Text(
                                                                "انصراف",
                                                              ),
                                                            ),
                                                            FilledButton(
                                                                style: ButtonStyle(
                                                                    textStyle: WidgetStateProperty.all(Theme.of(
                                                                            dialogContext)
                                                                        .textTheme
                                                                        .labelSmall),
                                                                    padding: WidgetStateProperty.all(
                                                                        const EdgeInsets
                                                                            .all(
                                                                            16)),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    shape: WidgetStateProperty.all(
                                                                        RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(4)))),
                                                                onPressed: () {
                                                                  _cubit.delete(
                                                                      id: dataGridCell
                                                                          .value
                                                                          .id,
                                                                      seasonId:
                                                                          seasonId);
                                                                  Navigator.of(
                                                                          dialogContext)
                                                                      .pop();
                                                                },
                                                                child: const Text(
                                                                  "بله",
                                                                )),
                                                          ]));
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                            ),
                                            style: ButtonStyle(
                                                shape: WidgetStateProperty.all(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)))),
                                          ),
                                        ],
                                      )
                                    ]
                                  ],
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    )));
          }
          return MouseRegion(
            onEnter: (_) {
              if (_hoveringItems[index].value == false) {
                _hoveringItems[index].value = !_hoveringItems[index].value;
              }
            },
            onExit: (_) {
              if (_hoveringItems[index].value == true) {
                _hoveringItems[index].value = !_hoveringItems[index].value;
              }
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(dataGridCell.value.toString(),
                    textAlign: TextAlign.justify,
                    style: Theme.of(_context).textTheme.labelMedium),
              ),
            ),
          );
        }).toList());
  }
}
