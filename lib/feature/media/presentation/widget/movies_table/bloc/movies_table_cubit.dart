import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/media/data/remote/model/movie.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:meta/meta.dart';

part 'movies_table_state.dart';

class MoviesTableCubit extends Cubit<MoviesTableState> {
  final MediaRepository _repository;

  MoviesTableCubit({required MediaRepository repository})
      : _repository = repository,
        super(MoviesTableLoading());

  Future<void> getData() async {
    emit(MoviesTableLoading());
    DataResponse<PageResponse<Movie>> response = await _repository.getMovies();
    if (response is DataFailed) {
      emit(MoviesTableError(
          error: response.error ?? "مشکلی پیش آمده است", code: response.code));
    } else {
      emit(MoviesTableSuccess(data: response.data!));
    }
  }
}
