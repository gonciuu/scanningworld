import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
