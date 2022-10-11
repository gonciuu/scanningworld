import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:scanning_world/screens/register_screen_2.dart';

import '../theme/theme.dart';
import '../widgets/auth/register_form_fields_1.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  static const String routeName = '/register';

  final _formKey = GlobalKey<FormState>();

  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushNamed(RegisterScreen2.routeName, arguments: {
        'phoneNumber': phoneNumberController.text,
        'password': passwordController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('Zarejestruj się 1/2'),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Form(
                key: _formKey,
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
                    const Text('Zarejestruj się',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 24)),
                    const SizedBox(height: 8),
                    Text(
                      'Stwórz konto, szukaj kodów QR i zdobywaj nogrody',
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),
                    RegisterFormFields1(
                        phoneNumberController: phoneNumberController,
                        passwordController: passwordController,
                        confirmPasswordController: confirmPasswordController),

                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: PlatformElevatedButton(
                        onPressed: () => _register(context),
                        child: const Text(
                          'Zarejestruj się - krok 1/2',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Masz już konto? ",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 14)),
                        PlatformTextButton(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          onPressed: () {
                            Navigator.pushNamed(context, '/sign-in');
                            //Navigator.pushReplacementNamed(context, '/register');
                          },
                          child: Text(
                            'Zaloguj się',
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
