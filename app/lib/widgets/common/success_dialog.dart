import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../theme/theme.dart';

class SuccessDialog extends StatelessWidget {
  final String? title;
  final String content;
  final Function() onButtonPressed;

  const SuccessDialog(
      {super.key, required this.content, required this.onButtonPressed,this.title = 'Sukces'});

  @override
  Widget build(BuildContext context) {
    return PlatformAlertDialog(
      title: const Text('Sukces'),
      content: Text(content),
      actions: [
        PlatformDialogAction(
            child: Text('Ok', style: TextStyle(color: primary[700])),
            onPressed: () {
              Navigator.of(context).pop();
              onButtonPressed();
            }),
      ],
    );
  }
}
