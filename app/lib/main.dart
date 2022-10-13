import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:scanning_world/data/providers/scroll_provider.dart';
import './screens/forgot_password_screen.dart';
import './screens/wrappers/home_wrapper.dart';
import './theme/theme.dart';
import './screens/sign_in_screen.dart';
import './screens/register_screen.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarBrightness: Brightness.light, // For iOS: (dark icons)
    statusBarIconBrightness: Brightness.dark, // For Android: (dark icons)
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return PlatformApp(
      title: 'Flutter Demo',
      material: (_, __) => materialTheme,
      cupertino: (_, __) => cupertinoTheme,
      routes: {
        '/': (context) => const HomeWrapper(),
        SignInScreen.routeName: (context) => const SignInScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        ForgotPasswordScreen.routeName: (context) =>
             ForgotPasswordScreen(),
        HomeWrapper.routeName: (context) => const HomeWrapper(),
      },
      initialRoute: '/',
    );
  }
}
