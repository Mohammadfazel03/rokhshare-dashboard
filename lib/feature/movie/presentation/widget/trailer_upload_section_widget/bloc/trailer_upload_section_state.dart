/*
* 
* Web implement
* 
* 
* part of 'trailer_upload_section_cubit.dart';

class ErrorBloc {
  final String message;
  final String? title;
  final int? code;

  ErrorBloc({required this.message, this.title, this.code});

}

class TrailerUploadSectionState {
  final XFile? file;
  final String? thumbnailDataUrl;
  final int? currentChunk;
  final int? totalChunks;
  final double? progress;
  final String? uploadId;
  final bool? isUploading;
  final bool? isUploaded;
  final bool? isPaused;
  final bool? isCanceled;
  final ErrorBloc? error;
  final int? fileId;
  final int retry;

  const TrailerUploadSectionState(
      {required this.file,
      required this.thumbnailDataUrl,
      required this.currentChunk,
      required this.totalChunks,
      required this.progress,
      required this.uploadId,
      required this.error,
      required this.fileId,
      required this.isPaused,
      required this.isUploaded,
      required this.isUploading,
      required this.isCanceled,
        this.retry = 3
      });

  const TrailerUploadSectionState.init(
      {this.file,
      this.thumbnailDataUrl,
      this.currentChunk,
      this.totalChunks,
      this.progress,
      this.uploadId,
      this.isUploaded,
      this.isUploading,
      this.isPaused,
      this.fileId,
      this.error,
      this.isCanceled,
      this.retry = 3
      });

  TrailerUploadSectionState.startUpload(
      {required XFile file,
      required int totalChunks})
      : this(
            file: file,
            thumbnailDataUrl: null,
            currentChunk: 0,
            totalChunks: totalChunks,
            progress: 0,
            uploadId: null,
            isPaused: false,
            isUploaded: false,
            isUploading: true,
            fileId: null,
            error: null,
    isCanceled: false
  );

  TrailerUploadSectionState.completeUpload({
    required XFile file,
    required String? thumbnailDataUrl,
    required int fileId,
  }) : this(
            file: file,
            thumbnailDataUrl: thumbnailDataUrl,
            currentChunk: null,
            totalChunks: null,
            progress: 100,
            uploadId: null,
            isPaused: false,
            isUploaded: true,
            isUploading: false,
            fileId: fileId,
            error: null,
      isCanceled: false
  );

  TrailerUploadSectionState copyWith(
      {XFile? file,
      String? thumbnailDataUrl,
      int? currentChunk,
      int? totalChunks,
      double? progress,
      String? uploadId,
      bool? isUploading,
      bool? isUploaded,
      bool? isPaused,
      ErrorBloc? error,
      int? fileId,
      bool? isCanceled,
      int? retry}) {
    return TrailerUploadSectionState(
        file: file ?? this.file,
        thumbnailDataUrl: thumbnailDataUrl ?? this.thumbnailDataUrl,
        currentChunk: currentChunk ?? this.currentChunk,
        totalChunks: totalChunks ?? this.totalChunks,
        progress: progress ?? this.progress,
        uploadId: uploadId ?? this.uploadId,
        error: error ?? this.error,
        fileId: fileId ?? this.fileId,
        isPaused: isPaused ?? this.isPaused,
        isUploading: isUploading ?? this.isUploading,
        isUploaded: isUploaded ?? this.isUploaded,
      isCanceled: isCanceled ?? this.isCanceled,
      retry: retry ?? this.retry
    );
  }
}

* 
* */

part of 'trailer_upload_section_cubit.dart';

class ErrorBloc {
  final String message;
  final String? title;
  final int? code;

  ErrorBloc({required this.message, this.title, this.code});
}

class TrailerUploadSectionState {
  final XFile? file;
  final String? networkUrl;
  final int? currentChunk;
  final int? totalChunks;
  final double? progress;
  final String? uploadId;
  final bool? isUploading;
  final bool? isUploaded;
  final bool? isPaused;
  final bool? isCanceled;
  final ErrorBloc? error;
  final int? fileId;
  final int retry;
  final bool networkVideoIsReady;

  const TrailerUploadSectionState(
      {required this.file,
      required this.currentChunk,
      required this.totalChunks,
      required this.progress,
      required this.uploadId,
      required this.error,
      required this.fileId,
      required this.isPaused,
      required this.isUploaded,
      required this.isUploading,
      required this.isCanceled,
      required this.networkUrl,
      this.retry = 3,
      this.networkVideoIsReady = false});

  const TrailerUploadSectionState.init(
      {this.file,
      this.currentChunk,
      this.totalChunks,
      this.progress,
      this.uploadId,
      this.isUploaded,
      this.isUploading,
      this.isPaused,
      this.fileId,
      this.error,
      this.isCanceled,
      this.retry = 3,
      this.networkUrl,
      this.networkVideoIsReady = false});

  TrailerUploadSectionState.startUpload(
      {required XFile file, required int totalChunks})
      : this(
            file: file,
            currentChunk: 0,
            totalChunks: totalChunks,
            progress: 0,
            uploadId: null,
            isPaused: false,
            isUploaded: false,
            isUploading: true,
            fileId: null,
            error: null,
            networkUrl: null,
            isCanceled: false);

  TrailerUploadSectionState.completeUpload({
    required XFile file,
    required bool networkVideoIsReady,
    required int fileId,
  }) : this(
            file: file,
            currentChunk: null,
            totalChunks: null,
            progress: 100,
            uploadId: null,
            isPaused: false,
            isUploaded: true,
            isUploading: false,
            fileId: fileId,
            error: null,
            networkUrl: null,
            isCanceled: false,
            networkVideoIsReady: networkVideoIsReady);

  TrailerUploadSectionState.initNetwork({
    required String networkUrl,
    required int fileId,
  }) : this(
            file: null,
            currentChunk: null,
            totalChunks: null,
            progress: 100,
            uploadId: null,
            isPaused: false,
            isUploaded: true,
            isUploading: false,
            fileId: fileId,
            error: null,
            networkUrl: networkUrl,
            isCanceled: false);

  TrailerUploadSectionState copyWith(
      {XFile? file,
      String? networkUrl,
      int? currentChunk,
      int? totalChunks,
      double? progress,
      String? uploadId,
      bool? isUploading,
      bool? isUploaded,
      bool? isPaused,
      ErrorBloc? error,
      int? fileId,
      bool? isCanceled,
      bool? networkVideoIsReady,
      int? retry}) {
    return TrailerUploadSectionState(
        file: file ?? this.file,
        currentChunk: currentChunk ?? this.currentChunk,
        totalChunks: totalChunks ?? this.totalChunks,
        progress: progress ?? this.progress,
        uploadId: uploadId ?? this.uploadId,
        error: error ?? this.error,
        fileId: fileId ?? this.fileId,
        isPaused: isPaused ?? this.isPaused,
        isUploading: isUploading ?? this.isUploading,
        isUploaded: isUploaded ?? this.isUploaded,
        isCanceled: isCanceled ?? this.isCanceled,
        retry: retry ?? this.retry,
        networkUrl: networkUrl ?? this.networkUrl,
        networkVideoIsReady: networkVideoIsReady ?? this.networkVideoIsReady);
  }
}
