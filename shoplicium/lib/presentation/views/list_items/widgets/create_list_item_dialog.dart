import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/themes/input_decorations.dart';
import '../../../../config/themes/text_styles.dart';
import '../../../../domain/enums/unit_of_measure_enum.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/resources/message_utils.dart';
import '../../../cubits/shopping_items/create_list_item_cubit.dart';
import '../../../states/data_payload_state.dart';
import '../../../widgets/primary_button_skin.dart';

class CreateListItemDialog extends StatefulWidget {
  const CreateListItemDialog({super.key, required this.listId});

  final String listId;

  @override
  State<CreateListItemDialog> createState() => _CreateListItemDialogState();
}

class _CreateListItemDialogState extends State<CreateListItemDialog> {
  final _createListItemCubit = CreateListItemCubit();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  UnitOfMeasureEnum _selectedUOM = UnitOfMeasureEnum.kg;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: FractionallySizedBox(
        heightFactor: 0.85,
        child: Padding(
          padding: const EdgeInsets.only(top: 26, bottom: 31, left: 20, right: 20),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 23),
                        child: Text(
                          'Create shopping item',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
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
                        style: TextStyles.textFieldInputTextStyle,
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
                        style: TextStyles.textFieldInputTextStyle,
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
                        child: BlocProvider<CreateListItemCubit>(
                          create: (context) => _createListItemCubit,
                          child: BlocListener<CreateListItemCubit, DataPayloadState>(
                            bloc: _createListItemCubit,
                            listener: (context, state) {
                              if (state is ErrorState) {
                                MessageUtils.showSnackBarOverBarrier(context, state.errorMessage, isErrorMessage: true);
                              } else if (state is SuccessState) {
                                Navigator.pop(context);
                                MessageUtils.showSnackBarOverBarrier(context, 'Item saved successfully');
                              }
                            },
                            child: BlocBuilder<CreateListItemCubit, DataPayloadState>(
                              bloc: _createListItemCubit,
                              builder: (context, state) {
                                if (state is RequestingState) {
                                  return const CupertinoActivityIndicator();
                                }

                                return GestureDetector(
                                  onTap: () {
                                    _saveItemToShoppingList();
                                  },
                                  child: const PrimaryButtonSkin(
                                    title: 'Save',
                                    internalPadding: EdgeInsets.fromLTRB(80, 8, 80, 10),
                                  ),
                                );
                              }
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveItemToShoppingList() {
    if (_formKey.currentState!.validate()) {
      _createListItemCubit.createListItem(
        listId: widget.listId,
        title: _titleController.text,
        amount: int.tryParse(_amountController.text) ?? 0,
        unitOfMeasure: _selectedUOM,
      );
    }
  }
}
