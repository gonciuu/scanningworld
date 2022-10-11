import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:scanning_world/utils/extensions.dart';

import '../../theme/widgtes_base_theme.dart';

class RegisterFormFields2 extends StatelessWidget {
  const RegisterFormFields2(
      {Key? key,
        required this.usernameController,
        required this.emailController,
      })
      : super(key: key);

  final TextEditingController usernameController;
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    final Widget usernameField = PlatformTextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'To pole nie może być puste';
        }

        return null;
      },
      controller: usernameController,
      textInputAction: TextInputAction.next,
      cupertino: (_, __) => cupertinoTextFieldDecoration(
          placeholder: 'Nazwa użytkownika',
          prefix: const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 4),
            child: Icon(
              CupertinoIcons.person,
              color: Colors.black,
            ),
          )),
      material: (_, __) => MaterialTextFormFieldData(
        decoration: materialInputDecoration.copyWith(
          prefixIcon: const Icon(
            Icons.person_outline,
            color: Colors.black,
          ),
          hintText: 'Nazwa użytkownika',
        ),
      ),
    );

    final Widget emailField = PlatformTextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'To pole nie może być puste';
        }
        if(!value.isValidEmail()){
          return 'Niepoprawny adres email';
        }
        return null;
      },
      controller: emailController,
      obscureText: true,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      cupertino: (_, __) => cupertinoTextFieldDecoration(
          placeholder: 'Hasło',
          prefix: const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 4),
            child: Icon(
              Icons.alternate_email_outlined,
              color: Colors.black,
            ),
          )),
      material: (_, __) => MaterialTextFormFieldData(
        decoration: materialInputDecoration.copyWith(
          prefixIcon: const Icon(
            Icons.alternate_email_outlined,
            color: Colors.black,
          ),
          hintText: 'Hasło',
        ),
      ),
    );


    return Platform.isIOS
        ? CupertinoFormSection.insetGrouped(
        margin: EdgeInsets.zero,
        children: [usernameField, emailField])
        : Column(
      children: [
        usernameField,
        const SizedBox(height: 12),
        emailField,
        const SizedBox(height: 12),

      ],
    );
  }
}
