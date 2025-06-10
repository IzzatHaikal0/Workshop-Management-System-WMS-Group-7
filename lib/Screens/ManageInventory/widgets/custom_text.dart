import 'package:flutter/material.dart';

class MyTextStyles {
  static const String _fontFamily = 'Poppins';

  static const TextStyle light = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle regular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle medium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle semiBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
  );

  static TextStyle custom({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = Colors.black,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
