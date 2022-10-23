import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:scanning_world/screens/place_details_screen.dart';

import '../../../data/remote/models/user/place.dart';
import '../../../data/remote/providers/auth_provider.dart';
import '../../common/cached_placeholder_image.dart';

class PlaceItem extends StatelessWidget {
  final Place place;

  const PlaceItem({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedPlaceholderImage(
                      imageUrl: place.imageUri,
                      height: 100,
                      width: 100,
                    ),
                  ),
                  Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                    final bool isPlaceScanned =
                        authProvider.user?.isPlaceScanned(place.id) ?? false;
                    return Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        transform: Matrix4.translationValues(5, -5, 0),
                        decoration: BoxDecoration(
                          color: isPlaceScanned ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                            context.platformIcon(
                                material: isPlaceScanned
                                    ? Icons.check_circle
                                    : Icons.dangerous,
                                cupertino: isPlaceScanned
                                    ? CupertinoIcons.check_mark_circled_solid
                                    : CupertinoIcons.clear_thick_circled),
                            size: 24,
                            color: Colors.white),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                        child: Text(
                      place.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
                    Text(
                      place.locationLatLng,
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade700),
                    ),
                    Text(
                      "${place.points} punktów",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    PlatformElevatedButton(
                      cupertino: (_, __) => CupertinoElevatedButtonData(
                        minSize: 0,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: const Text(
                        'Szczegóły',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            PlaceDetailsScreen.routeName,
                            arguments: place.id);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
