import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData(
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: Color.fromRGBO(55, 97, 235, 1)),
    colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Color.fromRGBO(55, 97, 235, 1),
        onPrimary: Colors.white,
        secondary: Color.fromRGBO(39, 46, 63, 1),
        onSecondary: Colors.white,
        error: Color.fromRGBO(215, 13, 13, 1),
        onError: Colors.white,
        background: Color.fromRGBO(250, 250, 250, 1),
        onBackground: Colors.black,
        surface: Colors.white,
        onSurface: Color.fromRGBO(112, 116, 121, 1),
        primaryContainer: Color.fromRGBO(255, 255, 255, 1.0),
        ),
    primaryColorLight: Color.fromRGBO(233,237,250, 1),
    shadowColor: Color.fromRGBO(222, 222, 222, 1),
    scaffoldBackgroundColor: Color.fromRGBO(250, 250, 250, 1),
    drawerTheme: DrawerThemeData(
        backgroundColor: Color.fromRGBO(15, 23, 42, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
    listTileTheme: ListTileThemeData(
        tileColor: Color.fromRGBO(15, 23, 42, 1),
        selectedTileColor: Color.fromRGBO(55, 97, 235, 1),
        minLeadingWidth: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
    textTheme: TextTheme(
      headlineSmall: TextStyle(
          color: Color.fromRGBO(0, 0, 0, 1.0),
          fontFamily: 'iran-sans',
          fontSize: 18,
          fontWeight: FontWeight.bold),
      titleLarge: TextStyle(
        color: Color.fromRGBO(255, 255, 255, 1.0),
        fontFamily: 'iran-sans',
        fontSize: 16,
      ),
      titleSmall: TextStyle(
        color: Color.fromRGBO(15, 23, 42, 1.0),
        fontFamily: 'iran-sans',
        fontSize: 18,
        fontWeight: FontWeight.bold
      ),
      bodyLarge: TextStyle(
          color: Color.fromRGBO(175, 179, 188, 1.0),
          fontFamily: 'iran-sans',
          fontSize: 15),
      bodyMedium: TextStyle(
          color: Color.fromRGBO(112, 116, 121, 1.0),
          fontFamily: 'iran-sans',
          fontSize: 12),
    ),
  );

  static final dark = ThemeData(
      brightness: Brightness.dark,
      iconTheme: IconThemeData(color: Color.fromRGBO(255, 255, 255, 1.0)),
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Color.fromRGBO(35, 59, 141, 1.0),
          onPrimary: Colors.white,
          secondary: Color.fromRGBO(10, 19, 39, 1),
          onSecondary: Colors.white,
          error: Color.fromRGBO(215, 13, 13, 1),
          onError: Colors.white,
          background: Color.fromRGBO(13, 28, 60, 1),
          onBackground: Colors.white,
          surface: Color.fromRGBO(17, 35, 79, 1),
          onSurface: Color.fromRGBO(238, 238, 238, 1),
          primaryContainer: Color.fromRGBO(30, 47, 87, 1),
      ),
      primaryColorLight: Color.fromRGBO(49, 73, 147, 1),
      shadowColor: Color.fromRGBO(15, 30, 69, 1),
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
        headlineSmall: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1.0),
            fontFamily: 'iran-sans',
            fontSize: 18,
            fontWeight: FontWeight.bold),
        titleLarge: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1.0),
            fontFamily: 'iran-sans',
            fontSize: 16,
            fontWeight: FontWeight.normal),
        titleSmall: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1.0),
            fontFamily: 'iran-sans',
            fontSize: 18,
            fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(
            color: Color.fromRGBO(174, 178, 187, 1.0),
            fontFamily: 'iran-sans',
            fontSize: 15),
          bodyMedium: TextStyle(
              color: Color.fromRGBO(238, 238, 238, 1.0),
              fontFamily: 'iran-sans',
              fontSize: 12)
      ));
}
