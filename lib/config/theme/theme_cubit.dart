
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(): super(ThemeMode.system);

  void changeTheme(ThemeMode mode) => emit(mode);

}