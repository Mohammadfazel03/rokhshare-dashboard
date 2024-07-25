import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/media/data/remote/model/genre.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:flutter/material.dart';

part 'genre_append_state.dart';

class GenreAppendCubit extends Cubit<GenreAppendState> {
  final MediaRepository _repository;

  GenreAppendCubit({required MediaRepository repository})
      : _repository = repository,
        super(GenreAppendInitial());

  Future<void> saveGenre({title, poster}) async {
    emit(GenreAppendLoading());
    DataResponse<Genre> response =
    await _repository.postGenre(title: title, poster: poster);
    if (response is DataFailed) {
      emit(GenreAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(GenreAppendSuccessAppend());
    }
  }

  Future<void> getGenre({required int id}) async {
    emit(GenreAppendLoading());
    DataResponse<Genre> response = await _repository.getGenre(id: id);
    if (response is DataFailed) {
      emit(GenreAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(GenreAppendSuccess(
          genre: response.data!
      ));
    }
  }

  Future<void> updateGenre({required int id, poster, title}) async {
    emit(GenreAppendLoading());
    DataResponse<Genre> response =
    await _repository.updateGenre(id: id, title: title, poster: poster);
    if (response is DataFailed) {
      emit(GenreAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(GenreAppendSuccessUpdate());
    }
  }
}
