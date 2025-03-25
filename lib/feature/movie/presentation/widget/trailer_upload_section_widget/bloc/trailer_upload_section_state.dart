
part of 'trailer_upload_section_cubit.dart';

class ErrorBloc {
  final String message;
  final String? title;
  final int? code;

  ErrorBloc({required this.message, this.title, this.code});
}


class TrailerUploadSectionState {
  final ChunkedStreamReader<int>? chunkedStreamReader;
  final String? thumbnailNetworkUrl;
  final String? thumbnailFilePath;
  final String? filename;
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
      {required this.chunkedStreamReader,
        required this.currentChunk,
        required this.totalChunks,
        required this.progress,
        required this.filename,
        required this.uploadId,
        required this.error,
        required this.fileId,
        required this.isPaused,
        required this.isUploaded,
        required this.isUploading,
        required this.isCanceled,
        required this.thumbnailNetworkUrl,
        required this.thumbnailFilePath,
        this.retry = 3});

  const TrailerUploadSectionState.init(
      {this.chunkedStreamReader,
        this.currentChunk,
        this.totalChunks,
        this.progress,
        this.filename,
        this.uploadId,
        this.isUploaded,
        this.isUploading,
        this.isPaused,
        this.fileId,
        this.error,
        this.isCanceled,
        this.thumbnailNetworkUrl,
        this.thumbnailFilePath,
        this.retry = 3});

  TrailerUploadSectionState.startUpload(
      {required ChunkedStreamReader<int> chunkedStreamReader, required int totalChunks, required String filename})
      : this(
      chunkedStreamReader: chunkedStreamReader,
      currentChunk: 0,
      totalChunks: totalChunks,
      progress: 0,
      filename:filename,
      uploadId: null,
      isPaused: false,
      isUploaded: false,
      isUploading: true,
      fileId: null,
      thumbnailNetworkUrl: null,
      thumbnailFilePath: null,
      error: null,
      isCanceled: false);

  TrailerUploadSectionState.initNetwork(
      {required String? thumbnailNetworkUrl,
        required int fileId})
      : this(
      filename: null,
      chunkedStreamReader: null,
      currentChunk: null,
      totalChunks: null,
      progress: 100,
      uploadId: null,
      isPaused: false,
      isUploaded: true,
      isUploading: false,
      fileId: fileId,
      error: null,
      thumbnailNetworkUrl: thumbnailNetworkUrl,
      thumbnailFilePath: null,
      isCanceled: false);

  TrailerUploadSectionState.completeUpload(
      {
        required String? filename,
        required String? thumbnailFilePath,
        required int fileId})
      : this(
      filename:filename,
      chunkedStreamReader: null,
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
      thumbnailNetworkUrl: null,
      thumbnailFilePath: thumbnailFilePath);

  TrailerUploadSectionState copyWith(
      {ChunkedStreamReader<int>? chunkedStreamReader,
        int? currentChunk,
        int? totalChunks,
        double? progress,
        String? uploadId,
        String? filename,
        bool? isUploading,
        bool? isUploaded,
        bool? isPaused,
        ErrorBloc? error,
        int? fileId,
        bool? isCanceled,
        String? thumbnailFilePath,
        String? thumbnailNetworkUrl,
        int? retry,
        int? duration}) {
    return TrailerUploadSectionState(
        chunkedStreamReader: chunkedStreamReader ?? this.chunkedStreamReader,
        currentChunk: currentChunk ?? this.currentChunk,
        totalChunks: totalChunks ?? this.totalChunks,
        progress: progress ?? this.progress,
        uploadId: uploadId ?? this.uploadId,
        filename: filename ?? this.filename,
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
