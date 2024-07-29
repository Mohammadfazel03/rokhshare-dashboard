import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/media/data/remote/model/genre.dart';
import 'package:dashboard/feature/movie/data/repositories/movie_repository.dart';
import 'package:dashboard/utils/data_response.dart';

part 'genre_section_state.dart';

class GenreSectionCubit extends Cubit<GenreSectionState> {
  final MovieRepository _repository;

  GenreSectionCubit({required MovieRepository repository})
      : _repository = repository,
        super(const GenreSectionState(
            status: GenreSectionStatus.loading, selectedItem: []));

  Future<void> getData() async {
    emit(const GenreSectionState(
        status: GenreSectionStatus.loading, selectedItem: []));
    DataResponse<List<Genre>> response = await _repository.getGenres();
    if (response is DataFailed) {
      emit(state.copyWith(
          status: GenreSectionStatus.fail,
          error: response.error,
          code: response.code,
          titleError: "خطا در دریافت ژانر ها"));
    } else {
      emit(state.copyWith(
          status: GenreSectionStatus.success, data: response.data));
    }
  }

  void selectItem(Genre? item) {
    if (item != null) {
      var selectedItems = List.of(state.selectedItem);
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }
      emit(GenreSectionState(
          status: GenreSectionStatus.success,
          selectedItem: selectedItems,
          data: List.of(state.data ?? [])));
    }
  }

  void setError(String title, String error) {
    emit(state.setError(title, error, 1));
  }

  void clearError() {
    if (state.status == GenreSectionStatus.success && state.error != null) {
      emit(state.clearError());
    }
  }

  void initialSelectedItem(List<Genre> genres) {
    var selectedItems = List.of(genres);
    emit(state.copyWith(selectedItem: selectedItems));
  }
}
