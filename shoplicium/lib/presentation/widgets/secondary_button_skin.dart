import 'package:flutter/material.dart';

import '../../utils/constants/app_colors.dart';

class SecondaryButtonSkin extends StatelessWidget {
  const SecondaryButtonSkin({
    super.key,
    required this.title,
    this.internalPadding = const EdgeInsets.fromLTRB(35, 8, 35, 10),
  });

  final String title;
  final EdgeInsetsGeometry internalPadding;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        padding: internalPadding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.grey1,
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
