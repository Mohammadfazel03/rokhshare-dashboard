import 'package:bloc/bloc.dart';

part 'date_picker_section_state.dart';

class DatePickerSectionCubit extends Cubit<DatePickerSectionState> {
  DatePickerSectionCubit()
      : super(
            DatePickerSectionState(selectedDate: DateTime.now(), error: null));

  void setError(String error) {
    emit(state.copyWith(error: error));
  }

  void clearError() {
    if (state.error != null) {
      emit(state.clearError());
    }
  }

  void setDate(DateTime? datetime) {
    emit(state.copyWith(selectedDate: datetime));
  }
}
