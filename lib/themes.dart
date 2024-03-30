import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color.fromRGBO(250, 250, 250, 1),
    drawerTheme: DrawerThemeData(
        backgroundColor: Color.fromRGBO(15, 23, 42, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
    listTileTheme: ListTileThemeData(
      tileColor: Color.fromRGBO(15, 23, 42, 1),
      selectedTileColor: Color.fromRGBO(55, 97, 235, 1),
      minLeadingWidth: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
          color: Color.fromRGBO(174, 178, 187, 1.0),
          fontFamily: 'iran-sans',
          fontSize: 15),
      titleLarge: TextStyle(
          color: Color.fromRGBO(255, 255, 255, 1.0),
          fontFamily: 'iran-sans',
          fontSize: 16,
          fontWeight: FontWeight.bold),
    ),
  );

  static final dark = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Color.fromRGBO(13, 28, 60, 1),
      drawerTheme: DrawerThemeData(
          backgroundColor: Color.fromRGBO(15, 23, 42, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      listTileTheme: ListTileThemeData(
        selectedTileColor: Color.fromRGBO(55, 97, 235, 1),
        contentPadding: EdgeInsets.zero,
        tileColor: Color.fromRGBO(15, 23, 42, 1),
        minLeadingWidth: 10,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
            color: Color.fromRGBO(174, 178, 187, 1.0),
            fontFamily: 'iran-sans',
            fontSize: 15),
        titleLarge: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1.0),
            fontFamily: 'iran-sans',
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ));
}
