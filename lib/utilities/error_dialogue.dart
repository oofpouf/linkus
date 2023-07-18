import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String text;

  const ErrorDialog({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 241, 233, 221),
      title: const Text(
        'Error!',
        style: TextStyle(
          color: Color.fromARGB(255, 63, 50, 30),
        ),
      ),
      content: Text(text),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'OK',
            style: TextStyle(
              color: Color.fromARGB(255, 63, 50, 30),
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
