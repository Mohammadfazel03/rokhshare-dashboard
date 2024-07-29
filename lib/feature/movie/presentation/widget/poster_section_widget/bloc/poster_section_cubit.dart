import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'poster_section_state.dart';

class PosterSectionCubit extends Cubit<PosterSectionState> {
  PosterSectionCubit()
      : super(PosterSectionState(
            file: null, filename: null, error: null, networkUrl: null));

  void selectFile({required String? filename, required Uint8List? file}) {
    emit(PosterSectionState(
        filename: filename, file: file, error: null, networkUrl: null));
  }

  void initialFile(String? networkUrl) {
    if (networkUrl != null) {
      var name = networkUrl.split('/').last;
      emit(state.copyWith(networkUrl: networkUrl, filename: name));
    }
  }

  void removeFile() {
    emit(PosterSectionState(
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
}
