import 'package:bloc/bloc.dart';

part 'title_section_state.dart';

class TitleSectionCubit extends Cubit<TitleSectionState> {
  TitleSectionCubit() : super(TitleSectionState(error: null));


  void setError(String error) {
    emit(TitleSectionState(error: error));
  }

  void clearError() {
    if (state.error != null) {
      emit(TitleSectionState(error: null));
    }
  }
}
