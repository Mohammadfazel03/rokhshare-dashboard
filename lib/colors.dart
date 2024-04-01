import 'dart:ui';

import 'package:flutter/material.dart';

class CustomColor {
  final Color successBadgeBackgroundColor;
  final Color successBadgeTextColor;

  final Color errorBadgeBackgroundColor;
  final Color errorBadgeTextColor;

  CustomColor({required this.successBadgeBackgroundColor,
    required this.successBadgeTextColor,
    required this.errorBadgeBackgroundColor,
    required this.errorBadgeTextColor});

  static CustomColor getCustomColor(BuildContext context) {
    var brightness = MediaQuery
        .of(context)
        .platformBrightness;
    if (brightness == Brightness.dark) {
      return CustomColor(
          successBadgeBackgroundColor: Color.fromRGBO(220, 246, 233, 1),
          successBadgeTextColor: Color.fromRGBO(19, 197, 107, 1),
          errorBadgeBackgroundColor: Color.fromRGBO(252, 231, 231, 1),
          errorBadgeTextColor: Color.fromRGBO(237, 94, 94, 1));
    }
    return CustomColor(
        successBadgeBackgroundColor: Color.fromRGBO(220, 246, 233, 1),
        successBadgeTextColor: Color.fromRGBO(19, 197, 107, 1),
        errorBadgeBackgroundColor: Color.fromRGBO(252, 231, 231, 1),
        errorBadgeTextColor: Color.fromRGBO(237, 94, 94, 1));
  }
}