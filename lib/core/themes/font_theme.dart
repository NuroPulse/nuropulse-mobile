import 'package:flutter/material.dart';

abstract final class FontTheme {
  static const String fontFamily = 'Plus Jakarta Sans';

  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.32,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    height: 34 / 26,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle heading = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    height: 30 / 22,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    height: 30 / 20,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    height: 28 / 18,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle data = TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    height: 44 / 40,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.4,
  );
}
