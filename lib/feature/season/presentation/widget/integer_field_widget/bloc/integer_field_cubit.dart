import 'package:bloc/bloc.dart';

part 'integer_field_state.dart';

class IntegerFieldCubit extends Cubit<IntegerFieldState> {
  IntegerFieldCubit() : super(IntegerFieldState(error: null));

  void setError(String error) {
    emit(IntegerFieldState(error: error));
  }

  void clearError() {
    if (state.error != null) {
      emit(IntegerFieldState(error: null));
    }
  }
}
