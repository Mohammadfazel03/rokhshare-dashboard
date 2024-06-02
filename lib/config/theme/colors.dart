import 'dart:ui';

import 'package:flutter/material.dart';

enum CustomColor {
  successBadgeBackgroundColor(
      lightColor: Color.fromRGBO(19, 197, 107, 0.2),
      darkColor: Color.fromRGBO(19, 197, 107, 0.2)),
  successBadgeTextColor(
      lightColor: Color.fromRGBO(19, 197, 107, 1),
      darkColor: Color.fromRGBO(19, 197, 107, 1)),
  errorBadgeBackgroundColor(
      lightColor: Color.fromRGBO(237, 94, 94, 0.2),
      darkColor: Color.fromRGBO(237, 94, 94, 0.2)),
  errorBadgeTextColor(
      lightColor: Color.fromRGBO(237, 94, 94, 1),
      darkColor: Color.fromRGBO(237, 94, 94, 1)),
  warningBadgeBackgroundColor(
      lightColor: Color.fromRGBO(239, 174, 8, 0.2),
      darkColor: Color.fromRGBO(239, 174, 8, 0.2)),
  warningBadgeTextColor(
      lightColor: Color.fromRGBO(239, 174, 8, 1),
      darkColor: Color.fromRGBO(239, 174, 8, 1)),
  loginBackgroundColor(
      lightColor: Color.fromRGBO(55, 97, 235, 1),
      darkColor: Color.fromRGBO(55, 97, 235, 1));

  final Color _lightColor;
  final Color _darkColor;

  const CustomColor({required Color lightColor, required Color darkColor})
      : _darkColor = darkColor,
        _lightColor = lightColor;

  Color getColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? _darkColor
        : _lightColor;
  }
}
