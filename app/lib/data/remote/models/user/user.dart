import 'package:scanning_world/data/remote/models/user/place.dart';
import 'package:scanning_world/data/remote/models/user/region.dart';
import 'package:scanning_world/data/remote/models/auth/session.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? image;
  final Region region;
  final List<Place> scannedPlaces;
  final Map<String, int> points;

  User({
    required this.name,
    required this.email,
    required this.phone,
    this.image,
    required this.id,
    required this.region,
    required this.scannedPlaces,
    required this.points,
  });

  num get pointsInRegion => points[region.id] ?? 0;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        image: json["image"],
        points:
            json["points"] == null ? {} : Map<String, int>.from(json["points"]),
        region: Region.fromJson(json["region"]),
        scannedPlaces: List<Place>.from(
            json["scannedPlaces"].map((x) => Place.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "image": image,
        "region": region.toJson(),
        "places": List<dynamic>.from(scannedPlaces.map((x) => x.toJson())),
        "points": Map<String, dynamic>.from(
            points.map((x, y) => MapEntry<String, dynamic>(x, y))),
      };
}
