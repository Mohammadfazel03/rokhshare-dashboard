import 'package:bloc/bloc.dart';

part 'value_section_state.dart';

class ValueSectionCubit extends Cubit<ValueSectionState> {
  ValueSectionCubit()
      : super(ValueSectionState(selectedValue: null, error: null));

  void setError(String error) {
    emit(state.copyWith(error: error));
  }

  void clearError() {
    if (state.error != null) {
      emit(state.clearError());
    }
  }

  void selectValue(MediaValue? value) {
    emit(ValueSectionState(
        selectedValue: value ?? state.selectedValue, error: null));
  }
}
