import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/advertise/data/repositories/advertise_repository.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/ads.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:flutter/material.dart';

part 'advertise_table_state.dart';

class AdvertiseTableCubit extends Cubit<AdvertiseTableState> {
  final AdvertiseRepository _repository;

  AdvertiseTableCubit({required AdvertiseRepository repository})
      : _repository = repository,
        super(const AdvertiseTableLoading());

  Future<void> getData({int page = 1}) async {
    emit(
        AdvertiseTableLoading(numberPages: state.numberPages, pageIndex: page));
    DataResponse<PageResponse<Advertise>> response =
        await _repository.getAdvertises(page: page);
    if (response is DataFailed) {
      emit(AdvertiseTableError(
          title: "خطا در دریافت تبلیغ ها",
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: page,
          numberPages: state.numberPages));
    } else {
      emit(AdvertiseTableSuccess(
          data: response.data!,
          numberPages: response.data!.totalPages!,
          pageIndex: page));
    }
  }

  Future<void> delete({required int id}) async {
    emit(AdvertiseTableLoading(
        numberPages: state.numberPages, pageIndex: state.pageIndex));
    DataResponse<void> response = await _repository.deleteAdvertise(id: id);
    if (response is DataFailed) {
      emit(AdvertiseTableError(
          title: "خطا در حذف تبلیغ",
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: state.pageIndex,
          numberPages: state.numberPages));
    } else {
      getData(page: state.pageIndex);
    }
  }
}
