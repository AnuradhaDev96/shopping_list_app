import 'package:flutter/material.dart';

class ListErrorWidget extends StatelessWidget {
  const ListErrorWidget({super.key, required this.caption, this.actionButton});

  final String caption;
  final Widget? actionButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          caption,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        if (actionButton != null)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: actionButton!,
          ),
      ],
    );
  }
}