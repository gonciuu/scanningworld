import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:latlong2/latlong.dart';
import 'package:scanning_world/screens/place_details_screen.dart';
import 'package:scanning_world/theme/theme.dart';
import 'package:scanning_world/widgets/common/white_wrapper.dart';
import '../../data/remote/models/user/place.dart';

class PlaceMapMarker extends Marker {
  final Place place;

  PlaceMapMarker(this.place)
      : super(
          anchorPos: AnchorPos.align(AnchorAlign.top),
          point: LatLng(
              place.location.lat.toDouble(), place.location.lng.toDouble()),
          builder: (context) =>
              Icon(context.platformIcons.locationSolid, size: 40,color:primary[700]),
        );
}

class PlaceMapMarkerPopup extends StatelessWidget {
  const PlaceMapMarkerPopup({Key? key, required this.place}) : super(key: key);
  final Place place;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        child: WhiteWrapper(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                place.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                place.locationLatLng,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
              const SizedBox(
                height: 6,
              ),
              SizedBox(
                width: double.infinity,
                child: PlatformElevatedButton(
                  cupertino: (_, __) => CupertinoElevatedButtonData(
                    color: primary[700],
                    minSize: 0,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                  material: (_, __) => MaterialElevatedButtonData(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primary[700]),
                      minimumSize: MaterialStateProperty.all(const Size(0, 0)),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 4)),
                    ),
                  ),
                  child: const Text(
                    'Szczegóły',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        PlaceDetailsScreen.routeName,
                        arguments: place.id);
                  },
                ),
              )
            ],
          ),
        ));
  }
}
