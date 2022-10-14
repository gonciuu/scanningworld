import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/data/local/secure_storage_manager.dart';

import 'package:scanning_world/screens/forgot_password_screen.dart';
import 'package:scanning_world/screens/wrappers/home_wrapper.dart';
import 'package:scanning_world/widgets/common/custom_progress_indicator.dart';
import 'package:scanning_world/widgets/common/error_dialog.dart';
import '../data/remote/http/http_exception.dart';
import '../data/remote/providers/auth_provider.dart';
import '../theme/theme.dart';
import '../widgets/auth/set_auth_pin_code_bottom_sheet.dart';
import '../widgets/auth/sign_in_form_fields.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = '/sign-in';

  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SecureStorageManager secureStorageManager = SecureStorageManager();

  final _formKey = GlobalKey<FormState>();

  //handle sign in data
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  String pinCode = '';

  void onPinCodeSet(String pin) {
    debugPrint("CODE WAS BEEN SET $pin");
    pinCode = pin;
  }

  bool _isLoading = false;

  Future<void> _setPinCode() async {
    await showPlatformModalSheet(
        context: context,
        cupertino: CupertinoModalSheetData(
            barrierDismissible: true, useRootNavigator: true),
        material: MaterialModalSheetData(
          enableDrag: false,
          isDismissible: false,
          backgroundColor: Colors.white,
          isScrollControlled: true,
        ),
        builder: (context) =>
            SetAuthPinCodeBottomSheet(onPinCodeSet: onPinCodeSet));
  }

  //handle form submission
  Future<void> _onSubmit() async {
    final authProvider = context.read<AuthProvider>();
    if (_formKey.currentState!.validate()) {
      try {
        final curPin = await secureStorageManager.getPinCode();
        if (curPin == null || curPin.length != 4) {
          if(pinCode.length != 4){
            await _setPinCode();
          }
        } else {
          pinCode = curPin;
        }
        //bad pin code provided
        if (pinCode.length != 4) {
          return;
        }
        setState(() => _isLoading = true);
        final response = await authProvider.signIn(
          phoneNumberController.text,
          passwordController.text,
          pinCode,
        );

        debugPrint("response: ${response.toJson().toString()}");
        // login successful
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(HomeWrapper.routeName);
      } on HttpError catch (e) {
        showPlatformDialog(
            context: context,
            builder: (_) => ErrorDialog(message: "Error:  ${e.message}"));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Zaloguj się'),
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
                onChanged: () {
                  Form.of(primaryFocus!.context!)?.save();
                },
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/logo_scanningworld.png',
                      width: 120,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text('Zaloguj się',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 24)),
                    const SizedBox(height: 8),
                    Text(
                      'Zaloguj się na swoje konto, szukaj kodów QR i zdobywaj nogrody',
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),
                    SignInFormFields(
                      phoneNumberController: phoneNumberController,
                      passwordController: passwordController,
                      onSubmit: _onSubmit,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PlatformTextButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 0),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, ForgotPasswordScreen.routeName);
                          },
                          child: Text(
                            'Zapomniałem hasła',
                            style: TextStyle(color: primary[600], fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: PlatformElevatedButton(
                        onPressed: _isLoading ? null : _onSubmit,
                        child: _isLoading
                            ? const CustomProgressIndicator()
                            : const Text(
                                'Zaloguj się',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Nie masz konta? ",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 14)),
                        PlatformTextButton(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                            //Navigator.pushReplacementNamed(context, '/register');
                          },
                          child: Text(
                            'Zarejestruj się',
                            style: TextStyle(color: primary[600], fontSize: 14),
                          ),
                        ),
                      ],
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
