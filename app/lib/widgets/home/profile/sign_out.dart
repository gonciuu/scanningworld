import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/widgets/common/error_dialog.dart';
import 'package:scanning_world/widgets/home/profile/settings_row.dart';

import '../../../data/remote/providers/auth_provider.dart';
import '../../../screens/sign_in_screen.dart';
import '../../common/custom_progress_indicator.dart';

class SignOut extends StatefulWidget {
  const SignOut({Key? key}) : super(key: key);

  @override
  State<SignOut> createState() => _SignOutState();
}

class _SignOutState extends State<SignOut> {
  var _isLoading = false;

  //show dialog to confirm sign out

  Future<void> _signOut() async {
    try {
      await context.read<AuthProvider>().signOut();
    } catch (e) {
      showPlatformDialog(
          context: context, builder: (c) => ErrorDialog(message: e.toString()));
    }
  }

  void _showLogoutDialog() {
    showPlatformDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (BuildContext context,
            StateSetter setState /*You can rename this!*/) {
          return PlatformAlertDialog(
            title: const Text('Wyloguj się'),
            content: const Text('Czy na pewno chcesz się wylogować?'),
            actions: <Widget>[
              PlatformDialogAction(
                  child: Text(
                    'Anuluj',
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                  onPressed: () => Navigator.of(context).pop()),
              PlatformDialogAction(
                  child: _isLoading
                      ? const CustomProgressIndicator()
                      : const Text('Wyloguj',
                          style: TextStyle(color: Colors.redAccent)),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await _signOut();
                    setState(() {
                      _isLoading = false;
                    });
                    if (!mounted) return;
                    Navigator.of(context)
                      ..pop()
                      ..pushNamedAndRemoveUntil(
                          SignInScreen.routeName, (route) => false);
                  }),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsRow(
      text: 'Wyloguj się',
      icon: context.platformIcon(
        material: Icons.logout_rounded,
        cupertino: CupertinoIcons.chevron_left_square,
      ),
      onTap: _showLogoutDialog,
      isRed: true,
      canGoNext: false,
    );
  }
}
