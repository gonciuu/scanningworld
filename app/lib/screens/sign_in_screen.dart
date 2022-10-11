import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:scanning_world/theme/theme.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/logo_scanningworld.png',
                      width: 150,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Zaloguj się',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 24)),
                    const SizedBox(height: 8),
                    Text(
                      'Zaloguj się na swoje konto, szukaj kodów QR i zdobywaj nogrody',
                      style: TextStyle(color: Colors.grey.shade600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),
                    FormBuilderField(
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                      ]),
                      name: 'phone',
                      builder: (field) {
                        return PlatformTextField(
                          keyboardType: TextInputType.phone,
                          cupertino: (_, __) => CupertinoTextFieldData(
                            cursorColor: primary[700],
                            placeholder: 'Nr. Telefonu',
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            prefix: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: Icon(
                                CupertinoIcons.phone,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          material: (_, __) => MaterialTextFieldData(
                            decoration:   InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Nr. Telefonu',
                              prefixIcon: const Icon(
                                Icons.phone_outlined,
                                color: Colors.black,
                              ),
                              border:OutlineInputBorder(
                                gapPadding: 0,
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
