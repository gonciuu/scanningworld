import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/data/remote/http/http_exception.dart';
import 'package:scanning_world/data/remote/providers/coupons_provider.dart';
import 'package:scanning_world/data/remote/providers/places_provider.dart';
import 'package:scanning_world/data/remote/providers/regions_provider.dart';
import 'package:scanning_world/utils/validators.dart';
import 'package:scanning_world/widgets/common/custom_progress_indicator.dart';
import 'package:scanning_world/widgets/common/platform_dropdown.dart';
import 'package:scanning_world/widgets/common/success_dialog.dart';
import '../../data/remote/models/user/region.dart';
import '../../data/remote/providers/auth_provider.dart';
import '../../theme/theme.dart';
import '../../widgets/common/error_dialog.dart';
import '../../widgets/common/platform_input_group.dart';
import '../../widgets/common/platfrom_input.dart';

class ChangeAccountDataScreen extends StatefulWidget {
  const ChangeAccountDataScreen({Key? key}) : super(key: key);

  static const routeName = '/change-account-data';

  @override
  State<ChangeAccountDataScreen> createState() =>
      _ChangeAccountDataScreenState();
}

class ChangeAccountData {
  String username = '';
  String email = '';
  Region region = Region(id: '', name: '');
}

class _ChangeAccountDataScreenState extends State<ChangeAccountDataScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ChangeAccountData _changeAccountDataData = ChangeAccountData();

  //is loading after save
  var _isLoading = false;

  // save form - fetch new places and coupons from region
  Future<void> _saveForm() async {
    final AuthProvider authProvider = context.read<AuthProvider>();
    final CouponsProvider couponsProvider = context.read<CouponsProvider>();
    final PlacesProvider placesProvider = context.read<PlacesProvider>();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);
      try {
        await authProvider.changeUserInfo(_changeAccountDataData);
        // fetch new places and coupons from region
        await couponsProvider.getCoupons(_changeAccountDataData.region.id);
        final places =
            await placesProvider.getPlaces(_changeAccountDataData.region.id);

        // set center of the map
        if (places.isNotEmpty) {
          placesProvider.mapController?.move(
              LatLng(places.first.location.lat.toDouble(),
                  places.first.location.lng.toDouble()),
              13);
        } else {
          placesProvider.mapController?.move(LatLng(52.237049, 21.017532), 13);
        }
        showPlatformDialog(
            context: context,
            builder: (_) => SuccessDialog(
                content: 'Dane zostały zmienione',
                onButtonPressed: () => Navigator.of(context).pop()));
      } on HttpError catch (e) {
        showPlatformDialog(
            context: context, builder: (_) => ErrorDialog(message: e.message));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;

    //set initial values
    if (user != null) {
      _changeAccountDataData.username = user.name;
      _changeAccountDataData.email = user.email;
      _changeAccountDataData.region = user.region;
    }
  }

  @override
  Widget build(BuildContext context) {
    final usernameInput = PlatformInput(
      onChanged: (value) => _changeAccountDataData.username = value,
      controller: TextEditingController(text: _changeAccountDataData.username),
      validator: checkFieldIsEmpty,
      hintText: 'Nazwa użytkownika',
      prefixIcon: context.platformIcon(
          material: Icons.person_outline_rounded,
          cupertino: CupertinoIcons.person),
    );

    final emailInput = PlatformInput(
      onChanged: (value) => _changeAccountDataData.email = value,
      controller: TextEditingController(text: _changeAccountDataData.email),
      validator: checkEmail,
      hintText: 'Email',
      prefixIcon: context.platformIcon(
          material: Icons.alternate_email_outlined,
          cupertino: Icons.alternate_email_outlined),
    );

    const labelStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Edytuj profil'),
        cupertino: (_, __) => CupertinoNavigationBarData(
          transitionBetweenRoutes: false,
          heroTag: 'change_account_data_screen',
          previousPageTitle: 'Profil',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nazwa użytkownika',
                style: labelStyle,
              ),
              const SizedBox(height: 4),
              PlatformInputGroup(
                children: [
                  usernameInput,
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Email',
                style: labelStyle,
              ),
              const SizedBox(height: 4),
              PlatformInputGroup(
                children: [
                  emailInput,
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Gmina/Miasto',
                style: labelStyle,
              ),
              const SizedBox(height: 4),
              Consumer<RegionsProvider>(
                  builder: (context, placesProvider, child) {
                final regions = placesProvider.regions
                    .map((e) => DropdownItem(value: e.id, label: e.name))
                    .toList();
                return PlatformInputGroup(
                  children: [
                    PlatformDropdown(
                      items: regions,
                      value: _changeAccountDataData.region.id.isEmpty
                          ? regions.first
                          : regions.firstWhere((element) =>
                              element.value ==
                              _changeAccountDataData.region.id),
                      onChanged: (value) {
                        setState(() {
                          final region = regions
                              .firstWhere((element) => element.value == value);
                          _changeAccountDataData.region =
                              Region(id: region.value, name: region.label);
                        });
                      },
                      icon: context.platformIcon(
                          material: Icons.location_city_outlined,
                          cupertino: CupertinoIcons.building_2_fill),
                    ),
                  ],
                );
              }),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: PlatformElevatedButton(
                    onPressed: _isLoading ? null : _saveForm,
                    child: _isLoading
                        ? const CustomProgressIndicator()
                        : const Text('Zapisz',
                            style: TextStyle(color: Colors.white))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
