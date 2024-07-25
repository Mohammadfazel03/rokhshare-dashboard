import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/media/data/remote/model/collection.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:flutter/material.dart';

part 'collections_table_state.dart';

class CollectionsTableCubit extends Cubit<CollectionsTableState> {
  final MediaRepository _repository;

  CollectionsTableCubit({required MediaRepository repository})
      : _repository = repository,
        super(const CollectionsTableLoading());

  Future<void> getData({int page = 1}) async {
    emit(CollectionsTableLoading(numberPages: state.numberPages, pageIndex: page));
    DataResponse<PageResponse<Collection>> response =
        await _repository.getCollections(page: page);
    if (response is DataFailed) {
      emit(CollectionsTableError(
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: page,
          numberPages: state.numberPages));
    } else {
      emit(CollectionsTableSuccess(
          data: response.data!,
          numberPages: response.data!.totalPages!,
          pageIndex: page));
    }
  }
}
