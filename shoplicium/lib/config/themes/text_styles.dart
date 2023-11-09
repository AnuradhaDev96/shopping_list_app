import 'package:flutter/material.dart';

import '../../utils/constants/app_colors.dart';

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

  static const textFieldHintStyle = TextStyle(
    color: AppColors.grey1,
    fontSize: 18.0,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w500,
  );

  static const textFieldErrorStyle = TextStyle(
    color: Colors.red,
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
  );
}