import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/slider.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:flutter/material.dart';

part 'sliders_table_state.dart';

class SlidersTableCubit extends Cubit<SlidersTableState> {
  final MediaRepository _repository;

  SlidersTableCubit({required MediaRepository repository})
      : _repository = repository,
        super(const SlidersTableLoading());

  Future<void> getData({int page = 1}) async {
    emit(SlidersTableLoading(numberPages: state.numberPages, pageIndex: page));
    DataResponse<PageResponse<SliderModel>> response =
        await _repository.getSliders(page: page);
    if (response is DataFailed) {
      emit(SlidersTableError(
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: page,
          numberPages: state.numberPages));
    } else {
      emit(SlidersTableSuccess(
          data: response.data!,
          numberPages: response.data!.totalPages!,
          pageIndex: page));
    }
  }
}
