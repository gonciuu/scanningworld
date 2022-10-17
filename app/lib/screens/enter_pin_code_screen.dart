import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/data/local/secure_storage_manager.dart';
import 'package:scanning_world/screens/wrappers/home_wrapper.dart';
import 'package:scanning_world/widgets/common/error_dialog.dart';
import '../data/remote/http/http_exception.dart';
import '../data/remote/providers/auth_provider.dart';
import '../data/remote/providers/coupons_provider.dart';
import '../theme/widgets_base_theme.dart';

class EnterPinCodeScreen extends StatefulWidget {
  static const routeName = '/enter-pin-code';

  const EnterPinCodeScreen({Key? key}) : super(key: key);

  @override
  State<EnterPinCodeScreen> createState() => _EnterPinCodeScreenState();
}

class _EnterPinCodeScreenState extends State<EnterPinCodeScreen> {
  //auth
  final SecureStorageManager _secureStorageManager = SecureStorageManager();
  final LocalAuthentication _auth = LocalAuthentication();
  String? _pinCode;

  //form
  final _key = GlobalKey<FormState>();
  final TextEditingController _pinCodeController = TextEditingController();
  final FocusNode _pinCodeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getPinCode();
    signInWithBiometric();
  }

  @override
  void dispose() {
    _pinCodeFocusNode.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }

  void navigateToHomeScreen() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(HomeWrapper.routeName);
  }

  //check if user can use biometric authentication and if he has it enabled in settings - if yes, scan biometric
  // else sign in with pin code
  Future<void> signInWithBiometric() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (canAuthenticate) {
        //sign in with biometric
        final bool didAuthenticate = await _auth.authenticate(
            localizedReason:
                'Zaloguj się za pomocą biometrii bez konieczności podawania kodu dostępu',
            options: const AuthenticationOptions(
                useErrorDialogs: false, biometricOnly: true, stickyAuth: true));

        if (didAuthenticate) {
          //biometric authentication successful
          await _fetchUserData();
          navigateToHomeScreen();
        } else {
          //biometric authentication failed
          //focus pin code text field
          _pinCodeFocusNode.requestFocus();
        }
      } else {
        // biometric not supported
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

  //get pin code from secure storage
  Future<void> getPinCode() async {
    _pinCode = await _secureStorageManager.getPinCode();
  }

  //fetch user data from server and coupons based on user region
  Future<void> _fetchUserData() async {
    final authProvider = context.read<AuthProvider>();
    final couponsProvider = context.read<CouponsProvider>();
    final user = await authProvider.getInfoAboutMe();
    await couponsProvider.getCoupons(user.region.id);
  }

  //sign in with pin code
  Future<void> onCompletePinCode(String pinCode) async {
    if (_key.currentState!.validate()) {
      await _fetchUserData();
      navigateToHomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        if (value != _pinCode) {
                          _pinCodeController.setText('');
                          _pinCodeFocusNode.requestFocus();
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
