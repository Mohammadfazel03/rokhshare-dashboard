import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/movie/data/remote/model/movie.dart';
import 'package:dashboard/feature/movie/data/repositories/movie_repository.dart';
import 'package:dashboard/utils/background_file_reader.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:cross_file/cross_file.dart';
import 'package:video_player_win/video_player_win.dart';

part 'movie_upload_section_state.dart';

class MovieUploadSectionCubit extends Cubit<MovieUploadSectionState> {
  final MovieRepository _repository;
  static const int chunkSize = 1024 * 1024 * 2;
  BackgroundFileReader? worker;

  MovieUploadSectionCubit({required MovieRepository repository})
      : _repository = repository,
        super(const MovieUploadSectionState.init());

  @override
  Future<void> close() {
    worker?.close();
    worker = null;
    return super.close();
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.video, withReadStream: true);
    final files = result?.files;
    if (files?.isNotEmpty ?? false) {
      final file = files![0];
      emit(MovieUploadSectionState.startUpload(
        file: file.xFile,
        totalChunks: (file.size / chunkSize).ceil(),
      ));
      _getDuration(File(file.path!));
      _startUpload();
    }
  }

  void _getThumbnail(File file) async {
    // TODO: create thumbnail of video
  }

  void _getDuration(File file) async {
    WinVideoPlayerController controller = WinVideoPlayerController.file(file);
    await controller.initialize();
    emit(state.copyWith(duration: controller.value.duration.inMinutes));
    controller.dispose();
  }

  void _startUpload() async {
    if (state.isCanceled != true) {
      _chunkFile().then((chunk) {
        if (state.isCanceled != true) {
          _repository
              .uploadFile(
                  fileBytes: chunk,
                  filename: state.file?.name ?? "",
                  chunkIndex: state.currentChunk!,
                  totalChunk: state.totalChunks!,
                  uploadId: state.uploadId)
              .then((res) {
            if (res is DataSuccess) {
              if (res.data?.id != null && state.isCanceled != true) {
                emit(MovieUploadSectionState.completeUpload(
                    file: state.file!,
                    thumbnailDataUrl: state.thumbnailDataUrl,
                    fileId: res.data!.id!,
                    duration: state.duration));
                worker?.close();
                worker = null;
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
                emit(MovieUploadSectionState.init(
                    error: ErrorBloc(
                        message: error.error ??
                            "خطای غیر منتظره ای در بارگذاری فایل به وجود آمد.")));
              } else if (error.code == 400) {
                if (state.retry == 0) {
                  emit(MovieUploadSectionState.init(
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
                  emit(MovieUploadSectionState.init(
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
        worker?.close();
        worker = null;
        emit(MovieUploadSectionState.init(
            error: ErrorBloc(
                message: "خطای غیر منتظره ای در بارگذاری فایل به وجود آمد.",
                code: 1)));
      });
    }
  }

  Future<Uint8List> _chunkFile() async {
    worker ??= await BackgroundFileReader.spawn();
    if (state.file != null && state.currentChunk != null) {
      return worker!.readChunkFile(state.file!, chunkSize, state.currentChunk!);
    }
    throw Exception();
  }

  void pauseUpload() {
    if (state.isUploading == true &&
        (state.isPaused ?? false) == false &&
        state.isUploaded == false) {
      emit(state.copyWith(isPaused: true));
    }
  }

  void cancelUpload() {
    worker?.close();
    worker = null;
    emit(const MovieUploadSectionState.init());
  }

  void resumeUpload() {
    emit(state.copyWith(isPaused: false));
    _startUpload();
  }

  void initialMovie(MediaFile? mediaFile, int? time) {
    if (mediaFile != null && time != null) {
      emit(MovieUploadSectionState.completeUpload(
          file: null,
          thumbnailDataUrl: null,
          fileId: mediaFile.id!,
          duration: time));
    }
  }
}
