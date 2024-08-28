part of 'media_selector_cubit.dart';

class ErrorBloc {
  final String message;
  final String? title;
  final int? code;

  ErrorBloc({required this.message, this.title, this.code});
}

class MediaSelectorState {
  final XFile? file;
  final String? thumbnailNetworkUrl;
  final String? thumbnailFilePath;
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

  const MediaSelectorState({
    required this.file,
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
    required this.thumbnailNetworkUrl,
    required this.thumbnailFilePath,
    this.retry = 3,
  });

  const MediaSelectorState.init(
      {this.file,
      this.currentChunk,
      this.thumbnailFilePath,
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
      this.thumbnailNetworkUrl});

  MediaSelectorState.startUpload(
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
            thumbnailNetworkUrl: null,
            thumbnailFilePath: null,
            isCanceled: false);

  MediaSelectorState.completeUpload({
    required XFile file,
    required int fileId,
    required String? thumbnailFilePath,
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
            thumbnailNetworkUrl: null,
            thumbnailFilePath: thumbnailFilePath,
            isCanceled: false);

  MediaSelectorState.initNetwork({
    required String thumbnailNetworkUrl,
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
            thumbnailFilePath: null,
            thumbnailNetworkUrl: thumbnailNetworkUrl,
            isCanceled: false);

  MediaSelectorState copyWith(
      {XFile? file,
      String? thumbnailNetworkUrl,
      String? thumbnailFilePath,
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
    return MediaSelectorState(
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
        thumbnailFilePath: thumbnailFilePath ?? this.thumbnailFilePath,
        thumbnailNetworkUrl: thumbnailNetworkUrl ?? this.thumbnailNetworkUrl);
  }
}
