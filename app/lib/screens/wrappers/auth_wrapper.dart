import 'package:flutter/material.dart';
import 'package:scanning_world/screens/Home_screen.dart';
import 'package:scanning_world/screens/sign_in_screen.dart';
import 'package:scanning_world/screens/wrappers/home_wrapper.dart';
import 'package:scanning_world/widgets/common/custom_progress_indicator.dart';

import '../../data/local/token_manager.dart';

class AuthWrapper extends StatelessWidget {
   AuthWrapper({Key? key}) : super(key: key);

  final TokenManager tokenManager = TokenManager();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: tokenManager.getRefreshToken(),
      builder: (context, snapshot) {
        debugPrint(snapshot.connectionState.toString());
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            return HomeWrapper();
          } else {
            return SignInScreen();
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CustomProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
