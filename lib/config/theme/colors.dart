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
      darkColor: Color.fromRGBO(55, 97, 235, 1)),
  evenRowBackgroundColor(
    lightColor: Color.fromRGBO(255, 255, 255, 1),
      darkColor: Color.fromRGBO(30, 47, 87, 1)),
  disablePaginationButtonColor(
    darkColor: Color.fromRGBO(82, 98, 124, 1),
    lightColor: Color.fromRGBO(183, 185, 188, 1)
    // lightColor: Color.fromRGBO(112, 116, 121, 1)
  ),
  tableButtonTextColor(
    darkColor: Color.fromRGBO(255, 255, 255, 1),
    lightColor: Color.fromRGBO(55, 97, 235, 1)
  ),
  oddRowBackgroundColor(
      lightColor: Color.fromRGBO(246, 246, 246, 1),
      darkColor: Color.fromRGBO(28, 44, 83, 1));

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
