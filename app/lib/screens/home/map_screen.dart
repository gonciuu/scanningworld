import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/data/remote/providers/auth_provider.dart';
import 'package:scanning_world/services/url_service.dart';
import 'package:scanning_world/widgets/common/custom_progress_indicator.dart';
import 'package:scanning_world/widgets/home/map/place_map_popup.dart';
import 'package:scanning_world/widgets/home/map/places_list_modal_sheet.dart';
import 'package:scanning_world/widgets/home/map/set_filter_modal_sheet.dart';
import '../../data/remote/models/user/place.dart';
import '../../data/remote/providers/places_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  final mc = MapController();

  @override
  void initState() {
    super.initState();
    context.read<PlacesProvider>().setControllers(mc);
    _getPlaces();
  }


  /// Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();

  // Used to trigger showing/hiding of markers.
  var _showScannedPlaces = true;
  var _showUnscannedPlaces = true;

  // is loadng?
  var _isLoading = true;

  // filter places by showScannedPlaces and showUnscannedPlaces
  List<Place> filterPlaces(List<Place> places) {
    final userScannedPlaces =
        context.read<AuthProvider>().user?.scannedPlaces.map((e) => e.id) ?? [];

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

  // set filters modal bottom sheet
  void _showSettingsModalBottomSheet() {
    showPlatformModalSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (ctx, setModalState) {
          return SetFiltersModalSheet(
            showScannedPlaces: _showScannedPlaces,
            showUnscannedPlaces: _showUnscannedPlaces,
            onShowScannedPlacesChanged: (value) {
              setModalState(() {
                _showScannedPlaces = value;
              });
              setState(() {
                _showScannedPlaces = value;
              });
            },
            onShowUnscannedPlacesChanged: (value) {
              setModalState(() {
                _showUnscannedPlaces = value;
              });
              setState(() {
                _showUnscannedPlaces = value;
              });
            },
          );
        });
      },
    );
  }

  // show places on click list icon on top appbar
  void _showPlacesListModal() {
    final places = filterPlaces(context.read<PlacesProvider>().places);
    showPlatformModalSheet(
        context: context,
        builder: (c) {
          return PlacesListModalSheet(places: places);
        });
  }





  // get places from server for region
  Future<void> _getPlaces() async {
    final regionId = context.read<AuthProvider>().user!.region.id;
    await context.read<PlacesProvider>().getPlaces(regionId);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final places = filterPlaces(context.watch<PlacesProvider>().places);
    _popupLayerController.hideAllPopups();

    return PlatformScaffold(
      appBar: PlatformAppBar(
        trailingActions: !_isLoading
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
        cupertino: (_, __) => CupertinoNavigationBarData(
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
                    ? LatLng(52.237049, 21.017532)
                    : LatLng(places.first.location.lat.toDouble(),
                        places.first.location.lng.toDouble()),
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
                              onTap: () => UrlService.launchLink(
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
