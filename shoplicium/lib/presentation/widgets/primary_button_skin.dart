import 'package:flutter/material.dart';

import '../../utils/constants/app_colors.dart';

class PrimaryButtonSkin extends StatelessWidget {
  const PrimaryButtonSkin({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        padding: const EdgeInsets.fromLTRB(35, 8, 35, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              AppColors.green1,
              AppColors.green2,
            ],
          ),
          border: Border.all(width: 2, color: Colors.white, strokeAlign: BorderSide.strokeAlignOutside),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
