import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/media/data/remote/model/artist.dart';
import 'package:dashboard/feature/movie/data/repositories/movie_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/error_entity.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'artists_autocomplete_state.dart';

class ArtistsAutocompleteCubit extends Cubit<PagingState<int, Artist>> {
  final MovieRepository _repository;

  ArtistsAutocompleteCubit({required MovieRepository repository})
      : _repository = repository,
        super(PagingState());


  void refresh() {
    emit(state.reset());
  }

  Future<void> getData({String? search}) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    DataResponse<PageResponse<Artist>> response =
    await _repository.getArtists(page: state.keys?.last ?? 1, search: search);
    if (response is DataFailed) {
      emit(state.copyWith(
          isLoading: false,
          error: ErrorEntity(
              title: "خطا در دریافت هنرمندان",
              error: response.error ?? "مشکلی پیش آمده است",
              code: response.code)));
    } else {
      final newKey = (state.keys?.last ?? 0) + 1;
      emit(state.copyWith(
          error: null,
          isLoading: false,
          pages: [...?state.pages, response.data!.results ?? []],
          keys: [...?state.keys, newKey],
          hasNextPage: response.data!.totalPages! > newKey));
    }
  }
}
