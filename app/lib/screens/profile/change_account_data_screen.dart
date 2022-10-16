import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ChangeAccountDataScreen extends StatefulWidget {
  const ChangeAccountDataScreen({Key? key}) : super(key: key);

  static const routeName = '/change-account-data';
  @override
  State<ChangeAccountDataScreen> createState() => _ChangeAccountDataScreenState();
}

class _ChangeAccountDataScreenState extends State<ChangeAccountDataScreen> {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Edytuj profil'),
        cupertino: (_, __) => CupertinoNavigationBarData(
          transitionBetweenRoutes: false,
          heroTag: 'change_account_data_screen',
          previousPageTitle: 'Profil',
        ),
      ),
      body: const Center(
        child: Text('Change Account Data'),
      ),
    );
  }
}
