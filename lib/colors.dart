import 'dart:ui';

import 'package:flutter/material.dart';

class CustomColor {
  final Color successBadgeBackgroundColor;
  final Color successBadgeTextColor;

  final Color errorBadgeBackgroundColor;
  final Color errorBadgeTextColor;

  final Color warningBadgeBackgroundColor;
  final Color warningBadgeTextColor;

  CustomColor({required this.successBadgeBackgroundColor,
    required this.successBadgeTextColor,
    required this.errorBadgeBackgroundColor,
    required this.errorBadgeTextColor,
    required this.warningBadgeBackgroundColor,
    required this.warningBadgeTextColor,
  });

  static CustomColor getCustomColor(BuildContext context) {
    var brightness = MediaQuery
        .of(context)
        .platformBrightness;
    if (brightness == Brightness.dark) {
      return CustomColor(
          successBadgeBackgroundColor: Color.fromRGBO(19, 197, 107, 0.2),
          successBadgeTextColor: Color.fromRGBO(19, 197, 107, 1),
          errorBadgeBackgroundColor: Color.fromRGBO(237, 94, 94, 0.2),
          errorBadgeTextColor: Color.fromRGBO(237, 94, 94, 1),
          warningBadgeBackgroundColor: Color.fromRGBO(239, 174, 8 , 0.2),
          warningBadgeTextColor: Color.fromRGBO(239, 174, 8, 1));
    }
    return CustomColor(
        successBadgeBackgroundColor: Color.fromRGBO(19, 197, 107, 0.2),
        successBadgeTextColor: Color.fromRGBO(19, 197, 107, 1),
        errorBadgeBackgroundColor: Color.fromRGBO(237, 94, 94, 0.2),
        errorBadgeTextColor: Color.fromRGBO(237, 94, 94, 1),
        warningBadgeBackgroundColor: Color.fromRGBO(239, 174, 8 , 0.2),
        warningBadgeTextColor: Color.fromRGBO(239, 174, 8, 1));
  }
}