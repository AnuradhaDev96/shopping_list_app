import 'package:flutter/material.dart';

abstract class TextStyles {
  static const defaultFontFamily = 'Kumbh_Sans';

  static const appBarTitleTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const sectionTitleTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}