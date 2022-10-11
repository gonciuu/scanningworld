import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:scanning_world/screens/register_screen_2.dart';
import './theme/theme.dart';
import './screens/sign_in_screen.dart';
import './screens/register_screen.dart';

void main() {
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
        '/': (context) => const SignInScreen(),
        SignInScreen.routeName: (context) => SignInScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        RegisterScreen2.routeName: (context) => RegisterScreen2(),
      },
      initialRoute: '/',
    );
  }
}
