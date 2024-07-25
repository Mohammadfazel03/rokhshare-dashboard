import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/media/data/remote/model/artist.dart';
import 'package:dashboard/feature/movie/data/repositories/movie_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:flutter/material.dart';

part 'artists_autocomplete_state.dart';

class ArtistsAutocompleteCubit extends Cubit<ArtistsAutocompleteState> {
  final MovieRepository _repository;

  ArtistsAutocompleteCubit({required MovieRepository repository})
      : _repository = repository,
        super(const ArtistsAutocompleteLoading());

  Future<void> getData({int page = 1, String? search}) async {
    emit(ArtistsAutocompleteLoading(numberPages: state.numberPages, pageIndex: page));
    DataResponse<PageResponse<Artist>> response =
        await _repository.getArtists(page: page, search: search);
    if (response is DataFailed) {
      emit(ArtistsAutocompleteError(
          title: "خطا در دریافت هنرمندان",
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: page,
          numberPages: state.numberPages));
    } else {
      emit(ArtistsAutocompleteSuccess(
          data: response.data!,
          numberPages: response.data!.totalPages!,
          pageIndex: page));
    }
  }
}
