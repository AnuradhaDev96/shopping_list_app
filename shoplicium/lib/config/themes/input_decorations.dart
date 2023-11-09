import 'package:flutter/material.dart';

import '../../utils/constants/app_colors.dart';
import 'text_styles.dart';

abstract class InputDecorations {
  static InputDecoration outlinedInputDecoration({String? hintText, Widget? suffixIcon}) => InputDecoration(
    counter: const SizedBox.shrink(),
    hintText: hintText,
    hintStyle: TextStyles.textFieldHintStyle,
    errorStyle: TextStyles.textFieldErrorStyle,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.black,
        width: 1,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.black,
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: AppColors.darkBlue1,
        width: 2,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 1,
      ),
    ),
    contentPadding: const EdgeInsets.all(11.0),
    suffixIcon: suffixIcon,
  );
}
