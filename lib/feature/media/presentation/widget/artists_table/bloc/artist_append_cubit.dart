import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/media/data/remote/model/artist.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:meta/meta.dart';

part 'artist_append_state.dart';

class ArtistAppendCubit extends Cubit<ArtistAppendState> {
  final MediaRepository _repository;

  ArtistAppendCubit({required MediaRepository repository})
      : _repository = repository,
        super(ArtistAppendInitial());

  Future<void> saveArtist({name, image, bio}) async {
    emit(ArtistAppendLoading());
    DataResponse<Artist> response =
    await _repository.postArtist(name: name, image: image, bio: bio);
    if (response is DataFailed) {
      emit(ArtistAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(ArtistAppendSuccessAppend());
    }
  }

  Future<void> getArtist({required int id}) async {
    emit(ArtistAppendLoading());
    DataResponse<Artist> response = await _repository.getArtist(id: id);
    if (response is DataFailed) {
      emit(ArtistAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(ArtistAppendSuccess(
          artist: response.data!
      ));
    }
  }

  Future<void> updateArtist({required int id, image, name, bio}) async {
    emit(ArtistAppendLoading());
    DataResponse<Artist> response =
    await _repository.updateArtist(id: id, name: name, image: image, bio: bio);
    if (response is DataFailed) {
      emit(ArtistAppendFailed(
          message: response.error ?? "مشکلی پیش آمده است",
          code: response.code));
    } else {
      emit(ArtistAppendSuccessUpdate());
    }
  }
}
