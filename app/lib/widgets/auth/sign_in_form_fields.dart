import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:scanning_world/utils/validators.dart';
import 'package:scanning_world/widgets/common/platform_input_group.dart';
import 'package:scanning_world/widgets/common/platfrom_input.dart';

import '../../theme/widgets_base_theme.dart';

class SignInFormFields extends StatelessWidget {
  final TextEditingController phoneNumberController;
  final TextEditingController passwordController;
  final Function onSubmit;

  const SignInFormFields(
      {Key? key,
      required this.phoneNumberController,
      required this.passwordController,
      required this.onSubmit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget phoneNumberField = PlatformInput(
        validator: checkPhoneNumber,
        controller: phoneNumberController,
        keyboardType: TextInputType.phone,
        hintText: 'Nr. Telefonu',
        prefixIcon: context.platformIcon(
            material: Icons.phone_outlined, cupertino: CupertinoIcons.phone));

    final Widget passwordField = PlatformInput(
      onFieldSubmitted: (e) => onSubmit(),
      controller: passwordController,
      obscureText: true,
      textInputAction: TextInputAction.done,
      hintText: 'Hasło',
      prefixIcon: context.platformIcon(
          material: Icons.lock_outline_rounded, cupertino: CupertinoIcons.lock),
    );

    return PlatformInputGroup(children: [
      phoneNumberField,
      passwordField,
    ]);
  }
}
