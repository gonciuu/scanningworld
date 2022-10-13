import 'package:flutter/material.dart';

class SmallSubtitle extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const SmallSubtitle({Key? key, required this.text, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        style: TextStyle(
            color: style?.color ?? Colors.grey.shade700,
            fontSize: style?.fontSize ?? 14,
            fontWeight: style?.fontWeight ?? FontWeight.normal));
  }
}
