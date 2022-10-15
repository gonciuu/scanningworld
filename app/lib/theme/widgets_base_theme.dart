import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:pinput/pinput.dart';
import 'package:scanning_world/theme/theme.dart';

CupertinoTextFormFieldData cupertinoTextFieldDecoration(
        {required String placeholder, Widget? prefix}) =>
    CupertinoTextFormFieldData(
        cursorColor: primary[700],
        placeholder: placeholder,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        prefix: prefix);

InputDecoration materialInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.zero,
  filled: true,
  fillColor: Colors.white,
  border: OutlineInputBorder(
    gapPadding: 0,
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(10),
  ),
);

final defaultPinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: const TextStyle(
      fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(20),
  ),
);

final focusedPinTheme = defaultPinTheme.copyDecorationWith(
  border: Border.all(color: primary[500]!),
  borderRadius: BorderRadius.circular(8),
);

