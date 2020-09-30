import 'package:flutter/material.dart';

Future<Null> normalDialod(BuildContext context, String string) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(string),
      children: [
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    ),
  );
}
