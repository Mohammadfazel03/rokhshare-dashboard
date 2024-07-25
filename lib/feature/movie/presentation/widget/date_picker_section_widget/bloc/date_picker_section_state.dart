part of 'date_picker_section_cubit.dart';

class DatePickerSectionState {
  final DateTime selectedDate;
  final String? error;

  DatePickerSectionState({required this.selectedDate, required this.error});

  DatePickerSectionState copyWith({DateTime? selectedDate, String? error}) {
    return DatePickerSectionState(
        error: error ?? this.error,
        selectedDate: selectedDate ?? this.selectedDate);
  }

  DatePickerSectionState clearError() {
    return DatePickerSectionState(
        error: null,
        selectedDate: selectedDate);
  }
}
