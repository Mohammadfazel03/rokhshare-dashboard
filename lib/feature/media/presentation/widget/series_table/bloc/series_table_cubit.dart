import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/media/data/remote/model/series.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:flutter/material.dart';

part 'series_table_state.dart';

class SeriesTableCubit extends Cubit<SeriesTableState> {
  final MediaRepository _repository;

  SeriesTableCubit({required MediaRepository repository})
      : _repository = repository,
        super(const SeriesTableLoading());

  Future<void> getData({int page = 1}) async {
    emit(SeriesTableLoading(numberPages: state.numberPages, pageIndex: page));
    DataResponse<PageResponse<Series>> response =
        await _repository.getSeries(page: page);
    if (response is DataFailed) {
      emit(SeriesTableError(
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: page,
          numberPages: state.numberPages));
    } else {
      emit(SeriesTableSuccess(
          data: response.data!,
          numberPages: response.data!.totalPages!,
          pageIndex: page));
    }
  }

  void refreshPage() {
    getData(page: state.pageIndex);
  }
}
