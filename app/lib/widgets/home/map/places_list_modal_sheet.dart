import 'package:flutter/material.dart';
import './place_item.dart';

import '../../../data/remote/models/user/place.dart';
class PlacesListModalSheet extends StatelessWidget {
  final List<Place> places;
  const PlacesListModalSheet({
    Key? key,
    required this.places,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
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
  }
}
