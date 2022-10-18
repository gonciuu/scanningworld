
import 'package:scanning_world/data/remote/models/user/region.dart';

class Place {
  final String id;
  final String name;
  final String imageUri;
  final String description;
  final Region region;
  final num points;
  final Location location;

  Place({
    required this.id,
    required this.name,
    required this.imageUri,
    required this.description,
    required this.region,
    required this.points,
    required this.location,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    id: json["_id"],
    name: json["name"],
    imageUri: json["imageUri"],
    description: json["description"],
    region: Region.fromJson(json["region"]),
    points: json["points"],
    location: Location.fromJson(json["location"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "imageUri": imageUri,
    "description": description,
    "region": region,
    "points": points,
    "location": location,
  };

  String get locationLatLng => '${location.lat.toStringAsFixed(3)},${location.lng.toStringAsFixed(3)}';
}

class Location {
  final num lat;
  final num lng;
  final String id;

  Location({
    required this.lat,
    required this.lng,
    required this.id,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"],
        lng: json["lng"],
        id: json["_id"],
      );


  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
        "_id": id,
      };
}

