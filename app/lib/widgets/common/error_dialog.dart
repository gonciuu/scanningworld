
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ErrorDialog extends StatelessWidget {
  final String message;

  const ErrorDialog({Key? key, required this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PlatformAlertDialog(
     
      title: const Text("Wystąpił błąd"),
      content: Text(message),
      actions: <Widget>[
        PlatformDialogAction(
          child: const Text('OK',style: TextStyle(color: Colors.red),),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
