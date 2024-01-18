import 'dart:io';

import 'package:firebase_auth_bloc/models/custom_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void errorDialog(BuildContext context, CustomError error) {
  print(
      'code: ${error.code}\n message:${error.message}\nplugin:${error.plugin}');
  if (Platform.isIOS) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(error.code),
            content: Text('${error.plugin}\n${error.message}'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  } else {
    showDialog(
        context: context,
        builder: (contex) {
          return AlertDialog(
            title: Text(error.code),
            content: Text('${error.plugin}\n${error.message}'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
