import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/data/remote/http/http_exception.dart';
import 'package:scanning_world/data/remote/providers/auth_provider.dart';
import 'package:scanning_world/data/remote/providers/regions_provider.dart';
import 'package:scanning_world/screens/enter_pin_code_screen.dart';
import 'package:scanning_world/screens/sign_in_screen.dart';
import 'package:scanning_world/widgets/common/custom_progress_indicator.dart';

import '../../data/local/secure_storage_manager.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final SecureStorageManager _secureStorageManager = SecureStorageManager();

  @override
  void initState() {
    checkLocalSignIn();
    super.initState();
  }

  // Fetch regions from the server for registration
  Future<void> fetchRegions() async {
    try {
      final authProvider = context.read<RegionsProvider>();
      await authProvider.fetchRegions();
    } on HttpError catch (error) {
      debugPrint("ERROR: ${error.message}");
      //if it's server error try fetching again
      await fetchRegions();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void navigateToSignInScreen() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
  }

  void navigateToEnterPinCodeScreen() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(EnterPinCodeScreen.routeName);
  }

  //check if refresh token is valid and get new access token
  //if access token is valid then go to enter pin code screen/bio auth
  //if access token is not valid then go to sign in screen

  Future<void> checkLocalSignIn() async {
    final authProvider = context.read<AuthProvider>();
    authProvider.addAuthInterceptor();
    await _secureStorageManager.checkFirstSignIn();
    await fetchRegions();

    final refreshToken = await _secureStorageManager.getRefreshToken();
    final pinCode = await _secureStorageManager.getPinCode();
    if (refreshToken != null && pinCode != null) {
      try {
        await authProvider.refreshToken();
        return navigateToEnterPinCodeScreen();
      } catch (e) {
        navigateToSignInScreen();
      }
    } else {
      navigateToSignInScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/logo_svg.svg',
                width: 300,
                height: 300,
              ),
              const CustomProgressIndicator(),
            ],
          ),
        ));
  }
}
