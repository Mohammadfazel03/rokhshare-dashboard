import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'thumbnail_section_state.dart';

class ThumbnailSectionCubit extends Cubit<ThumbnailSectionState> {
  ThumbnailSectionCubit()
      : super(ThumbnailSectionState(
            file: null, filename: null, error: null, networkUrl: null));

  void selectFile({required String? filename, required Uint8List? file}) {
    emit(ThumbnailSectionState(
        filename: filename, file: file, error: null, networkUrl: null));
  }

  void removeFile() {
    emit(ThumbnailSectionState(
        file: null, filename: null, error: null, networkUrl: null));
  }

  void hover(bool hover) {
    emit(state.copyWith(isHovering: hover));
  }

  void focus(bool focus) {
    emit(state.copyWith(isFocused: focus));
  }

  void setError(String error) {
    emit(state.copyWith(error: error));
  }

  void clearError() {
    if (state.error != null) {
      emit(state.clearError());
    }
  }

  void initialFile(String? networkUrl) {
    if (networkUrl != null) {
      var name = networkUrl.split('/').last;
      emit(state.copyWith(networkUrl: networkUrl, filename: name));
    }
  }
}
