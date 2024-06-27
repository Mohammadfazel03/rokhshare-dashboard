import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/media/data/remote/model/artist.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:meta/meta.dart';

part 'artists_table_state.dart';

class ArtistsTableCubit extends Cubit<ArtistsTableState> {
  final MediaRepository _repository;

  ArtistsTableCubit({required MediaRepository repository})
      : _repository = repository,
        super(const ArtistsTableLoading());

  Future<void> getData({int page = 1}) async {
    emit(ArtistsTableLoading(numberPages: state.numberPages, pageIndex: page));
    DataResponse<PageResponse<Artist>> response =
        await _repository.getArtists(page: page);
    if (response is DataFailed) {
      emit(ArtistsTableError(
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: page,
          numberPages: state.numberPages));
    } else {
      emit(ArtistsTableSuccess(
          data: response.data!,
          numberPages: response.data!.totalPages!,
          pageIndex: page));
    }
  }
}