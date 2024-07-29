import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/movie/presentation/widget/artists_section_widget/entity/cast.dart';

part 'artist_section_state.dart';

class ArtistSectionCubit extends Cubit<ArtistSectionState> {
  ArtistSectionCubit()
      : super(const ArtistSectionState(
            casts: [], selectedRole: null, error: null));

  void addCast(Cast cast) {
    var temp = List.of(state.casts)..add(cast);
    emit(ArtistSectionState(
        casts: temp,
        selectedRole: null,
        error: null));
  }

  void selectRole(Position? role) {
    emit(state.copyWith(selectedRole: role));
  }

  void removeCast(index) {
    emit(state.copyWith(casts: List.of(state.casts)..removeAt(index)));
  }

  void setError(String error) {
    emit(state.copyWith(error: error));
  }

  void clearError() {
    if (state.error != null) {
      emit(state.clearError());
    }
  }

  void initialSelectedItem(List<Cast> casts) {
    var selectedItems = List.of(casts);
    emit(state.copyWith(casts: selectedItems));
  }
}
