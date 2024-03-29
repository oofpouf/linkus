import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String text, String key) async {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        key: Key(key),
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
    },
  );
}
