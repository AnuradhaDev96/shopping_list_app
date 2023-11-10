import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/assets.dart';
import '../../../widgets/primary_button_skin.dart';
import '../../../widgets/secondary_button_skin.dart';

class DeleteListItemDialog extends StatelessWidget {
  const DeleteListItemDialog({super.key, required this.listId});
  final String listId;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Assets.deleteIconWhite,
                  width: 51,
                  height: 51,
                  colorFilter: const ColorFilter.mode(AppColors.darkBlue1, BlendMode.srcIn),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Are you sure you want\nto delete this\nitem?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 35),
                const PrimaryButtonSkin(title: 'Yes', internalPadding: EdgeInsets.fromLTRB(80, 8, 80, 10)),
                const SizedBox(height: 9),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const SecondaryButtonSkin(title: 'No', internalPadding: EdgeInsets.fromLTRB(80, 8, 80, 10)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
