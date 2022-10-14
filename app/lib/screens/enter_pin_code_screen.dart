import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/data/local/secure_storage_manager.dart';
import 'package:scanning_world/screens/Home_screen.dart';
import 'package:scanning_world/screens/wrappers/home_wrapper.dart';
import 'package:scanning_world/widgets/common/error_dialog.dart';

import '../data/remote/http/http_exception.dart';
import '../data/remote/providers/auth_provider.dart';
import '../theme/theme.dart';

class EnterPinCodeScreen extends StatefulWidget {
  static const routeName = '/enter-pin-code';

  const EnterPinCodeScreen({Key? key}) : super(key: key);

  @override
  State<EnterPinCodeScreen> createState() => _EnterPinCodeScreenState();
}

class _EnterPinCodeScreenState extends State<EnterPinCodeScreen> {
  final _key = GlobalKey<FormState>();
  final SecureStorageManager secureStorageManager = SecureStorageManager();
  final LocalAuthentication auth = LocalAuthentication();

  final TextEditingController _pinCodeController = TextEditingController();
  late FocusNode _pinCodeFocusNode;

  String? pinCode;

  Future<void> signInWithBiometric() async {
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();
      if (canAuthenticate) {
        final bool didAuthenticate = await auth.authenticate(
            localizedReason:
                'Zaloguj się za pomocą biometrii bez konieczności podawania kodu dostępu',
            options: const AuthenticationOptions(
                useErrorDialogs: false, biometricOnly: true, stickyAuth: true));

        if (didAuthenticate) {
          await _fetchUserData();
          // login successful
          if (!mounted) return;
          Navigator.of(context).pushReplacementNamed(HomeWrapper.routeName);
        } else {
          //biometric authentication failed
          //focus pin code text field
          _pinCodeFocusNode.requestFocus();
        }
      } else {
        _pinCodeFocusNode.requestFocus();
      }
    } on PlatformException catch (e) {
      _pinCodeFocusNode.requestFocus();
    } on HttpError catch (e) {
      showPlatformDialog(
          context: context,
          builder: (_) => ErrorDialog(message: "Error:  ${e.message}"));
    } catch (err) {
      showPlatformDialog(
          context: context,
          builder: (_) => ErrorDialog(message: err.toString()));
    }
  }

  Future<void> getPinCode() async {
    pinCode = await secureStorageManager.getPinCode();
  }

  Future<void> _fetchUserData() async {
    final authProvider = context.read<AuthProvider>();
    final response = await authProvider.getInfoAboutMe();
  }


  Future<void> onCompletePinCode(String pinCode) async {
    if (_key.currentState!.validate()) {
      await _fetchUserData();
      if(!mounted)return;
      Navigator.of(context)
          .pushReplacementNamed(HomeWrapper.routeName);
    }
  }

  @override
  void initState() {
    super.initState();
    _pinCodeFocusNode = FocusNode();
    getPinCode();
    signInWithBiometric();
  }

  @override
  void dispose() {
    _pinCodeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: primary[500]!),
      borderRadius: BorderRadius.circular(8),
    );

    return PlatformScaffold(
      backgroundColor: Colors.white,
      appBar: PlatformAppBar(
        title: const Text('Podaj PIN'),
      ),
      body: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 36,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Podaj PIN, aby się zalogować',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Pinput(
                      focusNode: _pinCodeFocusNode,
                      controller: _pinCodeController,
                      validator: (value) {
                        if (value != pinCode) {
                          _pinCodeController.setText('');
                          return 'Nieprawidłowy PIN';
                        }
                        return null;
                      },
                      obscureText: true,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      showCursor: true,
                      onCompleted: onCompletePinCode,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
