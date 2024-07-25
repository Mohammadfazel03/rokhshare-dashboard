import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/media/data/remote/model/country.dart';
import 'package:dashboard/feature/movie/data/repositories/movie_repository.dart';
import 'package:dashboard/utils/data_response.dart';

part 'country_multi_selector_state.dart';

class CountryMultiSelectorCubit extends Cubit<CountryMultiSelectorState> {
  final MovieRepository _repository;

  CountryMultiSelectorCubit({required MovieRepository repository})
      : _repository = repository,
        super(const CountryMultiSelectorState(
            status: CountryMultiSelectorStatus.loading, selectedItem: []));

  Future<void> getData() async {
    emit(const CountryMultiSelectorState(
        status: CountryMultiSelectorStatus.loading, selectedItem: []));
    DataResponse<List<Country>> response = await _repository.getCountries();
    if (response is DataFailed) {
      emit(CountryMultiSelectorState(
          status: CountryMultiSelectorStatus.fail,
          selectedItem: const [],
          error: response.error,
          code: response.code,
          titleError: "خطا در دریافت ژانر ها"));
    } else {
      emit(CountryMultiSelectorState(
          status: CountryMultiSelectorStatus.success,
          selectedItem: const [],
          data: response.data));
    }
  }

  void selectItem(Country? item) {
    if (item != null) {
      var selectedItems = List.of(state.selectedItem);
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }
      emit(CountryMultiSelectorState(
          status: CountryMultiSelectorStatus.success,
          selectedItem: selectedItems,
          data: List.of(state.data ?? [])));
    }
  }

  void setError(String title, String error) {
    emit(state.setError(title, error, 1));
  }

  void clearError() {
    if (state.status == CountryMultiSelectorStatus.success &&
        state.error != null) {
      emit(state.clearError());
    }
  }
}
