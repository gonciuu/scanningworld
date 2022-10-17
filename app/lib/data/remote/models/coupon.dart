

import 'package:scanning_world/data/remote/models/user/region.dart';

class Coupon{
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