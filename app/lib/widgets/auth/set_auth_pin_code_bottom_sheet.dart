import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:pinput/pinput.dart';
import '../../theme/theme.dart';

class SetAuthPinCodeBottomSheet extends StatefulWidget {
  final Function(String pinCode) onPinCodeSet;

  const SetAuthPinCodeBottomSheet({Key? key, required this.onPinCodeSet})
      : super(key: key);

  @override
  State<SetAuthPinCodeBottomSheet> createState() =>
      _SetAuthPinCodeBottomSheetState();
}

class _SetAuthPinCodeBottomSheetState extends State<SetAuthPinCodeBottomSheet> {
  final _key = GlobalKey<FormState>();

  final _pinCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: primary[500]!),
      borderRadius: BorderRadius.circular(8),
    );

    //debugPrint(widget.pinCode);
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
                  ),
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
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: PlatformElevatedButton(
                      child: const Text(
                        'Zapisz kod',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          widget.onPinCodeSet(_pinCodeController.text);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
