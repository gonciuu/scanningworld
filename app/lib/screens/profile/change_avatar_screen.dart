import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:scanning_world/widgets/common/big_title.dart';

import '../../theme/theme.dart';

class ChangeAvatarScreen extends StatefulWidget {
  const ChangeAvatarScreen({Key? key}) : super(key: key);

  static const routeName = '/change-avatar';

  @override
  State<ChangeAvatarScreen> createState() => _ChangeAvatarScreenState();
}

class _ChangeAvatarScreenState extends State<ChangeAvatarScreen> {
  String? _avatar;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        appBar: PlatformAppBar(
          title: const Text('Zmień avatar'),
          cupertino: (_, __) => CupertinoNavigationBarData(
              transitionBetweenRoutes: false, previousPageTitle: 'Profil'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const BigTitle(text: 'Zmień avatar'),
              const Text('Wybierz nowy avatar'),
              const SizedBox(height: 20),
              Row(
                children: [
                  _avatarImage('assets/avatars/male2.png'),
                  const SizedBox(width: 20),
                  _avatarImage('assets/avatars/male3.png'),
                  const SizedBox(width: 20),
                  _avatarImage('assets/avatars/male1.png'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _avatarImage('assets/avatars/female1.png'),
                  const SizedBox(width: 20),
                  _avatarImage('assets/avatars/female2.png'),
                  const SizedBox(width: 20),
                  _avatarImage('assets/avatars/female3.png'),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: PlatformElevatedButton(
                  child: const Text(
                    'Zapisz',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ));
  }

  Widget _avatarImage(String name) => Expanded(
          child: GestureDetector(
        onTap: () => setState(() => _avatar = name),
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: _avatar == name ? primary[900]! : Colors.transparent,
                width: 5,
              ),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              name,
            )),
      ));
}
