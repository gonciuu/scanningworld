import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/data/remote/providers/regions_provider.dart';
import 'package:scanning_world/widgets/common/platform_dropdown.dart';
import 'package:scanning_world/widgets/common/platform_input_group.dart';
import '../../data/remote/models/auth/auth.dart';
import '../../data/remote/models/user/region.dart';
import '../../utils/validators.dart';
import '../common/platfrom_input.dart';

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
  String get _regionId => widget.registerData.regionId;

  @override
  Widget build(BuildContext context) {
    final regions = context.watch<RegionsProvider>().regions.map((Region region) => DropdownItem(
        value: region.id,
        label: region.name)).toList();

    String regionName =
        regions.firstWhere((DropdownItem r) => r.value == _regionId).label;

    final Widget usernameField = PlatformInput(
      controller: TextEditingController(text: widget.registerData.name),
      validator: checkFieldIsEmpty,
      onChanged: (value) => widget.registerData.name = value,
      hintText: 'Nazwa użytkownika',
      prefixIcon: context.platformIcon(
          material: Icons.person_outline_rounded,
          cupertino: CupertinoIcons.person),
    );

    final Widget emailField = PlatformInput(
      controller: TextEditingController(text: widget.registerData.email),
      validator: checkEmail,
      onChanged: (value) => widget.registerData.email = value,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      hintText: 'Email',
      prefixIcon: context.platformIcon(
          material: Icons.alternate_email_outlined,
          cupertino: Icons.alternate_email_outlined),
    );



    return PlatformInputGroup(children: [
      usernameField,
      emailField,
      // Platform.isIOS ? cupertinoPicker : dropDownField,
      PlatformDropdown(
        icon: context.platformIcon(
            material: Icons.location_city_outlined,
            cupertino: CupertinoIcons.building_2_fill),
        value: DropdownItem(value: _regionId, label: regionName),
        items: regions,
        onChanged: (String? value) =>
            setState(() => widget.registerData.regionId = value!),
      ),
    ]);
  }
}
