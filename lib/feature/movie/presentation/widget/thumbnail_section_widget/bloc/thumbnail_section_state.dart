part of 'thumbnail_section_cubit.dart';
class ThumbnailSectionState {
  final String? filename;
  final Uint8List? file;
  bool isHovering;
  bool isFocused;
  final String? error;

  ThumbnailSectionState(
      {required this.filename,
        required this.file,
        required this.error,
        this.isHovering = false,
        this.isFocused = false});

  ThumbnailSectionState copyWith(
      {String? filename,
        Uint8List? file,
        bool? isHovering,
        bool? isFocused,
        String? error}) {
    return ThumbnailSectionState(
        filename: filename ?? this.filename,
        file: file ?? this.file,
        isFocused: isFocused ?? this.isFocused,
        isHovering: isHovering ?? this.isHovering,
        error: error ?? this.error);
  }

  ThumbnailSectionState clearError() {
    return ThumbnailSectionState(
        filename: filename,
        file: file,
        isFocused: isFocused,
        isHovering: isHovering,
        error: null);
  }
}

