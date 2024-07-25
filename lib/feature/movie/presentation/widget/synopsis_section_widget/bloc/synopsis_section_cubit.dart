import 'package:bloc/bloc.dart';

part 'synopsis_section_state.dart';

class SynopsisSectionCubit extends Cubit<SynopsisSectionState> {
  SynopsisSectionCubit() : super(SynopsisSectionState(error: null));


  void setError(String error) {
    emit(SynopsisSectionState(error: error));
  }

  void clearError() {
    if (state.error != null) {
      emit(SynopsisSectionState(error: null));
    }
  }
}
