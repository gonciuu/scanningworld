import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/data/remote/http/http_exception.dart';
import 'package:scanning_world/data/remote/providers/auth_provider.dart';
import 'package:scanning_world/widgets/common/big_title.dart';
import 'package:scanning_world/widgets/common/custom_progress_indicator.dart';
import 'package:scanning_world/widgets/common/error_dialog.dart';

import '../../theme/theme.dart';

class ChangeAvatarScreen extends StatefulWidget {
  const ChangeAvatarScreen({Key? key}) : super(key: key);

  static const routeName = '/change-avatar';

  @override
  State<ChangeAvatarScreen> createState() => _ChangeAvatarScreenState();
}

class _ChangeAvatarScreenState extends State<ChangeAvatarScreen> {
  String _avatar = 'male2';
  var _isLoading = false;

  // change avatar
  Future<void> _changeAvatar() async {
    try {
      setState(() => _isLoading = true);
      final authProvider = context.read<AuthProvider>();
      await authProvider.changeAvatar(_avatar);
      if (!mounted) return;
      Navigator.of(context).pop();
    } on HttpError catch (e) {
      showPlatformDialog(
          context: context,
          builder: (c) => ErrorDialog(
                message: e.message,
              ));
    }finally{
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    //get user avatar from auth provider
    setState(() {
      _avatar = context.read<AuthProvider>().user!.avatar;
    });
    super.initState();
  }

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
                  _avatarImage('male2'),
                  const SizedBox(width: 20),
                  _avatarImage('male3'),
                  const SizedBox(width: 20),
                  _avatarImage('male1'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _avatarImage('female1'),
                  const SizedBox(width: 20),
                  _avatarImage('female2'),
                  const SizedBox(width: 20),
                  _avatarImage('female3'),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: PlatformElevatedButton(
                  onPressed: _isLoading ? null : _changeAvatar,
                  child: _isLoading
                      ? const CustomProgressIndicator()
                      : const Text('Zapisz avatar',style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ));
  }


  // avatar image (if selected with border)
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
              'assets/avatars/$name.png',
            )),
      ));
}
