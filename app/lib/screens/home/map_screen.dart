import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/data/remote/providers/auth_provider.dart';
import 'package:scanning_world/theme/theme.dart';
import 'package:scanning_world/utils/extensions.dart';
import 'package:scanning_world/widgets/common/big_title.dart';
import 'package:scanning_world/widgets/common/custom_progress_indicator.dart';
import 'package:scanning_world/widgets/common/white_wrapper.dart';
import 'package:scanning_world/widgets/home/place_map_popup.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/remote/models/user/place.dart';
import '../../data/remote/providers/places_provider.dart';
import '../../widgets/home/place_item.dart';

class MapScreen extends StatefulWidget {
  final MapController mapController;

  const MapScreen({Key? key, required this.mapController}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  /// Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();

  var _showScannedPlaces = true;
  var _showUnscannedPlaces = true;

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  var _isLoading = true;

  List<Place> filterPlaces(List<Place> places) {
    final userScannedPlaces =
        context
            .read<AuthProvider>()
            .user
            ?.scannedPlaces
            .map((e) => e.id) ?? [];

    if (_showScannedPlaces) {
      if (_showUnscannedPlaces) {
        return places;
      } else {
        return places
            .where((element) => userScannedPlaces.contains(element.id))
            .toList();
      }
    } else {
      if (_showUnscannedPlaces) {
        return places
            .where((element) => !userScannedPlaces.contains(element.id))
            .toList();
      } else {
        return [];
      }
    }
  }

  void _showSettingsModalBottomSheet() {
    showPlatformModalSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (ctx, setModalState) =>
              Container(
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
                            value: _showScannedPlaces,
                            onChanged: (value) {
                              setModalState(() {
                                _showScannedPlaces = value;
                              });
                              setState(() {
                                _showScannedPlaces = value;
                              });
                            },
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
                            value: _showUnscannedPlaces,
                            activeColor: primary[700],
                            onChanged: (value) {
                              setModalState(() {
                                _showUnscannedPlaces = value;
                              });
                              setState(() {
                                _showUnscannedPlaces = value;
                              });
                            },
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          const Text('Nieodwiedzone'),
                        ],
                      ),
                    ],
                  )),
        );
      },
    );
  }

  void _showPlacesListModal() {
    final places = filterPlaces(context
        .read<PlacesProvider>()
        .places);
    showPlatformModalSheet(
        context: context,
        builder: (c) {
          return Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.6,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (c, i) {
                  return PlaceItem(
                    place: places[i],
                  );
                },
                itemCount: places.length,
                padding: const EdgeInsets.symmetric(vertical: 20)),
          );
        });
  }


  @override
  void dispose() {
    super.dispose();
  }

  final mc = MapController();

  @override
  void initState() {
    super.initState();
    context.read<PlacesProvider>().setControllers(mc, _popupLayerController);
    _getPlaces();
  }

  Future<void> _getPlaces() async {
    final regionId = context
        .read<AuthProvider>()
        .user!
        .region
        .id;
    final places = await context.read<PlacesProvider>().getPlaces(regionId);

    setState(() => _isLoading = false);
    // if (places.isNotEmpty) {
    //   _mapController.move(
    //       LatLng(places.first.location.lat.toDouble(),
    //           places.first.location.lng.toDouble()),
    //       13.0);
    // }
  }

  @override
  Widget build(BuildContext context) {
    final places = filterPlaces(context
        .watch<PlacesProvider>()
        .places);

    return PlatformScaffold(
      appBar: PlatformAppBar(
        trailingActions: places.isNotEmpty && !_isLoading
            ? [
          PlatformIconButton(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            cupertino: (_, __) => CupertinoIconButtonData(minSize: 0),
            icon: Icon(
              context.platformIcon(
                  material: Icons.filter_alt_outlined,
                  cupertino: CupertinoIcons.slider_horizontal_3),
              color: Colors.white,
              size: 28,
            ),
            onPressed: _showSettingsModalBottomSheet,
          ),
          PlatformIconButton(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            cupertino: (_, __) => CupertinoIconButtonData(minSize: 0),
            icon: Icon(
              context.platformIcon(
                  material: Icons.list,
                  cupertino: CupertinoIcons.square_list),
              color: Colors.white,
              size: 28,
            ),
            onPressed: _showPlacesListModal,
          ),
        ]
            : [],
        title: const Text('Mapa kodów QR'),
        cupertino: (_, __) =>
            CupertinoNavigationBarData(
              transitionBetweenRoutes: false,
              heroTag: 'rewards',
            ),
      ),
      body: _isLoading
          ? const Center(
        child: CustomProgressIndicator(),
      )
          : FlutterMap(
        mapController: mc,
        options: MapOptions(
          center: places.isEmpty
              ? null
              : LatLng(places.first.location.lat.toDouble() ?? 0,
              places.first.location.lng.toDouble() ?? 0),
          zoom: 16.0,
          minZoom: 8.0,
          onTap: (_, __) => _popupLayerController.hideAllPopups(),
        ),
        nonRotatedChildren: [
          AttributionWidget(
            attributionBuilder: (context) {
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
                        onTap: () =>
                            _launchUrl(
                                'https://www.openstreetmap.org/copyright'),
                        child: const Text(
                          ' © OpenStreetMap contributors',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ));
            },
          ),
        ],
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          PopupMarkerLayerWidget(
            options: PopupMarkerLayerOptions(
                popupController: _popupLayerController,
                markers: places.map((e) => PlaceMapMarker(e)).toList(),
                markerRotateAlignment:
                PopupMarkerLayerOptions.rotationAlignmentFor(
                    AnchorAlign.top),
                popupBuilder: (_, Marker marker) {
                  if (marker is PlaceMapMarker) {
                    return PlaceMapMarkerPopup(place: marker.place);
                  }
                  return const Card(child: Text('Not a monument'));
                }),
          ),
        ],
      ),
    );
  }
}
