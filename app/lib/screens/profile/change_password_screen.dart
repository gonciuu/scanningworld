import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:scanning_world/theme/widgets_base_theme.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  static const String routeName = '/change_password';

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class ChangePasswordData {
  String oldPassword = '';
  String newPassword = '';
  String newPasswordRepeat = '';
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ChangePasswordData _changePasswordData = ChangePasswordData();

  @override
  Widget build(BuildContext context) {
    final Widget oldPasswordField = PlatformTextFormField(
      onChanged: (value) => _changePasswordData.oldPassword = value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'To pole nie może być puste';
        }
        return null;
      },
      cupertino: (_, __) => cupertinoTextFieldDecoration(
          prefix: const Padding(
        padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 4),
        child: Icon(
          CupertinoIcons.lock_open,
          color: Colors.black,
        ),
      )),
      material: (_, __) => MaterialTextFormFieldData(
        decoration: materialInputDecoration.copyWith(
          prefixIcon: const Icon(
            Icons.lock_open_outlined,
            color: Colors.black,
          ),
        ),
      ),
      obscureText: true,
      textInputAction: TextInputAction.next,
      hintText: 'Stare hasło',
    );

    final Widget newPasswordField = PlatformTextFormField(
      onChanged: (value) => _changePasswordData.newPassword = value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'To pole nie może być puste';
        }
        if (value.length < 6) {
          return 'Hasło musi mieć co najmniej 6 znaków';
        }
        return null;
      },
      obscureText: true,
      textInputAction: TextInputAction.next,
      hintText: 'Nowe hasło',
      cupertino: (_, __) => cupertinoTextFieldDecoration(
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
        ),
      ),
    );

    final Widget confirmNewPasswordField = PlatformTextFormField(
      onChanged: (value) => _changePasswordData.newPasswordRepeat = value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'To pole nie może być puste';
        }
        if (value != _changePasswordData.newPassword) {
          return 'Hasła nie są takie same';
        }
        return null;
      },
      obscureText: true,
      textInputAction: TextInputAction.done,
      hintText: 'Powtórz Nowe hasło',
      cupertino: (_, __) => cupertinoTextFieldDecoration(
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
        ),
      ),
    );

    Widget platformInputGroups = Platform.isIOS
        ? CupertinoFormSection.insetGrouped(
            header: const Text('Zmień hasło'),
            margin: EdgeInsets.zero,
            children: [
                oldPasswordField,
                newPasswordField,
                confirmNewPasswordField
              ])
        : Column(
            children: [
              oldPasswordField,
              const SizedBox(height: 12),
              newPasswordField,
              const SizedBox(height: 12),
              confirmNewPasswordField,
            ],
          );

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Zmień hasło'),
        cupertino: (_, __) => CupertinoNavigationBarData(
          transitionBetweenRoutes: false,
          heroTag: 'change_password',
          previousPageTitle: 'Profil',
        ),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              platformInputGroups,
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: PlatformElevatedButton(
                  child: const Text(
                    'Zapisz zmiany',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
