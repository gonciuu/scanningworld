import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:scanning_world/screens/forgot_password_screen.dart';
import '../theme/theme.dart';
import '../widgets/auth/sign_in_form_fields.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = '/sign-in';

  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {


  final LocalAuthentication auth = LocalAuthentication();

  final _formKey = GlobalKey<FormState>();

  //handle sign in data
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  //handle form submission
  Future<void> _onSubmit() async {
    final List<BiometricType> availableBiometrics =
    await auth.getAvailableBiometrics();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    debugPrint('Biometrics: $availableBiometrics');
    debugPrint(canAuthenticate.toString());

    try {

      final bool didAuthenticate2 = await auth.authenticate(
          localizedReason: 'Please authenticate to show account balance',
          options: const AuthenticationOptions(biometricOnly: true));

      debugPrint(didAuthenticate2.toString());
      // ···
    } on PlatformException {
      // ...
    }

    if (_formKey.currentState!.validate()) {
      var dio = Dio(BaseOptions(
          connectTimeout: 10000,
          receiveTimeout: 10000,
          sendTimeout: 10000,
          responseType: ResponseType.plain,
          followRedirects: false,
          validateStatus: (status) {
            return true;
          })); // some dio configurations

      dio.interceptors.add(CookieManager(CookieJar()));

      var loginResponse = await dio
          .post("https://scanningworld-server.herokuapp.com/auth/login", data: {
        "phone": "123321123",
        "password": "password123"
      }); // cookies are automatically saved

      debugPrint(loginResponse.data.toString());
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
                        onPressed: _onSubmit,
                        child: const Text(
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
