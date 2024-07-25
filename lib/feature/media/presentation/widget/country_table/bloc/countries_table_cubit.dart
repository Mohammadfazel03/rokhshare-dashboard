import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/media/data/remote/model/country.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:flutter/material.dart';

part 'countries_table_state.dart';

class CountriesTableCubit extends Cubit<CountriesTableState> {
  final MediaRepository _repository;

  CountriesTableCubit({required MediaRepository repository})
      : _repository = repository,
        super(const CountriesTableLoading());

  Future<void> getData({int page = 1}) async {
    emit(
        CountriesTableLoading(numberPages: state.numberPages, pageIndex: page));
    DataResponse<PageResponse<Country>> response =
        await _repository.getCountries(page: page);
    if (response is DataFailed) {
      emit(CountriesTableError(
          title: "خطا در دریافت کشور ها",
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: page,
          numberPages: state.numberPages));
    } else {
      emit(CountriesTableSuccess(
          data: response.data!,
          numberPages: response.data!.totalPages!,
          pageIndex: page));
    }
  }

  Future<void> delete({required int id}) async {
    emit(CountriesTableLoading(
        numberPages: state.numberPages, pageIndex: state.pageIndex));
    DataResponse<void> response = await _repository.deleteCountry(id: id);
    if (response is DataFailed) {
      emit(CountriesTableError(
          title: "خطا در حذف ژانر",
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: state.pageIndex,
          numberPages: state.numberPages));
    } else {
      getData(page: state.pageIndex);
    }
  }
}
