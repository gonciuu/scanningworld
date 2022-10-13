import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class BigTitle extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const BigTitle({Key? key, required this.text, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: platformThemeData(
        context,
        material: (data) => data.textTheme.headline5!.copyWith(
          fontWeight: style?.fontWeight ?? FontWeight.bold,
          color: style?.color,
          fontSize: style?.fontSize,

        ),
        cupertino: (data) => data.textTheme.navLargeTitleTextStyle.copyWith(
          fontWeight: style?.fontWeight ?? FontWeight.bold,
          color: style?.color,
          fontSize: style?.fontSize,
        ),
      ),
    );
  }
}
