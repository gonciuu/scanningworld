import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/data/remote/http/http_exception.dart';
import 'package:scanning_world/widgets/common/custom_progress_indicator.dart';
import 'package:scanning_world/widgets/common/error_dialog.dart';
import 'package:scanning_world/widgets/common/platform_input_group.dart';

import '../../data/remote/providers/auth_provider.dart';
import '../../theme/theme.dart';
import '../../utils/validators.dart';
import '../../widgets/common/platfrom_input.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  static const String routeName = '/change_password';

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class ChangePasswordData {
  String oldPassword = '';
  String newPassword = '';
  String newPasswordRepeat = '';
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ChangePasswordData _changePasswordData = ChangePasswordData();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _isLoading = false;

  Future<void> _submitForm() async {
    final authProvider = context.read<AuthProvider>();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);
      try {
        await authProvider.changePassword(
          _changePasswordData.oldPassword,
          _changePasswordData.newPassword,
        );
        showPlatformDialog(
            context: context,
            builder: (_) => PlatformAlertDialog(
                  title: const Text('Sukces'),
                  content: const Text('Hasło zostało zmienione'),
                  actions: [
                    PlatformDialogAction(
                      child:  Text('Ok',
                          style: TextStyle(color: primary[700])),
                      onPressed: () => Navigator.of(context)
                        ..pop()
                        ..pop(),
                    ),
                  ],
                ));
      } on HttpError catch (e) {
        showPlatformDialog(
            context: context, builder: (_) => ErrorDialog(message: e.message));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget oldPasswordField = PlatformInput(
      onChanged: (value) => _changePasswordData.oldPassword = value,
      validator: checkFieldIsEmpty,
      prefixIcon: context.platformIcon(
          material: Icons.lock_open_rounded,
          cupertino: CupertinoIcons.lock_open),
      obscureText: true,
      hintText: 'Stare hasło',
    );

    final Widget newPasswordField = PlatformInput(
      onChanged: (value) => _changePasswordData.newPassword = value,
      validator: checkPassword,
      obscureText: true,
      hintText: 'Nowe hasło',
      prefixIcon: context.platformIcon(
          material: Icons.lock_outline_rounded, cupertino: CupertinoIcons.lock),
    );

    final Widget confirmNewPasswordField = PlatformInput(
      onChanged: (value) => _changePasswordData.newPasswordRepeat = value,
      validator: (value) =>
          checkConfirmPassword(_changePasswordData.newPassword, value),
      obscureText: true,
      textInputAction: TextInputAction.done,
      hintText: 'Powtórz nowe hasło',
      prefixIcon: context.platformIcon(
          material: Icons.lock_outline_rounded, cupertino: CupertinoIcons.lock),
      onFieldSubmitted: (_) => _submitForm(),
    );

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Zmień hasło'),
        cupertino: (_, __) => CupertinoNavigationBarData(
          transitionBetweenRoutes: false,
          heroTag: 'change_password',
          previousPageTitle: 'Profil',
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlatformInputGroup(
                cupertinoHeader: Text("Zmień hasło"),
                children: [
                  oldPasswordField,
                  newPasswordField,
                  confirmNewPasswordField,
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: PlatformElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CustomProgressIndicator()
                      : const Text(
                          'Zapisz zmiany',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
