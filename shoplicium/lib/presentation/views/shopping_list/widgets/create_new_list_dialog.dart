import 'package:flutter/material.dart';

import '../../../../config/themes/input_decorations.dart';
import '../../../widgets/primary_button_skin.dart';

class CreateNewListDialog extends StatelessWidget {
  CreateNewListDialog({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _dateController = TextEditingController();

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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Date is required';
                      }

                      return null;
                    },
                    decoration: InputDecorations.outlinedInputDecoration(hintText: 'Tap to select date'),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 120),
                    child: PrimaryButtonSkin(
                      title: 'Save & add items',
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
}
