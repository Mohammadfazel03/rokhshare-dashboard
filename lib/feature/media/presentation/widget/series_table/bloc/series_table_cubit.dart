import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/media/data/remote/model/series.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:meta/meta.dart';

part 'series_table_state.dart';

class SeriesTableCubit extends Cubit<SeriesTableState> {
  final MediaRepository _repository;

  SeriesTableCubit({required MediaRepository repository})
      : _repository = repository,
        super(SeriesTableLoading());

  Future<void> getData() async {
    emit(SeriesTableLoading());
    DataResponse<PageResponse<Series>> response = await _repository.getSeries();
    if (response is DataFailed) {
      emit(SeriesTableError(
          error: response.error ?? "مشکلی پیش آمده است", code: response.code));
    } else {
      emit(SeriesTableSuccess(data: response.data!));
    }
  }
}
