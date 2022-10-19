import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/data/remote/providers/places_provider.dart';
import 'package:map_launcher/map_launcher.dart' as MapLauncher;
import 'package:scanning_world/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/remote/models/user/place.dart';
import '../data/remote/providers/auth_provider.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final String placeId;

  const PlaceDetailsScreen({Key? key, required this.placeId}) : super(key: key);

  static const routeName = '/place-details';

  openMapsSheet(context, double lat, double lng, String title) async {
    try {
      final availableMaps = await MapLauncher.MapLauncher.installedMaps;

      showPlatformModalSheet(
        context: context,
        builder: (BuildContext context) {
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
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Place? place = context.watch<PlacesProvider>().getPlaceById(placeId);
    if (place != null) {
      return PlatformScaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Stack(
                children: [
                  FadeInImage.assetNetwork(
                      placeholder: 'assets/logo_scanningworld.png',
                      image:place.imageUri,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.4),
                  Positioned(
                    top: 50,
                    left: 20,
                    child: PlatformIconButton(
                      color: Colors.white30,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        context.platformIcons.back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  transform: Matrix4.translationValues(0.0, -24.0, 0.0),
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),

                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          Text(
                            place.locationLatLng,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade700),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Consumer<AuthProvider>(
                              builder: (context, authProvider, child) {
                            final bool isPlaceScanned =
                                authProvider.user?.isPlaceScanned(place.id) ??
                                    false;
                            return Row(
                              children: [
                                Icon(
                                    context.platformIcon(
                                        material: isPlaceScanned
                                            ? Icons.check_circle
                                            : Icons.dangerous,
                                        cupertino: isPlaceScanned
                                            ? CupertinoIcons
                                                .check_mark_circled_solid
                                            : CupertinoIcons
                                                .clear_thick_circled),
                                    size: 15,
                                    color: isPlaceScanned
                                        ? Colors.green
                                        : Colors.redAccent),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  isPlaceScanned
                                      ? 'Odwiedzone'
                                      : 'Nieodwiedzone',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: isPlaceScanned
                                          ? Colors.green
                                          : Colors.redAccent),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        place.description,
                        style: const TextStyle(fontSize: 15),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Expanded(
                        child: FlutterMap(
                          options: MapOptions(
                            center: LatLng(place.location.lat.toDouble(),
                                place.location.lng.toDouble()),
                            zoom: 14.0,
                            minZoom: 8.0,
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
                                          onTap: () => _launchUrl(
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
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: ['a', 'b', 'c'],
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(place.location.lat.toDouble(),
                                      place.location.lng.toDouble()),
                                  width: 80,
                                  height: 80,
                                  builder: (context) => Icon(
                                      context.platformIcons.locationSolid,
                                      size: 32,
                                      color: primary[700]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: PlatformElevatedButton(
                          child: const Text(
                            'Nawiguj',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            openMapsSheet(
                                context,
                                place.location.lat.toDouble(),
                                place.location.lng.toDouble(),
                                place.name);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ));
    }
    return const Center(child: CircularProgressIndicator());
  }
}
