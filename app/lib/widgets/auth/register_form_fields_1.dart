import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../theme/widgtes_base_theme.dart';

class RegisterFormFields1 extends StatelessWidget {
  const RegisterFormFields1(
      {Key? key,
      required this.phoneNumberController,
      required this.passwordController,
      required this.confirmPasswordController})
      : super(key: key);

  final TextEditingController phoneNumberController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    final Widget phoneNumberField = PlatformTextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'To pole nie może być puste';
        }
        if (value.length < 9) {
          return 'Podaj poprawny format numeru telefonu';
        }
        return null;
      },
      controller: phoneNumberController,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      cupertino: (_, __) => cupertinoTextFieldDecoration(
          placeholder: 'Nr. Telefonu',
          prefix: const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 4),
            child: Icon(
              CupertinoIcons.phone,
              color: Colors.black,
            ),
          )),
      material: (_, __) => MaterialTextFormFieldData(
        decoration: materialInputDecoration.copyWith(
          prefixIcon: const Icon(
            Icons.phone_outlined,
            color: Colors.black,
          ),
          hintText: 'Nr. Telefonu',
        ),
      ),
    );

    final Widget passwordField = PlatformTextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'To pole nie może być puste';
        }
        if (value.length < 6) {
          return 'Hasło musi mieć co najmniej 6 znaków';
        }
        return null;
      },
      controller: passwordController,
      obscureText: true,
      textInputAction: TextInputAction.next,
      cupertino: (_, __) => cupertinoTextFieldDecoration(
          placeholder: 'Hasło',
          prefix: const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 4),
            child: Icon(
              CupertinoIcons.lock,
              color: Colors.black,
            ),
          )),
      material: (_, __) => MaterialTextFormFieldData(
        decoration: materialInputDecoration.copyWith(
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: Colors.black,
          ),
          hintText: 'Hasło',
        ),
      ),
    );
    final Widget confirmPasswordField = PlatformTextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'To pole nie może być puste';
        }
        if (value != passwordController.text) {
          return 'Hasła nie są takie same';
        }
        return null;
      },
      controller: confirmPasswordController,
      obscureText: true,
      textInputAction: TextInputAction.done,
      cupertino: (_, __) => cupertinoTextFieldDecoration(
          placeholder: 'Powtórz Hasło',
          prefix: const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 4),
            child: Icon(
              CupertinoIcons.lock,
              color: Colors.black,
            ),
          )),
      material: (_, __) => MaterialTextFormFieldData(
        decoration: materialInputDecoration.copyWith(
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: Colors.black,
          ),
          hintText: 'Powtórz Hasło',
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoFormSection.insetGrouped(
            margin: EdgeInsets.zero,
            children: [phoneNumberField, passwordField,confirmPasswordField])
        : Column(
            children: [
              phoneNumberField,
              const SizedBox(height: 12),
              passwordField,
              const SizedBox(height: 12),
              confirmPasswordField,
            ],
          );
  }
}
