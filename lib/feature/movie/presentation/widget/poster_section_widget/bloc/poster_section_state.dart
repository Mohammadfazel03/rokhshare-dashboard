part of 'poster_section_cubit.dart';

class PosterSectionState {
  final String? filename;
  final Uint8List? file;
  bool isHovering;
  bool isFocused;
  final String? error;
  final String? networkUrl;

  PosterSectionState(
      {required this.filename,
      required this.file,
      required this.error,
      required this.networkUrl,
      this.isHovering = false,
      this.isFocused = false});

  PosterSectionState copyWith(
      {String? filename,
      Uint8List? file,
      bool? isHovering,
      String? networkUrl,
      bool? isFocused,
      String? error}) {
    return PosterSectionState(
        filename: filename ?? this.filename,
        file: file ?? this.file,
        isFocused: isFocused ?? this.isFocused,
        isHovering: isHovering ?? this.isHovering,
        error: error ?? this.error,
        networkUrl: networkUrl ?? this.networkUrl);
  }

  PosterSectionState clearError() {
    return PosterSectionState(
        filename: filename,
        file: file,
        isFocused: isFocused,
        isHovering: isHovering,
        error: null,
        networkUrl: networkUrl);
  }
}
