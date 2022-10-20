import 'package:scanning_world/data/remote/models/user/place.dart';
import 'package:scanning_world/data/remote/models/user/region.dart';
import 'package:scanning_world/data/remote/models/auth/session.dart';

import '../coupon.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final Region region;
  final List<Place> scannedPlaces;
  final Map<String, int> points;
  final List<ActiveCoupon> activeCoupons;

  List<ActiveCoupon> get dateActiveCoupons => activeCoupons
      .where((x) => DateTime.now().compareTo(x.validUntil) < 0)
      .toList();

   num get scannedPlacesFromRegion {
     return scannedPlaces
         .where((x) => x.region.id == region.id)
         .length;
   }


  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.id,
    required this.region,
    required this.scannedPlaces,
    required this.points,
    required this.activeCoupons,
  });

  num get pointsInRegion => points[region.id] ?? 0;

  bool isPlaceScanned(String placeId) =>
      scannedPlaces.any((element) => element.id == placeId);

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        avatar: json["avatar"],
        points:
            json["points"] == null ? {} : Map<String, int>.from(json["points"]),
        region: Region.fromJson(json["region"]),
        scannedPlaces: List<Place>.from(
            json["scannedPlaces"].map((x) => Place.fromJson(x))),
        activeCoupons: List<ActiveCoupon>.from(
            json["activeCoupons"].map((x) => ActiveCoupon.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "image": avatar,
        "region": region.toJson(),
        "places": List<dynamic>.from(scannedPlaces.map((x) => x.toJson())),
        "points": Map<String, dynamic>.from(
            points.map((x, y) => MapEntry<String, dynamic>(x, y))),
        "activeCoupons":
            List<dynamic>.from(activeCoupons.map((x) => x.toJson())),
      };
}
