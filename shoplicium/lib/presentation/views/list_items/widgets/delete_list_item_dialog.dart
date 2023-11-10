import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/assets.dart';
import '../../../../utils/resources/message_utils.dart';
import '../../../cubits/shopping_items/delete_shopping_list_cubit.dart';
import '../../../states/data_payload_state.dart';
import '../../../widgets/primary_button_skin.dart';
import '../../../widgets/secondary_button_skin.dart';

class DeleteListItemDialog extends StatelessWidget {
  DeleteListItemDialog({super.key, required this.listId});

  final String listId;

  final _deleteListCubit = DeleteShoppingListCubit();

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
                BlocProvider<DeleteShoppingListCubit>(
                  create: (context) => _deleteListCubit,
                  child: BlocListener<DeleteShoppingListCubit, DataPayloadState>(
                    listener: (context, state) {
                      if (state is ErrorState) {
                        MessageUtils.showSnackBarOverBarrier(context, state.errorMessage, isErrorMessage: true);
                      } else if (state is SuccessState) {
                        int pagesToPop = 2;
                        Navigator.popUntil(context, (route) {
                          return pagesToPop-- == 0;
                        });
                        MessageUtils.showSnackBarOverBarrier(context, 'Shopping list deleted successfully');
                      }
                    },
                    child: BlocBuilder<DeleteShoppingListCubit, DataPayloadState>(
                      builder: (context, state) {
                        if (state is RequestingState) {
                          return const CupertinoActivityIndicator();
                        }

                        return GestureDetector(
                          onTap: () {
                            _deleteListCubit.deleteShoppingList(listId);
                          },
                          child: const PrimaryButtonSkin(
                            title: 'Yes',
                            internalPadding: EdgeInsets.fromLTRB(80, 8, 80, 10),
                          ),
                        );
                      },
                    ),
                  ),
                ),
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
