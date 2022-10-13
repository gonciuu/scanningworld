import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/screens/wrappers/home_wrapper.dart';
import 'package:scanning_world/widgets/common/custom_progress_indicator.dart';

import '../data/remote/http/http_exception.dart';
import '../data/remote/models/auth.dart';
import '../data/remote/providers/auth_provider.dart';
import '../theme/theme.dart';
import '../widgets/auth/register_form_fields_1.dart';
import '../widgets/auth/register_form_fields_2.dart';
import '../widgets/common/error_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const String routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // handle register data
  final _formKey = GlobalKey<FormState>();
  final RegisterData registerData = RegisterData();

  //form step
  int step = 0;

  var _isLoading = false;

  // handle form submission
  void _nextStep() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => step = 1);
    }
  }

  //go to previous step
  void _previousStep() {
    setState(() => step = 0);
  }

  //register user
  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() => _isLoading = true);
        final response = await context.read<AuthProvider>().register(
              registerData,
            );
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
        title: Text(step == 0 ? 'Zarejestruj się 1/2' : "Zarejestruj się 2/2"),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Zarejestruj się krok ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 24),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                scale: animation, child: child);
                          },
                          child: Text(
                            '${step + 1}',
                            key: ValueKey<int>(step),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Stwórz konto, szukaj kodów QR i zdobywaj nogrody',
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return SizeTransition(
                              sizeFactor: animation, child: child);
                        },
                        child: step == 0
                            ? RegisterFormFields1(
                                registerData: registerData, nextStep: _nextStep)
                            : RegisterFormFields2(
                                registerData: registerData,
                              )),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: PlatformElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : step == 0
                                ? _nextStep
                                : _registerUser,
                        child: _isLoading
                            ? const CustomProgressIndicator()
                            : Text(
                                step == 0
                                    ? 'Zarejestruj się - krok 1/2'
                                    : 'Zarejestruj się',
                                style: const TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: step == 0
                          ? Container(
                              height: 50,
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Masz już konto? ",
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14)),
                                  PlatformTextButton(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/sign-in');
                                      //Navigator.pushReplacementNamed(context, '/register');
                                    },
                                    child: Text(
                                      'Zaloguj się',
                                      style: TextStyle(
                                          color: primary[600], fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.only(top: 4),
                              child: SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: PlatformTextButton(
                                  onPressed: _previousStep,
                                  child: const Text('Wróc do kroku 1'),
                                ),
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
