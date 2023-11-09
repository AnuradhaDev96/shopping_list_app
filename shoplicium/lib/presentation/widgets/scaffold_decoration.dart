import 'package:flutter/material.dart';

import '../../utils/constants/app_colors.dart';

class ScaffoldDecoration extends StatelessWidget {
  const ScaffoldDecoration({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            AppColors.blue1,
            AppColors.blue2,
          ],
        ),
      ),
      child: child,
    );
  }
}
