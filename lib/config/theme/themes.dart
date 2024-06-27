import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
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
      secondaryContainer: Color.fromRGBO(220, 220, 220, 1.0),
    ),
    iconTheme: const IconThemeData(color: Color.fromRGBO(55, 97, 235, 1)),

      tooltipTheme: TooltipThemeData(
          textStyle: TextStyle(
              color: Color.fromRGBO(245, 245, 245, 1.0),
              fontFamily: 'iran-sans',
              fontSize: 12)),
    inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        hintStyle: TextStyle(color: Color.fromRGBO(141, 139, 139, 1), fontSize: 12),
        fillColor: Color.fromRGBO(243, 243, 245, 1),
        labelStyle: TextStyle(color: Color.fromRGBO(141, 139, 139, 1), fontSize: 12),
        floatingLabelStyle: TextStyle(color: Color.fromRGBO(55, 97, 235, 1), fontSize: 12),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(205, 205, 205, 1))),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 2, color: Color.fromRGBO(55, 97, 235, 1)))),
    chipTheme: ChipThemeData(
      backgroundColor: const Color.fromRGBO(55, 97, 235, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      side: BorderSide.none,
      elevation: 8,
    ),
    dividerColor: Color.fromRGBO(220, 220, 220, 1),
    primaryColorLight: const Color.fromRGBO(233, 237, 250, 1),
    shadowColor: const Color.fromRGBO(222, 222, 222, 1),
    scaffoldBackgroundColor: const Color.fromRGBO(250, 250, 250, 1),
    drawerTheme: DrawerThemeData(
        backgroundColor: const Color.fromRGBO(15, 23, 42, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    listTileTheme: ListTileThemeData(
        tileColor: const Color.fromRGBO(15, 23, 42, 1),
        selectedTileColor: const Color.fromRGBO(55, 97, 235, 1),
        minLeadingWidth: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
          color: Color.fromRGBO(0, 0, 0, 1.0),
          fontFamily: 'iran-sans',
          fontSize: 24,
          fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          color: Color.fromRGBO(0, 0, 0, 1.0),
          fontFamily: 'iran-sans',
          fontSize: 18,
          fontWeight: FontWeight.bold),
      titleLarge: TextStyle(
          color: Color.fromRGBO(15, 23, 42, 1.0),
          fontFamily: 'iran-sans',
          fontSize: 18,
          fontWeight: FontWeight.bold),
      titleMedium: TextStyle(
          color: Colors.white,
          fontFamily: 'iran-sans',
          fontSize: 16,
          fontWeight: FontWeight.normal),
      titleSmall: TextStyle(
          color: Color.fromRGBO(255, 255, 255, 1.0),
          fontFamily: 'iran-sans',
          fontSize: 14,
          fontWeight: FontWeight.bold),
      labelLarge: TextStyle(
          color: Color.fromRGBO(175, 179, 188, 1.0),
          fontFamily: 'iran-sans',
          fontSize: 15),
      labelMedium: TextStyle(
          color: Color.fromRGBO(112, 116, 121, 1.0),
          fontFamily: 'iran-sans',
          fontSize: 14),
      labelSmall: TextStyle(
          color: Color.fromRGBO(112, 116, 121, 1.0),
          fontFamily: 'iran-sans',
          fontSize: 12),
      bodyLarge: TextStyle(
          color: Color.fromRGBO(75, 75, 75, 1),
          fontFamily: 'iran-sans',
          fontSize: 12),
      bodyMedium: TextStyle(
          color: Color.fromRGBO(75, 75, 75, 1),
          fontFamily: 'iran-sans',
          fontSize: 10),
    ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
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
      secondaryContainer: Color.fromRGBO(20, 30, 50, 1.0),
    ),
    iconTheme: const IconThemeData(color: Color.fromRGBO(255, 255, 255, 1.0)),
    tooltipTheme: TooltipThemeData(
        textStyle: TextStyle(
            color: Color.fromRGBO(50, 50, 50, 1.0),
            fontFamily: 'iran-sans',
            fontSize: 12)),
    dividerColor: Color.fromRGBO(80, 93, 123, 1),
    primaryColorLight: const Color.fromRGBO(49, 73, 147, 1),
    shadowColor: const Color.fromRGBO(15, 30, 69, 1),
    scaffoldBackgroundColor: const Color.fromRGBO(13, 28, 60, 1),
    drawerTheme: DrawerThemeData(
        backgroundColor: const Color.fromRGBO(15, 23, 42, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    listTileTheme: const ListTileThemeData(
      selectedTileColor: Color.fromRGBO(55, 97, 235, 1),
      contentPadding: EdgeInsets.zero,
      tileColor: Color.fromRGBO(15, 23, 42, 1),
      minLeadingWidth: 10,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Color.fromRGBO(35, 59, 141, 1.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      side: BorderSide.none,
      elevation: 8,
    ),
    inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        hintStyle: TextStyle(color: Color.fromRGBO(190, 196, 220, 1), fontSize: 12),
        labelStyle: TextStyle(color: Color.fromRGBO(190, 196, 220, 1), fontSize: 12),
        floatingLabelStyle: TextStyle(color: Color.fromRGBO(57, 113 ,255, 1), fontSize: 12),
        fillColor: Color.fromRGBO(22, 44, 99, 1),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(30, 60, 135, 1.0))),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 2, color: Color.fromRGBO(57, 113 ,255, 1)))),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
          color: Color.fromRGBO(255, 255, 255, 1.0),
          fontFamily: 'iran-sans',
          fontSize: 24,
          fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          color: Color.fromRGBO(255, 255, 255, 1.0),
          fontFamily: 'iran-sans',
          fontSize: 18,
          fontWeight: FontWeight.bold),
      titleLarge: TextStyle(
          color: Color.fromRGBO(255, 255, 255, 1.0),
          fontFamily: 'iran-sans',
          fontSize: 18,
          fontWeight: FontWeight.bold),
      titleMedium: TextStyle(
          color: Color.fromRGBO(255, 255, 255, 1.0),
          fontFamily: 'iran-sans',
          fontSize: 16,
          fontWeight: FontWeight.normal),
      titleSmall: TextStyle(
          color: Color.fromRGBO(255, 255, 255, 1.0),
          fontFamily: 'iran-sans',
          fontSize: 14,
          fontWeight: FontWeight.bold),
      labelLarge: TextStyle(
          color: Color.fromRGBO(174, 178, 187, 1.0),
          fontFamily: 'iran-sans',
          fontSize: 15),
      labelMedium: TextStyle(
          color: Color.fromRGBO(238, 238, 238, 1.0),
          fontFamily: 'iran-sans',
          fontSize: 14),
      labelSmall: TextStyle(
          color: Color.fromRGBO(238, 238, 238, 1.0),
          fontFamily: 'iran-sans',
          fontSize: 12),
      bodyLarge: TextStyle(
          color: Color.fromRGBO(218, 226, 255, 1),
          fontFamily: 'iran-sans',
          fontSize: 12),
      bodyMedium: TextStyle(
          color: Color.fromRGBO(218, 226, 255, 1),
          fontFamily: 'iran-sans',
          fontSize: 10),
    ),
  );
}
