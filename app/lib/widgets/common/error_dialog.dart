import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  final Function? onPressed;
  final String? buttonText;

  const ErrorDialog(
      {Key? key, required this.message, this.onPressed, this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformAlertDialog(
      title: const Text("Wystąpił błąd"),
      content: Text(message),
      actions: <Widget>[
        PlatformDialogAction(
          child: Text(
            buttonText ?? 'Ok',
            style: const TextStyle(color: Colors.red),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            if (onPressed != null) {
              onPressed!();
            }
          },
        ),
      ],
    );
  }
}
