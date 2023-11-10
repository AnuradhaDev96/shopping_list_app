import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../config/themes/input_decorations.dart';
import '../../../../domain/models/shopping_list_dto.dart';
import '../../../../utils/resources/message_utils.dart';
import '../../../cubits/shopping_items/update_shopping_list_cubit.dart';
import '../../../states/data_payload_state.dart';
import '../../../widgets/primary_button_skin.dart';

class UpdateShoppingListDialog extends StatefulWidget {
  const UpdateShoppingListDialog({super.key, required this.selectedList});
  final ShoppingListDto selectedList;

  @override
  State<UpdateShoppingListDialog> createState() => _UpdateShoppingListDialogState();
}

class _UpdateShoppingListDialogState extends State<UpdateShoppingListDialog> {
  final _updateCubit = UpdateShoppingListCubit();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _dateController = TextEditingController();

  late DateTime _selectedDay;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.selectedList.title;
    _dateController.text = DateFormat("EEEE d, MMM y").format(widget.selectedList.date);
    _selectedDay = widget.selectedList.date;
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
                  const Padding(
                    padding: EdgeInsets.only(bottom: 23),
                    child: Text(
                      'Create new list',
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
                    decoration: InputDecorations.outlinedInputDecoration(hintText: 'ex: Awesome shopping'),
                  ),
                  const SizedBox(height: 22),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Shopping date',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _dateController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    readOnly: true,
                    onTap: () => showDatePickerDialog(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Date is required';
                      }

                      return null;
                    },
                    decoration: InputDecorations.outlinedInputDecoration(hintText: 'Tap to select date'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 120),
                    child: BlocProvider<UpdateShoppingListCubit>(
                      create: (context) => _updateCubit,
                      child: BlocListener(
                        bloc: _updateCubit,
                        listener: (context, state) {
                          if (state is ErrorState) {
                            MessageUtils.showSnackBarOverBarrier(context, state.errorMessage, isErrorMessage: true);
                          } else if (state is SuccessState) {
                            Navigator.pop(context);
                            MessageUtils.showSnackBarOverBarrier(context, 'Shopping list updated successfully');
                          }
                        },
                        child: BlocBuilder<UpdateShoppingListCubit, DataPayloadState>(
                            bloc: _updateCubit,
                            builder: (context, state) {
                              if (state is RequestingState) {
                                return const CupertinoActivityIndicator();
                              }

                              return GestureDetector(
                                onTap: () {
                                  _updateShoppingList();
                                },
                                child: const PrimaryButtonSkin(
                                  title: 'Update',
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

  void showDatePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (pickerContext) {
        return Dialog(
          child: Wrap(
            children: [
              TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(
                  const Duration(days: 365 * 10),
                ),
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;

                    _dateController.text = DateFormat("EEEE d, MMM y").format(_selectedDay);
                  });
                  Navigator.pop(context);
                },
                onFormatChanged: (format) {
                  return;
                },
              )
            ],
          ),
        );
      },
    );
  }

  void _updateShoppingList() {
    if (_formKey.currentState!.validate()) {
      _updateCubit.updateShoppingList(_titleController.text, _selectedDay, widget.selectedList);
    }
  }
}
