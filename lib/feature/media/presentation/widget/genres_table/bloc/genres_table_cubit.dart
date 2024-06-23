import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/media/data/remote/model/genre.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:meta/meta.dart';

part 'genres_table_state.dart';

class GenresTableCubit extends Cubit<GenresTableState> {
  final MediaRepository _repository;

  GenresTableCubit({required MediaRepository repository})
      : _repository = repository,
        super(const GenresTableLoading());

  Future<void> getData({int page = 1}) async {
    emit(GenresTableLoading(numberPages: state.numberPages, pageIndex: page));
    DataResponse<PageResponse<Genre>> response =
        await _repository.getGenres(page: page);
    if (response is DataFailed) {
      emit(GenresTableError(
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: page,
          numberPages: state.numberPages));
    } else {
      emit(GenresTableSuccess(
          data: response.data!,
          numberPages: response.data!.totalPages!,
          pageIndex: page));
    }
  }
}
