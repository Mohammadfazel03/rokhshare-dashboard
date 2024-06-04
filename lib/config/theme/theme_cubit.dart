
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(): super(ThemeMode.dark);

  void changeTheme(ThemeMode mode) => emit(mode);

}