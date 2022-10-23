
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../theme/theme.dart';
import '../../common/big_title.dart';

class SetFiltersModalSheet extends StatelessWidget {
  final bool showScannedPlaces;
  final bool showUnscannedPlaces;
  final Function(bool) onShowScannedPlacesChanged;
  final Function(bool) onShowUnscannedPlacesChanged;


  const SetFiltersModalSheet({
    Key? key,
    required this.showScannedPlaces,
    required this.showUnscannedPlaces,
    required this.onShowScannedPlacesChanged,
    required this.onShowUnscannedPlacesChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              BigTitle(
                text: 'Filtry',
                style: TextStyle(color: primary[700]),
              ),
              const BigTitle(
                text: 'Pokaż punkty:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  PlatformSwitch(
                    value: showScannedPlaces,
                    onChanged: onShowScannedPlacesChanged,
                    activeColor: primary[700],
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  const Text('Odwiedzone'),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  PlatformSwitch(
                    value: showUnscannedPlaces,
                    activeColor: primary[700],
                    onChanged: onShowUnscannedPlacesChanged,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  const Text('Nieodwiedzone'),
                ],
              ),
            ],
          ),
    );
  }
}
