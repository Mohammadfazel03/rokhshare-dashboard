import 'dart:math';

import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/dio_config.dart';
import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/slider.dart';
import 'package:dashboard/feature/media/data/remote/model/collection.dart';
import 'package:dashboard/feature/media/presentation/widget/collections_table/bloc/collection_append_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/collections_table/bloc/collections_table_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/collections_table/collection_append_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:format/format.dart';
import 'package:go_router/go_router.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:vector_graphics/vector_graphics.dart';

class CollectionDataGrid extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final BuildContext _context;
  final CollectionsTableCubit _cubit;

  CollectionDataGrid({List<Collection>? collections,
    required BuildContext context,
    required CollectionsTableCubit cubit})
      : _cubit = cubit,
        _context = context {
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
        DataGridCell<CollectionState>(
            columnName: 'status', value: dataGridRow.state),
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
                      "$baseUrl${dataGridCell.value.poster}",
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
          } else if (dataGridCell.columnName == "actions") {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (dataGridCell.value.state != CollectionState.accept) ...[
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton.filled(
                        tooltip: "انتشار",
                        onPressed: () {
                          _cubit.changeState(
                              collectionId: dataGridCell.value.id,
                              collectionState: CollectionState.accept);
                        },
                        icon: const Icon(
                          Icons.check,
                          size: 16,
                        ),
                        style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)))),
                      ),
                    ),
                  ],
                  if (dataGridCell.value.state != CollectionState.reject) ...[
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton.filled(
                        tooltip: "رفع انتشار",
                        onPressed: () {
                          _cubit.changeState(
                              collectionId: dataGridCell.value.id,
                              collectionState: CollectionState.reject);
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 16,
                        ),
                        style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)))),
                      ),
                    ),
                  ],
                  if (dataGridCell.value.canEdit == true) ...[
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton.filled(
                        tooltip: "فیلم و سریال ها",
                        onPressed: () {
                          _context.go(format(RoutePath.collection.fullPath,
                              {'collectionId': dataGridCell.value.id}));
                        },
                        icon: SvgPicture(
                          const AssetBytesLoader(
                              'assets/svg/collection.svg.vec'),
                          height: 16,
                          width: 16,
                          colorFilter: ColorFilter.mode(
                              Theme.of(_context).colorScheme.onPrimary,
                              BlendMode.srcIn),
                        ),
                        style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)))),
                      ),
                    )
                  ],
                  if (dataGridCell.value.canEdit == true) ...[
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton.filled(
                        tooltip: "ویرایش",
                        onPressed: () {
                          showDialog(
                              context: _context,
                              builder: (BuildContext dialogContext) {
                                return Dialog(
                                  clipBehavior: Clip.hardEdge,
                                  child: SizedBox(
                                      width: min(
                                          MediaQuery.sizeOf(_context).width *
                                              0.8,
                                          560),
                                      child: MultiBlocProvider(
                                        providers: [
                                          BlocProvider.value(value: _cubit),
                                          BlocProvider<CollectionAppendCubit>(
                                              create: (context) =>
                                                  CollectionAppendCubit(
                                                      repository: getIt.get())),
                                        ],
                                        child: CollectionAppendDialogWidget(
                                            id: dataGridCell.value.id,
                                            width: min(
                                                MediaQuery.sizeOf(_context)
                                                        .width *
                                                    0.8,
                                                560)),
                                      )),
                                );
                              });
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 16,
                        ),
                        style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
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
                                        "حذف مجموعه",
                                        style: Theme.of(dialogContext)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                      content: Text(
                                          "آیا از حذف مجموعه با شناسه ${dataGridCell.value.id} اظمینان دارید؟",
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
                                                padding:
                                                    WidgetStateProperty.all(
                                                        const EdgeInsets.all(
                                                            16)),
                                                alignment: Alignment.center,
                                                shape: WidgetStateProperty.all(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4)))),
                                            onPressed: () {
                                              _cubit.delete(
                                                  id: dataGridCell.value.id);
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
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)))),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }
          if (dataGridCell.columnName == "status") {
            return Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: dataGridCell.value == CollectionState.accept
                        ? CustomColor.successBadgeBackgroundColor
                            .getColor(_context)
                        : dataGridCell.value == CollectionState.pending
                            ? CustomColor.warningBadgeBackgroundColor
                                .getColor(_context)
                            : CustomColor.errorBadgeBackgroundColor
                                .getColor(_context),
                    borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    dataGridCell.value == CollectionState.accept
                        ? "تایید شده"
                        : dataGridCell.value == CollectionState.pending
                            ? "در انتظار برسی"
                            : "رد شده",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(_context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: dataGridCell.value == CollectionState.accept
                            ? CustomColor.successBadgeTextColor
                                .getColor(_context)
                            : dataGridCell.value == CollectionState.pending
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
