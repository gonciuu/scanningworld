import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:latlong2/latlong.dart';
import 'package:scanning_world/widgets/common/white_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}



class _MapScreenState extends State<MapScreen> {
  late final List<Marker> _markers;

  /// Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    _markers = [
      LatLng(49.785868, 18.203585),
      LatLng(49.885868, 18.303585),
      LatLng(49.985868, 18.403585),
    ]
        .map(
          (markerPosition) => Marker(
        point: markerPosition,
        width: 40,
        height: 40,
        builder: (_) => const Icon(Icons.location_on, size: 40),
        anchorPos: AnchorPos.align(AnchorAlign.top),
      ),
    )
        .toList();
  }
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Mapa'),
        cupertino: (_, __) => CupertinoNavigationBarData(
          transitionBetweenRoutes: false,
          heroTag: 'rewards',
        ),
      ),
      body: FlutterMap(
            options: MapOptions(
              center: LatLng(49.985868, 18.403585),
              zoom: 14.0,
              minZoom: 8.0,
              maxZoom: 18.0,
              onTap: (_, __) => _popupLayerController
                  .hideAllPopups(), // Hide popup when the map is tapped.
            ),
            nonRotatedChildren: [
              AttributionWidget(attributionBuilder: (context) {
                return Container(
                  padding: const EdgeInsets.all(2),
                  color: Colors.white60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'flutter_map | ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _launchUrl('https://www.openstreetmap.org/copyright'),
                        child: const Text(
                          ' © OpenStreetMap contributors',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  )
                );
              },),

            ],
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              PopupMarkerLayerWidget(
                options: PopupMarkerLayerOptions(
                  popupController: _popupLayerController,
                  markers: _markers,
                  markerRotateAlignment:
                  PopupMarkerLayerOptions.rotationAlignmentFor(AnchorAlign.top),
                  popupBuilder: (BuildContext context, Marker marker) =>
                      SizedBox(width:30,child: WhiteWrapper(child: Text('HUj'),)),
                ),
              ),
            ],
          ),
    );
  }
}
