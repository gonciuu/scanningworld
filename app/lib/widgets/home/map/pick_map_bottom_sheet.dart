import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:map_launcher/map_launcher.dart' as MapLauncher;

class PickMapBottomSheet extends StatelessWidget {
  final List availableMaps;
  final String title;
  final double lat;
  final double lng;


  const PickMapBottomSheet({
    Key? key,
    required this.availableMaps,
    required this.title,
    required this.lat,
    required this.lng,
  }) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Wrap(
          children: <Widget>[
            Text(
              'Wybierz aplikację do nawigacji',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            for (var map in availableMaps)
              PlatformTextButton(
                onPressed: () => map.showMarker(
                  coords: MapLauncher.Coords(lat, lng),
                  title: title,
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      map.icon,
                      height: 30.0,
                      width: 30.0,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      map.mapName,
                      style: TextStyle(color: Colors.grey.shade800),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
