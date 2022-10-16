import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../theme/widgets_base_theme.dart';

class PlatformInput extends StatelessWidget {
  final String? Function(String?)? validator;
  final String? Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final String? hintText;
  final String? labelText;
  final String? initialValue;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final int? maxLength;

  const PlatformInput(
      {Key? key,
      this.validator,
      this.onChanged,
      this.hintText,
      this.labelText,
      this.initialValue,
      this.obscureText = false,
      this.maxLength,
      this.keyboardType,
      this.textInputAction = TextInputAction.next,
      this.focusNode,
      this.controller,
      this.prefixIcon,
      this.onFieldSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformTextFormField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      obscureText: obscureText,
      maxLength: maxLength,
      textInputAction: textInputAction,
      hintText: hintText,
      cupertino: (_, __) => cupertinoTextFieldDecoration(
          prefix: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 4),
        child: Icon(
          prefixIcon,
          color: Colors.black,
        ),
      )),
      material: (_, __) => MaterialTextFormFieldData(
        decoration: materialInputDecoration.copyWith(
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
