import 'package:scanning_world/data/remote/models/user/region.dart';

class Coupon {
  final String id;
  final String name;
  final String imageUri;
  final num points;
  final Region region;

  Coupon({
    required this.id,
    required this.name,
    required this.imageUri,
    required this.points,
    required this.region,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id: json["_id"],
        name: json["name"],
        imageUri: json["imageUri"],
        points: json["points"],
        region: Region.fromJson(json["region"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "imageUri": imageUri,
        "points": points,
        "region": region.toJson(),
      };
}

class ActiveCoupon {
  final Coupon coupon;
  final DateTime validUntil;
  final String id;

  ActiveCoupon({
    required this.coupon,
    required this.validUntil,
    required this.id,
  });

  factory ActiveCoupon.fromJson(Map<String, dynamic> json) => ActiveCoupon(
        coupon: Coupon.fromJson(json["coupon"]),
        validUntil: DateTime.parse(json["validUntil"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "coupon": coupon.toJson(),
        "validUntil": validUntil.toIso8601String(),
        "_id": id
  };


  int get durationInSeconds => validUntil.difference(DateTime.now()).inSeconds;

  String get timeLeft {
    Duration difference = validUntil.difference(DateTime.now());
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;

    String min = minutes < 10 ? "0$minutes" : "$minutes";
    String sec = seconds < 10 ? "0$seconds" : "$seconds";

    return "$min:$sec";
  }
}
