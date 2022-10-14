import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/data/remote/http/http_exception.dart';
import 'package:scanning_world/data/remote/providers/auth_provider.dart';
import 'package:scanning_world/data/remote/providers/regions_provider.dart';
import 'package:scanning_world/screens/Home_screen.dart';
import 'package:scanning_world/screens/enter_pin_code_screen.dart';
import 'package:scanning_world/screens/sign_in_screen.dart';
import 'package:scanning_world/screens/wrappers/home_wrapper.dart';
import 'package:scanning_world/theme/theme.dart';
import 'package:scanning_world/widgets/common/custom_progress_indicator.dart';

import '../../data/local/secure_storage_manager.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import '../../widgets/common/error_dialog.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final SecureStorageManager secureStorageManager = SecureStorageManager();

  @override
  void initState() {
    checkLocalSignIn();

    super.initState();
  }

  Future<void> fetchRegions() async {
    try {
      final authProvider = context.read<RegionsProvider>();
      await authProvider.fetchRegions();
    } on HttpException catch (error) {
      showPlatformDialog(context: context, builder: (_) => ErrorDialog(message:error.message));
    }
  }

  Future<void> testDelete() async {
    //await secureStorageManager.deleteRefreshToken();
    // await secureStorageManager.deletePinCode();
  }

  Future<void> checkLocalSignIn() async {
    final authProvider = context.read<AuthProvider>();
    await testDelete();

    await fetchRegions();


    final refreshToken = await secureStorageManager.getRefreshToken();
    final pinCode = await secureStorageManager.getPinCode();
    if (refreshToken != null && pinCode != null) {
      //check if refresh token is valid and get new access token
      //if access token is valid then go to home screen
      //if access token is not valid then go to sign in screen
      try {
        final session = await authProvider.refreshToken();
        if (!mounted) return;
        Navigator.of(context)
            .pushReplacementNamed(EnterPinCodeScreen.routeName);
        return;
      } on HttpError catch (e) {
        //refresh token is not valid
        //go to sign in screen
        debugPrint(e.toString());
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
      }
    } else {
      //go to sign in screen
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
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
