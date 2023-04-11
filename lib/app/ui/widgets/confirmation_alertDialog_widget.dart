import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ConfirmationAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function() confirmAction;

  const ConfirmationAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmAction,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(
        content,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => {
            Navigator.pop(context, 'OK'),
            confirmAction(),
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
