import 'dart:math';
import 'package:dashboard/feature/movie/presentation/widget/date_picker_section_widget/bloc/date_picker_section_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePickerSectionWidget extends StatelessWidget {
  final DateRangePickerController _datePickerController;

  DatePickerSectionWidget(
      {super.key, DateRangePickerController? datePickerController})
      : _datePickerController =
            datePickerController ?? DateRangePickerController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatePickerSectionCubit, DatePickerSectionState>(
      builder: (context, state) {
        return InputDecorator(
          decoration: const InputDecoration(
            labelText: 'تاریخ انتشار',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Icon(Icons.calendar_today),
          ),
          isEmpty: false,
          child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return Dialog(
                          clipBehavior: Clip.hardEdge,
                          child: SizedBox(
                              width: min(
                                  MediaQuery.sizeOf(context).width * 0.9, 360),
                              child: _dialog(context, state.selectedDate)));
                    });
              },
              child:
                  Text(DateFormat.yMMMMd('fa_IR').format(state.selectedDate))),
        );
      },
    );
  }

  Widget _dialog(BuildContext mainContext, DateTime initialDate) {
    return Container(
      color: Theme.of(mainContext).colorScheme.surfaceContainerHigh,
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (BuildContext context,
              void Function(void Function()) dialogSetState) {
            var f = DateFormat("EEE, d MMM", "fa")
                .format(_datePickerController.selectedDate ?? initialDate);
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "تاریخ انتشار",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: 48),
                Text(
                  f,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                SfDateRangePicker(
                  controller: _datePickerController,
                  showNavigationArrow: true,
                  showActionButtons: false,
                  showTodayButton: false,
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHigh,
                  headerStyle: DateRangePickerHeaderStyle(
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceContainerHigh),
                  monthViewSettings: DateRangePickerMonthViewSettings(
                      numberOfWeeksInView: 5,
                      firstDayOfWeek: 6,
                      showTrailingAndLeadingDates: false,
                      weekendDays: const [4, 5],
                      viewHeaderStyle: DateRangePickerViewHeaderStyle(
                          textStyle: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant))),
                  onSelectionChanged: (a) {
                    dialogSetState(() {});
                  },
                ),
                const Divider(),
                _actionBar(mainContext)
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _actionBar(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              // Navigator.of(context).pop();
            },
            style: ButtonStyle(
              textStyle: WidgetStateProperty.all(
                  Theme.of(context).textTheme.labelLarge),
            ),
            child: const Text(
              "انصراف",
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
              style: ButtonStyle(
                  textStyle: WidgetStateProperty.all(
                      Theme.of(context).textTheme.labelLarge)),
              onPressed: () {
                context
                    .read<DatePickerSectionCubit>()
                    .setDate(_datePickerController.selectedDate);
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text(
                "ثبت",
              )),
        ],
      );
}
