import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import './custom_progress_indicator.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformAlertDialog(
      content: Row(
        children: const [
          CustomProgressIndicator(),
          SizedBox(width: 10),
          Text('Loading...'),
        ],
      ),
    );
  }
}
