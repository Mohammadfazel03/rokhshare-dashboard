import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/slider.dart';
import 'package:dashboard/feature/dashboard/data/repositories/dashboard_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:meta/meta.dart';

part 'first_screen_slider_state.dart';

class FirstScreenSliderCubit extends Cubit<FirstScreenSliderState> {
  final DashboardRepository _repository;

  FirstScreenSliderCubit({required DashboardRepository repository})
      : _repository = repository,
        super(FirstScreenSliderLoading());

  Future<void> getData() async {
    emit(FirstScreenSliderLoading());
    DataResponse<List<SliderModel>> response = await _repository.getSlider();
    if (response is DataFailed) {
      emit(FirstScreenSliderError(
          error: response.error ?? "مشکلی پیش آمده است", code: response.code));
    } else {
      emit(FirstScreenSliderSuccessful(data: response.data!));
    }
  }
}
