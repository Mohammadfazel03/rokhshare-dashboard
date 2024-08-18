import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/media_collection/data/repositories/media_collection_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/debouncer.dart';
import 'package:dashboard/utils/page_response.dart';

import '../../../../../movie/data/remote/model/movie.dart';

part 'media_autocomplete_field_state.dart';

class MediaAutocompleteFieldCubit extends Cubit<MediaAutocompleteFieldState> {
  final MediaCollectionRepository _repository;
  final Debounce _debounce;

  MediaAutocompleteFieldCubit({required MediaCollectionRepository repository})
      : _repository = repository,
        _debounce = Debounce(milliseconds: 1000),
        super(const MediaAutocompleteFieldState());

  @override
  Future<void> close() async {
    _debounce.dispose();
    super.close();
  }

  Future<void> fetchMoreSuggestions(
      {String? query, int? page, bool retry = false}) async {
    if ((state.nextPage > state.lastPage && page == null) ||
        (state.status == PostStatus.loading && page == null) ||
        (state.status == PostStatus.failure && !retry)) {
      return;
    }
    var hash = generateRandomHash(10);
    emit(state.copyWith(
      status: PostStatus.loading,
      media: page == 1 ? <Media>[] : null,
      nextPage: page,
      query: query,
      hashRequest: hash,
    ));

    _debounce.run(callback: () async {
      DataResponse<PageResponse<Media>> response =
          await _repository.searchMedia(
              page: page ?? state.nextPage, query: query ?? state.query);
      if (response is DataFailed) {
        emit(state.copyWith(
            status: PostStatus.failure,
            error: PostError(
              title: "خطا در دریافت هنرمندان",
              error: response.error ?? "مشکلی پیش آمده است",
              code: response.code,
            )));
      } else {
        if (hash == state.hashRequest) {
          emit(state.copyWith(
              status: PostStatus.success,
              media: List.of(state.media)..addAll(response.data!.results!),
              lastPage: response.data!.totalPages!,
              nextPage: state.nextPage + 1));
        }
      }
    });
  }

  String generateRandomHash(int length) {
    const String charset =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+';

    Random random = Random();
    String password = '';

    for (int i = 0; i < length; i++) {
      int randomIndex = random.nextInt(charset.length);
      password += charset[randomIndex];
    }

    return password;
  }
}
