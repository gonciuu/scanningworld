import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:scanning_world/widgets/auth/register_form_fields_2.dart';

import '../theme/theme.dart';
import '../widgets/auth/register_form_fields_1.dart';

class RegisterScreen2 extends StatelessWidget {
  RegisterScreen2({Key? key}) : super(key: key);

  static const String routeName = '/register2';

  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();

  Future<void> _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {


    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('Zarejestruj się 2/2'),
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
                    const Text('Zarejestruj się 2/2',
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
                    RegisterFormFields2(
                      usernameController: usernameController,
                      emailController: emailController,
                    ),

                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: PlatformElevatedButton(
                        onPressed: () => _register(context),
                        child: const Text(
                          'Zarejestruj się',
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
