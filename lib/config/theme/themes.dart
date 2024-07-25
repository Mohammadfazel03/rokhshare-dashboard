import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xff003abc),
        surfaceTint: Color(0xff2150db),
        onPrimary: Color(0xffffffff),
        primaryContainer: Color(0xff3761eb),
        onPrimaryContainer: Color(0xffffffff),
        secondary: Color(0xff333241),
        onSecondary: Color(0xffffffff),
        secondaryContainer: Color(0xff555465),
        onSecondaryContainer: Color(0xfffdf9ff),
        tertiary: Color(0xff005b4f),
        onTertiary: Color(0xffffffff),
        tertiaryContainer: Color(0xff008373),
        onTertiaryContainer: Color(0xffffffff),
        error: Color(0xffba1a1a),
        onError: Color(0xffffffff),
        errorContainer: Color(0xffffdad6),
        onErrorContainer: Color(0xff410002),
        surface: Color(0xfffcf8fd),
        onSurface: Color(0xff1c1b1e),
        onSurfaceVariant: Color(0xff46464b),
        outline: Color(0xff77767c),
        outlineVariant: Color(0xffc8c5cb),
        shadow: Color(0xff000000),
        scrim: Color(0xff000000),
        inverseSurface: Color(0xff313033),
        inversePrimary: Color(0xffb7c4ff),
        primaryFixed: Color(0xffdde1ff),
        onPrimaryFixed: Color(0xff001552),
        primaryFixedDim: Color(0xffb7c4ff),
        onPrimaryFixedVariant: Color(0xff0038b6),
        secondaryFixed: Color(0xffe3e0f4),
        onSecondaryFixed: Color(0xff1b1a28),
        secondaryFixedDim: Color(0xffc7c4d8),
        onSecondaryFixedVariant: Color(0xff464555),
        tertiaryFixed: Color(0xff8ff5e0),
        onTertiaryFixed: Color(0xff00201b),
        tertiaryFixedDim: Color(0xff72d8c4),
        onTertiaryFixedVariant: Color(0xff005046),
        surfaceDim: Color(0xffdcd9dd),
        surfaceBright: Color(0xfffcf8fd),
        surfaceContainerLowest: Color(0xffffffff),
        surfaceContainerLow: Color(0xfff6f2f7),
        surfaceContainer: Color(0xfff0edf1),
        surfaceContainerHigh: Color(0xffebe7eb),
        surfaceContainerHighest: Color(0xffe5e1e6),
      ),
      drawerTheme: DrawerThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        hintStyle: TextStyle(
            color: Color(0xff46464b),
            fontFamily: "iran-sans",
            fontWeight: FontWeight.w400,
            fontSize: 12,
            letterSpacing: 0.38),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Color(0xff77767c))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color(0xff003abc))),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Color(0x1f1c1b1e))),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Color(0xffba1a1a))),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color(0xffba1a1a))),
      ),
      textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w400,
              fontSize: 43,
              letterSpacing: -0.19),
          displayMedium: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w400,
              fontSize: 35,
              letterSpacing: 0),
          displaySmall: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w400,
              fontSize: 28,
              letterSpacing: 0),
          headlineLarge: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w400,
              fontSize: 25,
              letterSpacing: 0),
          headlineMedium: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w400,
              fontSize: 22,
              letterSpacing: 0),
          headlineSmall: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w400,
              fontSize: 18,
              letterSpacing: 0),
          titleLarge: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: 0),
          titleMedium: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w500,
              fontSize: 16,
              letterSpacing: 0.11),
          titleSmall: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.08),
          bodyLarge: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w400,
              fontSize: 14,
              letterSpacing: 0.38),
          bodyMedium: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w400,
              fontSize: 12,
              letterSpacing: 0.38),
          bodySmall: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w400,
              fontSize: 11,
              letterSpacing: 0.3),
          labelLarge: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.08),
          labelMedium: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w500,
              fontSize: 12,
              letterSpacing: 0.38),
          labelSmall: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w500,
              fontSize: 11,
              letterSpacing: 0.38)));

  static final dark = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xffb7c4ff),
        surfaceTint: Color(0xffb7c4ff),
        onPrimary: Color(0xff002682),
        primaryContainer: Color(0xff2b57e1),
        onPrimaryContainer: Color(0xffffffff),
        secondary: Color(0xffc7c4d8),
        onSecondary: Color(0xff302f3e),
        secondaryContainer: Color(0xff3d3c4b),
        onSecondaryContainer: Color(0xffd2cfe3),
        tertiary: Color(0xff72d8c4),
        onTertiary: Color(0xff003730),
        tertiaryContainer: Color(0xff007b6b),
        onTertiaryContainer: Color(0xffffffff),
        error: Color(0xffffb4ab),
        onError: Color(0xff690005),
        errorContainer: Color(0xff93000a),
        onErrorContainer: Color(0xffffdad6),
        surface: Color(0xff131316),
        onSurface: Color(0xffe5e1e6),
        onSurfaceVariant: Color(0xffc8c5cb),
        outline: Color(0xff919096),
        outlineVariant: Color(0xff46464b),
        shadow: Color(0xff000000),
        scrim: Color(0xff000000),
        inverseSurface: Color(0xffe5e1e6),
        inversePrimary: Color(0xff2150db),
        primaryFixed: Color(0xffdde1ff),
        onPrimaryFixed: Color(0xff001552),
        primaryFixedDim: Color(0xffb7c4ff),
        onPrimaryFixedVariant: Color(0xff0038b6),
        secondaryFixed: Color(0xffe3e0f4),
        onSecondaryFixed: Color(0xff1b1a28),
        secondaryFixedDim: Color(0xffc7c4d8),
        onSecondaryFixedVariant: Color(0xff464555),
        tertiaryFixed: Color(0xff8ff5e0),
        onTertiaryFixed: Color(0xff00201b),
        tertiaryFixedDim: Color(0xff72d8c4),
        onTertiaryFixedVariant: Color(0xff005046),
        surfaceDim: Color(0xff131316),
        surfaceBright: Color(0xff3a393c),
        surfaceContainerLowest: Color(0xff0e0e11),
        surfaceContainerLow: Color(0xff1c1b1e),
        surfaceContainer: Color(0xff201f22),
        surfaceContainerHigh: Color(0xff2a292d),
        surfaceContainerHighest: Color(0xff353438),
      ),
      drawerTheme: DrawerThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          hintStyle: TextStyle(
              color: Color(0xffc8c5cb),
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w400,
              fontSize: 12,
              letterSpacing: 0.38),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xff919096))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xffb7c4ff))),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0x1fe5e1e6))),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xffffb4ab))),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xffffb4ab)))),
      textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w400,
              fontSize: 43,
              letterSpacing: -0.19),
          displayMedium: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w400,
              fontSize: 35,
              letterSpacing: 0),
          displaySmall: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w400,
              fontSize: 28,
              letterSpacing: 0),
          headlineLarge: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w400,
              fontSize: 25,
              letterSpacing: 0),
          headlineMedium: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w400,
              fontSize: 22,
              letterSpacing: 0),
          headlineSmall: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w400,
              fontSize: 18,
              letterSpacing: 0),
          titleLarge: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: 0),
          titleMedium: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w700,
              fontSize: 16,
              letterSpacing: 0.11),
          titleSmall: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.08),
          bodyLarge: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w400,
              fontSize: 14,
              letterSpacing: 0.38),
          bodyMedium: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w400,
              fontSize: 12,
              letterSpacing: 0.38),
          bodySmall: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w400,
              fontSize: 11,
              letterSpacing: 0.3),
          labelLarge: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.08),
          labelMedium: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w500,
              fontSize: 12,
              letterSpacing: 0.38),
          labelSmall: TextStyle(
              fontFamily: "iran-sans",
              fontWeight: FontWeight.w500,
              fontSize: 11,
              letterSpacing: 0.38)));
}
