import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/media/data/remote/model/country.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:meta/meta.dart';

part 'country_append_state.dart';

class CountryAppendCubit extends Cubit<CountryAppendState> {
  final MediaRepository _repository;

  CountryAppendCubit({required MediaRepository repository})
      : _repository = repository,
        super(CountryAppendInitial());

  Future<void> saveCountry({name, flag}) async {
    emit(CountryAppendLoading());
    DataResponse<Country> response =
    await _repository.postCountry(name: name, flag: flag);
    if (response is DataFailed) {
      emit(CountryAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(CountryAppendSuccessAppend());
    }
  }

  Future<void> getCountry({required int id}) async {
    emit(CountryAppendLoading());
    DataResponse<Country> response = await _repository.getCountry(id: id);
    if (response is DataFailed) {
      emit(CountryAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(CountryAppendSuccess(
          country: response.data!
      ));
    }
  }

  Future<void> updateCountry({required int id, flag, name}) async {
    emit(CountryAppendLoading());
    DataResponse<Country> response =
    await _repository.updateCountry(id: id, name: name, flag: flag);
    if (response is DataFailed) {
      emit(CountryAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(CountryAppendSuccessUpdate());
    }
  }
}
