import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/data/remote/providers/auth_provider.dart';
import 'package:scanning_world/screens/profile/change_avatar_screen.dart';
import 'package:scanning_world/theme/theme.dart';
import 'package:scanning_world/widgets/common/small_subtitle.dart';
import 'package:scanning_world/widgets/home/profile/settings_row.dart';
import 'package:scanning_world/widgets/home/profile/sign_out.dart';

import '../../widgets/common/big_title.dart';
import '../profile/change_account_data_screen.dart';
import '../profile/change_password_screen.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({Key? key})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final points = context.select(
            (AuthProvider auth) => auth.user?.points[auth.user?.region.id]) ??
        0;
    final String? avatar =
        context.select((AuthProvider auth) => auth.user?.avatar);
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(),
                  const BigTitle(text: 'Profil'),
                  const SmallSubtitle(text: 'Edytuj profil'),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed(ChangeAvatarScreen.routeName),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: AssetImage(avatar != null
                              ? 'assets/avatars/$avatar.png'
                              : 'assets/avatars/male2.png'),
                        ),
                        Positioned(
                          bottom: 1,
                          right: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primary[600],
                            ),
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                                context.platformIcon(
                                  material: Icons.edit,
                                  cupertino: CupertinoIcons.pencil,
                                ),
                                color: Colors.white,
                                size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 24),
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: primary[600]),
                    child: Text('Saldo: $points punkty',
                        style: DefaultTextStyle.of(context).style.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 32),
                  SettingsRow(
                    text: 'Edytuj profil',
                    icon: context.platformIcon(
                      material: Icons.settings_outlined,
                      cupertino: CupertinoIcons.settings,
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          ChangeAccountDataScreen.routeName);
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SettingsRow(
                    text: 'Zmień hasło',
                    icon: context.platformIcon(
                      material: Icons.lock_outline,
                      cupertino: CupertinoIcons.lock_shield,
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(ChangePasswordScreen.routeName);
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const SignOut()
                ]),
          ),
        ));
  }
}
