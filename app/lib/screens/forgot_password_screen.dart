import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/data/remote/providers/auth_provider.dart';
import 'package:scanning_world/widgets/common/custom_progress_indicator.dart';
import 'package:scanning_world/widgets/common/error_dialog.dart';

import '../data/remote/http/http_exception.dart';
import '../theme/theme.dart';
import '../theme/widgets_base_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgot-password';

  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Form controller
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneNumberController = TextEditingController();

  var _isLoading = false;

  // handle form submission and send reset password link
  Future<void> _resetPassword() async {
    final authProvider = context.read<AuthProvider>();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        setState(() => _isLoading = true);
        await authProvider.forgotPassword(_phoneNumberController.text);
        showPlatformDialog(
            context: context,
            builder: (c) => PlatformAlertDialog(
                  title: const Text('Wysłano'),
                  content: const Text('Sprawdź swoją skrzynkę pocztową'),
                  actions: <Widget>[
                    PlatformDialogAction(
                      child: Text(
                        'OK',
                        style: TextStyle(color: primary[700]),
                      ),
                      onPressed: () => Navigator.of(context)
                        ..pop()
                        ..pop(),
                    ),
                  ],
                ));
      } on HttpError catch (e) {
        showPlatformDialog(
            context: context, builder: (_) => ErrorDialog(message: e.message));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailField = PlatformTextFormField(
      controller: _phoneNumberController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'To pole nie może być puste';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      cupertino: (_, __) => cupertinoTextFieldDecoration(
          placeholder: 'Numer Telefonu',
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
          hintText: 'Numer Telefonu',
        ),
      ),
    );

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Zapomniałem hasła'),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/logo_scanningworld.png',
                      width: 120,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text('Zapomniałem hasła',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 24)),
                    const SizedBox(height: 8),
                    Text(
                      'Wyślemy ci maila resetującego hasło',
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),
                    Platform.isIOS
                        ? CupertinoFormSection.insetGrouped(
                            margin: EdgeInsets.zero, children: [emailField])
                        : emailField,
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: PlatformElevatedButton(
                        onPressed: _isLoading ? null : _resetPassword,
                        child: _isLoading
                            ? const CustomProgressIndicator()
                            : const Text(
                                'Zesetuj hasło',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
