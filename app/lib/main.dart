import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:scanning_world/data/remote/providers/coupons_provider.dart';
import 'package:scanning_world/data/remote/providers/places_provider.dart';
import 'package:scanning_world/data/remote/providers/regions_provider.dart';
import 'package:scanning_world/screens/order_coupon_screen.dart';
import 'package:scanning_world/screens/place_details_screen.dart';
import 'package:scanning_world/screens/profile/change_account_data_screen.dart';
import 'package:scanning_world/screens/profile/change_password_screen.dart';
import 'package:scanning_world/screens/scan_qr_code_screen.dart';
import 'data/remote/providers/auth_provider.dart';
import 'screens/wrappers/auth_wrapper.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/wrappers/home_wrapper.dart';
import 'theme/theme.dart';
import 'screens/sign_in_screen.dart';
import 'screens/register_screen.dart';
import 'package:provider/provider.dart';

import 'screens/enter_pin_code_screen.dart';
import 'screens/home/home_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarBrightness: Brightness.light, // For iOS: (dark icons)
    statusBarIconBrightness: Brightness.dark, // For Android: (dark icons)
  ));
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RegionsProvider()),
        ChangeNotifierProvider(create: (_) => CouponsProvider()),
        ChangeNotifierProvider(create: (_) => PlacesProvider()),
      ],
      child: PlatformApp(
        localizationsDelegates: const <LocalizationsDelegate>[
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
        ],
        title: 'Scanning World',
        debugShowCheckedModeBanner: false,
        material: (_, __) => materialTheme,
        cupertino: (_, __) => cupertinoTheme,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          var routes = <String, WidgetBuilder>{
            '/': (context) => const AuthWrapper(),
            SignInScreen.routeName: (context) => const SignInScreen(),
            RegisterScreen.routeName: (context) => const RegisterScreen(),
            ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
            HomeWrapper.routeName: (context) => const HomeWrapper(),
            EnterPinCodeScreen.routeName: (context) =>
                const EnterPinCodeScreen(),
            ChangePasswordScreen.routeName: (context) =>
                const ChangePasswordScreen(),
            ChangeAccountDataScreen.routeName: (context) =>
                const ChangeAccountDataScreen(),
            ScanQrCodeScreen.routeName: (context) => const ScanQrCodeScreen(),
            OrderCouponScreen.routeName: (ctx) =>
                OrderCouponScreen(arguments: settings.arguments),
            PlaceDetailsScreen.routeName: (ctx) => PlaceDetailsScreen(placeId: settings.arguments as String,),
          };
          WidgetBuilder builder = routes[settings.name] ?? routes['/']!;
          return MaterialPageRoute(builder: (ctx) => builder(ctx));
        },
      ),
    );
  }
}
