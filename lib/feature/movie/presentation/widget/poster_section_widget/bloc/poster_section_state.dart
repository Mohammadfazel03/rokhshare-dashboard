part of 'poster_section_cubit.dart';

class PosterSectionState {
  final String? filename;
  final Uint8List? file;
  bool isHovering;
  bool isFocused;
  final String? error;

  PosterSectionState(
      {required this.filename,
      required this.file,
      required this.error,
      this.isHovering = false,
      this.isFocused = false});

  PosterSectionState copyWith(
      {String? filename,
      Uint8List? file,
      bool? isHovering,
      bool? isFocused,
      String? error}) {
    return PosterSectionState(
        filename: filename ?? this.filename,
        file: file ?? this.file,
        isFocused: isFocused ?? this.isFocused,
        isHovering: isHovering ?? this.isHovering,
        error: error ?? this.error);
  }

  PosterSectionState clearError() {
    return PosterSectionState(
        filename: filename,
        file: file,
        isFocused: isFocused,
        isHovering: isHovering,
        error: null);
  }
}
