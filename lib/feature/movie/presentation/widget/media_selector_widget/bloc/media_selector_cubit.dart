import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cross_file/cross_file.dart';
import 'package:dashboard/feature/movie/data/remote/model/movie.dart';
import 'package:dashboard/feature/movie/data/repositories/movie_repository.dart';
import 'package:dashboard/utils/background_file_reader.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

part 'media_selector_state.dart';

class MediaSelectorCubit extends Cubit<MediaSelectorState> {
  final MovieRepository _repository;
  static const int chunkSize = 1024 * 1024 * 2;
  BackgroundFileReader? worker;

  MediaSelectorCubit({required MovieRepository repository})
      : _repository = repository,
        super(const MediaSelectorState.init());

  @override
  Future<void> close() {
    worker?.close();
    worker = null;
    return super.close();
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.media, withReadStream: true);
    final files = result?.files;
    if (files?.isNotEmpty ?? false) {
      final file = files![0];
      emit(MediaSelectorState.startUpload(
        file: file.xFile,
        totalChunks: (file.size / chunkSize).ceil(),
      ));
      _startUpload();
      _generateThumbnail(file.extension);
    }
  }

  void _generateThumbnail(String? extension) async {
    final videoType = [
      'avi',
      'flv',
      'mkv',
      'mp4',
      'mov',
      'mpeg',
      'wmv',
      'webm'
    ];
    final imageType = ['gif', 'jpeg', 'jpg', 'png', 'bmp'];
    if ((videoType.contains(extension)) && state.file?.path != null) {
      final plugin = FcNativeVideoThumbnail();
      final temp = await getTemporaryDirectory();
      try {
        final thumbnailGenerated = await plugin.getVideoThumbnail(
            srcFile: state.file!.path,
            destFile: "${temp.path}\\media_thumbnail.jpeg",
            width: 1024,
            height: 1024,
            format: 'jpeg',
            quality: 90);
        if (thumbnailGenerated) {
          emit(state.copyWith(
              thumbnailFilePath: "${temp.path}\\media_thumbnail.jpeg"));
        }
      } catch (err) {}
    } else if (imageType.contains(extension)) {
      emit(state.copyWith(thumbnailFilePath: state.file?.path));
    }
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
                emit(MediaSelectorState.completeUpload(
                    thumbnailFilePath: state.thumbnailFilePath,
                    file: state.file!,
                    fileId: res.data!.id!));
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
                emit(MediaSelectorState.init(
                    error: ErrorBloc(
                        message: error.error ??
                            "خطای غیر منتظره ای در بارگذاری فایل به وجود آمد.")));
              } else if (error.code == 400) {
                if (state.retry == 0) {
                  emit(MediaSelectorState.init(
                      error: ErrorBloc(
                          message: error.error ??
                              "خطای غیر منتظره ای در بارگذاری فایل به وجود آمد.")));
                } else {
                  emit(state.copyWith(retry: state.retry - 1));
                  _startUpload();
                }
              } else if (res.code != 403) {
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
                  emit(MediaSelectorState.init(
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
        emit(MediaSelectorState.init(
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
    emit(const MediaSelectorState.init());
  }

  void resumeUpload() {
    emit(state.copyWith(isPaused: false));
    _startUpload();
  }

  void initialMedia(MediaFile? mediaFile) {
    if (mediaFile != null) {
      if ((mediaFile.mimetype?.contains('video') ?? false) &&
          mediaFile.thumbnail != null) {
        emit(MediaSelectorState.initNetwork(
            thumbnailNetworkUrl: mediaFile.thumbnail!, fileId: mediaFile.id!));
      } else if ((mediaFile.mimetype?.contains('image') ?? false) &&
          mediaFile.file != null) {
        emit(MediaSelectorState.initNetwork(
            thumbnailNetworkUrl: mediaFile.file!, fileId: mediaFile.id!));
      }
    }
  }
}
