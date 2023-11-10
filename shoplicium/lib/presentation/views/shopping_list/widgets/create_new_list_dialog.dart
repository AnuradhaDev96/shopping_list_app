import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../config/themes/input_decorations.dart';
import '../../../../utils/resources/message_utils.dart';
import '../../../cubits/shopping_list/create_new_list_cubit.dart';
import '../../../states/data_payload_state.dart';
import '../../../widgets/primary_button_skin.dart';

class CreateNewListDialog extends StatefulWidget {
  const CreateNewListDialog({super.key});

  @override
  State<CreateNewListDialog> createState() => _CreateNewListDialogState();
}

class _CreateNewListDialogState extends State<CreateNewListDialog> {
  final _createNewListCubit = CreateNewListCubit();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _dateController = TextEditingController();

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

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
                    child: BlocProvider<CreateNewListCubit>(
                      create: (context) => _createNewListCubit,
                      child: BlocListener(
                        bloc: _createNewListCubit,
                        listener: (context, state) {
                          if (state is ErrorState) {
                            MessageUtils.showSnackBarOverBarrier(context, state.errorMessage, isErrorMessage: true);
                          } else if (state is SuccessState) {
                            Navigator.pop(context);
                            MessageUtils.showSnackBarOverBarrier(context, 'List saved successfully');
                          }
                        },
                        child: BlocBuilder<CreateNewListCubit, DataPayloadState>(
                            bloc: _createNewListCubit,
                            builder: (context, state) {
                              if (state is RequestingState) {
                                return const CupertinoActivityIndicator();
                              }

                              return GestureDetector(
                                onTap: () {
                                  saveListAndAddItems();
                                },
                                child: const PrimaryButtonSkin(
                                  title: 'Save & add items',
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

  void saveListAndAddItems() {
    if (_formKey.currentState!.validate()) {
      _createNewListCubit.createShoppingList(_titleController.text, _selectedDay);
    }
  }
}
