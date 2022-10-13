import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: PlatformCircularProgressIndicator(
        cupertino: (_, __) =>
            CupertinoProgressIndicatorData(
              radius: 12,
            ),
      ),
    );
  }
}
