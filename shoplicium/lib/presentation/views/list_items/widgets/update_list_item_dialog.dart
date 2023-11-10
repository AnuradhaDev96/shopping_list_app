import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/themes/input_decorations.dart';
import '../../../../domain/enums/unit_of_measure_enum.dart';
import '../../../../domain/models/list_item_dto.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/assets.dart';
import '../../../../utils/resources/message_utils.dart';
import '../../../cubits/shopping_items/update_list_item_cubit.dart';
import '../../../states/data_payload_state.dart';
import '../../../widgets/primary_button_skin.dart';

class UpdateListItemDialog extends StatefulWidget {
  const UpdateListItemDialog({super.key, required this.selectedItem});

  final ListItemDto selectedItem;

  @override
  State<UpdateListItemDialog> createState() => _UpdateListItemDialogState();
}

class _UpdateListItemDialogState extends State<UpdateListItemDialog> {
  final _updateCubit = UpdateListItemCubit();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  UnitOfMeasureEnum _selectedUOM = UnitOfMeasureEnum.kg;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.selectedItem.title;
    _amountController.text = widget.selectedItem.amount.toString();
    _selectedUOM = widget.selectedItem.UOM;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 26, bottom: 31, left: 20, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 23),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Create shopping item',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SvgPicture.asset(
                          Assets.deleteIconWhite,
                          width: 27,
                          height: 27,
                          colorFilter: const ColorFilter.mode(AppColors.darkBlue1, BlendMode.srcIn),
                        ),
                      ],
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Title',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title is required';
                      }

                      return null;
                    },
                    decoration: InputDecorations.outlinedInputDecoration(hintText: 'ex: Cheese'),
                  ),
                  const SizedBox(height: 22),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Amount',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Amount is required';
                      }

                      return null;
                    },
                    decoration: InputDecorations.outlinedInputDecoration(hintText: 'ex: 50'),
                  ),
                  const SizedBox(height: 22),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Unit of measure',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 62,
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonFormField<UnitOfMeasureEnum>(
                        value: _selectedUOM,
                        items: UnitOfMeasureEnum.values
                            .map(
                              (item) => DropdownMenuItem<UnitOfMeasureEnum>(
                                value: item,
                                child: Text(
                                  '${item.text} (${item.symbol})',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        dropdownColor: AppColors.blue1,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.blue1,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                        borderRadius: BorderRadius.circular(8),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                        enableFeedback: true,
                        iconEnabledColor: Colors.white,
                        iconSize: 30,
                        onChanged: (UnitOfMeasureEnum? value) {
                          _selectedUOM = value ?? UnitOfMeasureEnum.kg;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: BlocProvider<UpdateListItemCubit>(
                      create: (context) => _updateCubit,
                      child: BlocListener<UpdateListItemCubit, DataPayloadState>(
                        bloc: _updateCubit,
                        listener: (context, state) {
                          if (state is ErrorState) {
                            MessageUtils.showSnackBarOverBarrier(context, state.errorMessage, isErrorMessage: true);
                          } else if (state is SuccessState) {
                            Navigator.pop(context);
                            MessageUtils.showSnackBarOverBarrier(context, 'Item updated successfully');
                          }
                        },
                        child: BlocBuilder<UpdateListItemCubit, DataPayloadState>(
                            bloc: _updateCubit,
                            builder: (context, state) {
                              if (state is RequestingState) {
                                return const CupertinoActivityIndicator();
                              }

                              return GestureDetector(
                                onTap: () {
                                  _updateListItem();
                                },
                                child: const PrimaryButtonSkin(
                                  title: 'Update',
                                  internalPadding: EdgeInsets.fromLTRB(80, 8, 80, 10),
                                ),
                              );
                            }),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateListItem() {
    if (_formKey.currentState!.validate()) {
      _updateCubit.updateListItem(
        title: _titleController.text,
        amount: int.tryParse(_amountController.text) ?? 0,
        unitOfMeasure: _selectedUOM,
        existingData: widget.selectedItem,
      );
    }
  }
}
