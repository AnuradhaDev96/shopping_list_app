import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../config/themes/input_decorations.dart';
import '../../../../domain/enums/unit_of_measure_enum.dart';
import '../../../../utils/constants/app_colors.dart';

class CreateListItemDialog extends StatefulWidget {
  const CreateListItemDialog({super.key, required this.listId});

  final String listId;

  @override
  State<CreateListItemDialog> createState() => _CreateListItemDialogState();
}

class _CreateListItemDialogState extends State<CreateListItemDialog> {
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
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 26, bottom: 31, left: 20, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 23),
                    child: Text(
                      'Create new list',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
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
                  ButtonTheme(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
