import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/movie/data/remote/model/movie.dart';
import 'package:dashboard/feature/movie/data/repositories/movie_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

part 'trailer_upload_section_state.dart';


class TrailerUploadSectionCubit extends Cubit<TrailerUploadSectionState> {
  final MovieRepository _repository;
  static const int chunkSize = 1024 * 512;

  TrailerUploadSectionCubit({required MovieRepository repository})
      : _repository = repository,
        super(const TrailerUploadSectionState.init());


  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.video, withReadStream: true);
    final files = result?.files;
    if (files?.isNotEmpty ?? false) {
      final file = files![0];
      emit(TrailerUploadSectionState.startUpload(
          filename: file.name,
          chunkedStreamReader: ChunkedStreamReader(file.readStream!),
          totalChunks: (file.size / chunkSize).ceil()
      ));
      _startUpload();
    }
  }

  void _startUpload() async {
    if (state.isCanceled != true) {
      _chunkFile().then((chunk) {
        if (state.isCanceled != true) {
          _repository
              .uploadFile(
              fileBytes: chunk,
              filename: "141467x264new1-720p.mp4",
              chunkIndex: state.currentChunk!,
              totalChunk: state.totalChunks!,
              uploadId: state.uploadId)
              .then((res) {
            if (res is DataSuccess) {
              if (res.data?.id != null && state.isCanceled != true) {
                emit(TrailerUploadSectionState.completeUpload(
                    filename: state.filename,
                    thumbnailFilePath: state.thumbnailFilePath,
                    fileId: res.data!.id!));
              } else if (state.isCanceled != true) {
                emit(state.copyWith(
                    uploadId: res.data!.uploadId,
                    currentChunk: res.data?.chunkIndex ?? 0,
                    progress: (res.data?.chunkIndex ?? 0) /
                        (state.totalChunks ?? 1)));
                if (state.isPaused != true) {
                  _startUpload();
                }
              }
            } else {
              var error = res as DataFailed;
              if (error.code == 410 || error.code == 404) {
                emit(TrailerUploadSectionState.init(
                    error: ErrorBloc(
                        message: error.error ??
                            "خطای غیر منتظره ای در بارگذاری فایل به وجود آمد.")));
              } else if (error.code == 400) {
                if (state.retry == 0) {
                  emit(TrailerUploadSectionState.init(
                      error: ErrorBloc(
                          message: error.error ??
                              "خطای غیر منتظره ای در بارگذاری فایل به وجود آمد.")));
                } else {
                  emit(state.copyWith(retry: state.retry - 1));
                  _startUpload();
                }
              } else if (error.code != 403) {
                if (state.retry == 0) {
                  if (state.isUploading == true &&
                      (state.isPaused ?? false) == false &&
                      state.isUploaded == false) {
                    emit(state.copyWith(
                        isPaused: true,
                        error: ErrorBloc(
                            message:
                            "خطا در اتصال به سرور. بعد از اطمینان از اینترنت خود بارگذاری را از سر بگیرید.")));
                  }
                  emit(TrailerUploadSectionState.init(
                      error: ErrorBloc(
                          message: error.error ??
                              "خطای غیر منتظره ای در بارگذاری فایل به وجود آمد.")));
                } else {
                  emit(state.copyWith(retry: state.retry - 1));
                  _startUpload();
                }
              } else {
                emit(state.copyWith(
                    error:
                    ErrorBloc(message: res.error ?? "", code: res.code)));
              }
            }
          });
        }
      }, onError: (e) {
        emit(TrailerUploadSectionState.init(
            error: ErrorBloc(
                message: "خطای غیر منتظره ای در بارگذاری فایل به وجود آمد.",
                code: 1)));
      });
    }
  }


  Future<Uint8List> _chunkFile() async {
    return Uint8List.fromList(await state.chunkedStreamReader!.readChunk(chunkSize));
  }

  void pauseUpload() {
    if (state.isUploading == true &&
        (state.isPaused ?? false) == false &&
        state.isUploaded == false) {
      emit(state.copyWith(isPaused: true));
    }
  }

  void cancelUpload() {
    emit(const TrailerUploadSectionState.init());
  }

  void resumeUpload() {
    emit(state.copyWith(isPaused: false));
    _startUpload();
  }

  void initialTrailer(MediaFile? mediaFile) {
    if (mediaFile != null) {
      emit(TrailerUploadSectionState.initNetwork(
          fileId: mediaFile.id!,
          thumbnailNetworkUrl: mediaFile.thumbnail));
    }
  }
}
