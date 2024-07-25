import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/media/data/remote/model/movie.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:flutter/material.dart';

part 'movies_table_state.dart';

class MoviesTableCubit extends Cubit<MoviesTableState> {
  final MediaRepository _repository;

  MoviesTableCubit({required MediaRepository repository})
      : _repository = repository,
        super(const MoviesTableLoading());

  Future<void> getData({int page = 1}) async {
    emit(MoviesTableLoading(numberPages: state.numberPages, pageIndex: page));
    DataResponse<PageResponse<Movie>> response =
        await _repository.getMovies(page: page);
    if (response is DataFailed) {
      emit(MoviesTableError(
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: page,
          numberPages: state.numberPages));
    } else {
      emit(MoviesTableSuccess(
          data: response.data!,
          numberPages: response.data!.totalPages!,
          pageIndex: page));
    }
  }
}
