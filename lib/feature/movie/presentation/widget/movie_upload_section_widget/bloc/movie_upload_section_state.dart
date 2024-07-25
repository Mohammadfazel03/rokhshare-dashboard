part of 'movie_upload_section_cubit.dart';

class ErrorBloc {
  final String message;
  final String? title;
  final int? code;

  ErrorBloc({required this.message, this.title, this.code});
}

class MovieUploadSectionState {
  final XFile? file;
  final Uint8List? thumbnailDataUrl;
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
  final int? duration;

  const MovieUploadSectionState(
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
      required this.duration,
      this.retry = 3});

  const MovieUploadSectionState.init(
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
      this.duration,
      this.retry = 3});

  MovieUploadSectionState.startUpload(
      {required XFile file, required int totalChunks})
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
            isCanceled: false,
            duration: null);

  MovieUploadSectionState.completeUpload(
      {required XFile file,
      required Uint8List? thumbnailDataUrl,
      required int fileId,
      required int? duration})
      : this(
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
            isCanceled: false,
            duration: duration);

  MovieUploadSectionState copyWith(
      {XFile? file,
        Uint8List? thumbnailDataUrl,
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
      int? retry,
      int? duration}) {
    return MovieUploadSectionState(
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
        retry: retry ?? this.retry,
        duration: duration ?? this.duration);
  }
}
