import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/data/remote/http/dio_client.dart';
import 'package:scanning_world/data/remote/providers/regions_provider.dart';
import 'package:scanning_world/utils/extensions.dart';

import '../../data/remote/models/auth/auth.dart';
import '../../data/remote/models/user/region.dart';
import '../../theme/widgets_base_theme.dart';
import '../common/error_dialog.dart';

const double _kItemExtent = 32.0;

class RegisterFormFields2 extends StatefulWidget {
  const RegisterFormFields2({
    Key? key,
    required this.registerData,
  }) : super(key: key);

  final RegisterData registerData;

  @override
  State<RegisterFormFields2> createState() => _RegisterFormFields2State();
}

class _RegisterFormFields2State extends State<RegisterFormFields2> {
  // show city cupeertino picker
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }




  @override
  void initState() {
    if(widget.registerData.regionId.isEmpty) {
      widget.registerData.regionId = context.read<RegionsProvider>().regions.first.id;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final regions = context.watch<RegionsProvider>().regions;
    final Widget usernameField = PlatformTextFormField(
      controller: TextEditingController(text: widget.registerData.name),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'To pole nie może być puste';
        }
        return null;
      },
      onChanged: (value) {
        widget.registerData.name = value;
      },
      textInputAction: TextInputAction.next,
      cupertino: (_, __) => cupertinoTextFieldDecoration(
          placeholder: 'Nazwa użytkownika',
          prefix: const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 4),
            child: Icon(
              CupertinoIcons.person,
              color: Colors.black,
            ),
          )),
      material: (_, __) => MaterialTextFormFieldData(
        decoration: materialInputDecoration.copyWith(
          prefixIcon: const Icon(
            Icons.person_outline,
            color: Colors.black,
          ),
          hintText: 'Nazwa użytkownika',
        ),
      ),
    );

    final Widget emailField = PlatformTextFormField(
      controller: TextEditingController(text: widget.registerData.email),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'To pole nie może być puste';
        }
        if (!value.isValidEmail()) {
          return 'Niepoprawny adres email';
        }
        return null;
      },
      onChanged: (value) {
        widget.registerData.email = value;
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      cupertino: (_, __) => cupertinoTextFieldDecoration(
          placeholder: 'Email',
          prefix: const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 4),
            child: Icon(
              Icons.alternate_email_outlined,
              color: Colors.black,
            ),
          )),
      material: (_, __) => MaterialTextFormFieldData(
        decoration: materialInputDecoration.copyWith(
          prefixIcon: const Icon(
            Icons.alternate_email_outlined,
            color: Colors.black,
          ),
          hintText: 'Email',
        ),
      ),
    );

    // material dropdown city picker

    final dropDownField = DropdownButtonFormField<String>(
        borderRadius: BorderRadius.circular(10),
        decoration: materialInputDecoration.copyWith(
            contentPadding: const EdgeInsets.only(right: 12),
            prefixIcon: const Icon(
              Icons.location_city_outlined,
              color: Colors.black,
            )),
        value: widget.registerData.regionId,
        icon: const Padding(
          padding: EdgeInsets.only(top: 2.0),
          child: Icon(
            Icons.arrow_downward_sharp,
            color: Colors.black,
            size: 20,
          ),
        ),
        onChanged: (String? value) =>
            setState(() => widget.registerData.regionId = value!),
        items: regions.map<DropdownMenuItem<String>>((Region region) {
          return DropdownMenuItem<String>(
            value: region.id,
            child: Text(
              region.name,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
          );
        }).toList());

    // cupertino city picker
    final Widget cupertinoPicker = CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Icon(CupertinoIcons.building_2_fill, color: Colors.black),
          ),
          Expanded(
            child: Container(
              height: _kItemExtent,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: DefaultTextStyle(
                style: const TextStyle(
                  color: CupertinoColors.label,
                  fontSize: 16.0,
                ),
                child: Semantics(
                  inMutuallyExclusiveGroup: true,
                  selected: true,
                  child: Text(regions.firstWhere((x) => x.id == widget.registerData.regionId).name),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(
              CupertinoIcons.chevron_down,
              color: Colors.black,
              size: 20,
            ),
          ),
        ],
      ),
      onPressed: () => _showDialog(
        CupertinoPicker(
          scrollController: FixedExtentScrollController(
            initialItem: regions.indexOf(regions.firstWhere((x) => x.id == widget.registerData.regionId)),
          ),
          magnification: 1.22,
          squeeze: 1.2,
          useMagnifier: true,
          itemExtent: _kItemExtent,
          // This is called when selected item is changed.
          onSelectedItemChanged: (int selectedItem) {
            setState(
                () => widget.registerData.regionId = regions[selectedItem].id);
          },
          children: List<Widget>.generate(regions.length, (int index) {
            return Center(
              child: Text(
                regions[index].name,
                style: const TextStyle(color: Colors.black),
              ),
            );
          }),
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoFormSection.insetGrouped(
            margin: EdgeInsets.zero,
            children: [usernameField, emailField, cupertinoPicker])
        : Column(
            children: [
              usernameField,
              const SizedBox(height: 12),
              emailField,
              const SizedBox(height: 12),
              dropDownField
            ],
          );
  }
}
