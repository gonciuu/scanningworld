import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:scanning_world/utils/validators.dart';
import 'package:scanning_world/widgets/common/platfrom_input.dart';

import '../../data/remote/models/auth/auth.dart';
import '../common/platform_input_group.dart';

class RegisterFormFields1 extends StatelessWidget {
  const RegisterFormFields1({
    Key? key,
    required this.registerData,
    required this.nextStep,
  }) : super(key: key);

  final RegisterData registerData;
  final Function nextStep;

  @override
  Widget build(BuildContext context) {
    final Widget phoneNumberField = PlatformInput(
      controller: TextEditingController(text: registerData.phone),
      validator: checkPhoneNumber,
      onChanged: (value) => registerData.phone = value,
      keyboardType: TextInputType.phone,
      prefixIcon: context.platformIcon(
          material: Icons.phone_outlined, cupertino: CupertinoIcons.phone),
      hintText: 'Nr. Telefonu',
    );

    final Widget passwordField = PlatformInput(
      controller: TextEditingController(text: registerData.password),
      validator: checkPassword,
      onChanged: (value) => registerData.password = value,
      obscureText: true,
      hintText: 'Hasło',
      prefixIcon: context.platformIcon(
          material: Icons.lock_outline_rounded, cupertino: CupertinoIcons.lock),
    );

    final Widget confirmPasswordField = PlatformInput(
      onFieldSubmitted: (str) => nextStep(),
      controller: TextEditingController(text: registerData.confirmPassword),
      validator: (v) => checkConfirmPassword(registerData.password, v),
      onChanged: (value) => registerData.confirmPassword = value,
      obscureText: true,
      textInputAction: TextInputAction.done,
      hintText: 'Powtórz hasło',
      prefixIcon: context.platformIcon(
          material: Icons.lock_outline_rounded, cupertino: CupertinoIcons.lock),
    );

    return PlatformInputGroup(
      children: [
        phoneNumberField,
        passwordField,
        confirmPasswordField,
      ],
    );
  }
}
