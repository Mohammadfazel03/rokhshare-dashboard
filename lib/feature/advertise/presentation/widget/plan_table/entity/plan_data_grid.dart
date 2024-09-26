import 'dart:math';

import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/advertise/presentation/widget/plan_table/bloc/plan_append_cubit.dart';
import 'package:dashboard/feature/advertise/presentation/widget/plan_table/bloc/plan_table_cubit.dart';
import 'package:dashboard/feature/advertise/presentation/widget/plan_table/plan_append_dialog_widget.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/plan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PlanDataGrid extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final BuildContext _context;
  final PlanTableCubit _cubit;

  PlanDataGrid(
      {List<Plan>? plans,
      required BuildContext context,
      required PlanTableCubit cubit})
      : _context = context,
        _cubit = cubit {
    if (plans != null) {
      buildDataGridRows(plans: plans);
    }
  }

  void buildDataGridRows({required List<Plan> plans}) {
    _dataGridRows = plans.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'title', value: dataGridRow.title),
        DataGridCell<int>(columnName: 'time', value: dataGridRow.days),
        DataGridCell<int>(columnName: 'price', value: dataGridRow.price),
        DataGridCell<bool>(columnName: 'status', value: dataGridRow.isEnable),
        DataGridCell<int>(columnName: 'actions', value: dataGridRow.id),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map((dataGridCell) {
      if (dataGridCell.columnName == "actions") {
        bool state = row
            .getCells()
            .firstWhere((dataGridCell) => dataGridCell.columnName == "status")
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
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton.filled(
                  tooltip: 'مشاهده',
                  onPressed: () {
                    showDialog(
                        context: _context,
                        builder: (BuildContext dialogContext) {
                          return Dialog(
                            clipBehavior: Clip.hardEdge,
                            child: SizedBox(
                                width: min(
                                    MediaQuery.sizeOf(_context).width * 0.8,
                                    560),
                                child: MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(value: _cubit),
                                    BlocProvider<PlanAppendCubit>(
                                        create: (context) => PlanAppendCubit(
                                            repository: getIt.get())),
                                  ],
                                  child: PlanAppendDialogWidget(
                                      id: dataGridCell.value,
                                      width: min(
                                          MediaQuery.sizeOf(_context).width *
                                              0.8,
                                          560)),
                                )),
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.remove_red_eye_rounded,
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
                  tooltip: state ? "غیرفعال سازی" : 'فعال سازی',
                  onPressed: () {
                    showDialog(
                        context: _context,
                        builder: (dialogContext) => AlertDialog(
                                title: Text(
                                  state ? "غیر فعال کردن ظرح" : "فعال کردن ظرح",
                                  style: Theme.of(dialogContext)
                                      .textTheme
                                      .headlineSmall,
                                ),
                                content: Text(
                                    state
                                        ? "آیا از غیر فعال کردن طرح با شناسه ${dataGridCell.value} اظمینان دارید؟"
                                        : "آیا از فعال کردن طرح با شناسه ${dataGridCell.value} اظمینان دارید؟",
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
                                                  BorderRadius.circular(4))),
                                    ),
                                    child: const Text(
                                      "انصراف",
                                    ),
                                  ),
                                  FilledButton(
                                      style: ButtonStyle(
                                          textStyle: WidgetStateProperty.all(
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
                                        _cubit.changeState(
                                            id: dataGridCell.value,
                                            isEnable: !state);
                                        Navigator.of(dialogContext).pop();
                                      },
                                      child: const Text(
                                        "بله",
                                      )),
                                ]));
                  },
                  icon: Icon(
                    state ? Icons.do_not_disturb_alt : Icons.check,
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
      } else if (dataGridCell.columnName == "price") {
        return Center(
          child: Text("${dataGridCell.value} تومان",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(_context).textTheme.labelMedium),
        );
      } else if (dataGridCell.columnName == "time") {
        return Center(
          child: Text("${dataGridCell.value} روز",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(_context).textTheme.labelMedium),
        );
      } else if (dataGridCell.columnName == "status") {
        return Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: dataGridCell.value
                    ? CustomColor.successBadgeBackgroundColor.getColor(_context)
                    : CustomColor.errorBadgeBackgroundColor.getColor(_context),
                borderRadius: BorderRadius.circular(4)),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                dataGridCell.value ? "فعال" : "غیر فعال",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(_context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dataGridCell.value
                        ? CustomColor.successBadgeTextColor.getColor(_context)
                        : CustomColor.errorBadgeTextColor.getColor(_context)),
              ),
            ),
          ),
        );
      }
      return Center(
        child: Text(dataGridCell.value.toString(),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(_context).textTheme.labelMedium),
      );
    }).toList());
  }
}
