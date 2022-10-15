import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:pinput/pinput.dart';
import '../../theme/widgets_base_theme.dart';

class SetAuthPinCodeBottomSheet extends StatefulWidget {
  final Function(String pinCode) onPinCodeSet;

  const SetAuthPinCodeBottomSheet({Key? key, required this.onPinCodeSet})
      : super(key: key);

  @override
  State<SetAuthPinCodeBottomSheet> createState() =>
      _SetAuthPinCodeBottomSheetState();
}

class _SetAuthPinCodeBottomSheetState extends State<SetAuthPinCodeBottomSheet> {
  // handle pin code form
  final _key = GlobalKey<FormState>();
  final _pinCodeController = TextEditingController();
  late final FocusNode _pinCodeFocusNode;
  late final FocusNode _pinConfirmCodeFocusNode;

  @override
  void initState() {
    super.initState();
    _pinCodeFocusNode = FocusNode();
    _pinCodeFocusNode.requestFocus();
    _pinConfirmCodeFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _pinCodeFocusNode.dispose();
    _pinConfirmCodeFocusNode.dispose();
    super.dispose();
  }

  // check if pin code confirm is valid
  void _checkPinCode() {
    if (_key.currentState!.validate()) {
      widget.onPinCodeSet(_pinCodeController.text);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _key,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Material(
            color: Colors.white,
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(
                minHeight: 300,
                maxHeight: 450,
              ),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Nadaj swój unikalny kod dostępu do aplikacji',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Pinput(
                      focusNode: _pinCodeFocusNode,
                      controller: _pinCodeController,
                      obscureText: true,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      showCursor: true,
                      validator: (value) {
                        if (value!.length < 4) {
                          return 'Kod musi mieć 4 cyfry';
                        }
                        return null;
                      },
                      onCompleted: (value) {
                        _pinCodeFocusNode.unfocus();
                        Future.delayed(const Duration(milliseconds: 1), () {
                          _pinConfirmCodeFocusNode.requestFocus();
                        });
                      }),
                  const SizedBox(height: 24),
                  const Text(
                    'Powtórz kod dostępu',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Pinput(
                    focusNode: _pinConfirmCodeFocusNode,
                    validator: (pin) {
                      if (pin != _pinCodeController.text) {
                        return 'Kody nie są identyczne';
                      }
                      return null;
                    },
                    obscureText: true,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    showCursor: true,
                    onCompleted: (value) {
                      _checkPinCode();
                    },
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: PlatformElevatedButton(
                      onPressed: _checkPinCode,
                      child: const Text(
                        'Zapisz kod',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
