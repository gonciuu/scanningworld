import 'package:intl/intl.dart';
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

  String get formattedValidUntil {
    var formatter = DateFormat('HH:mm:ss');
    String formattedDate =
        formatter.format(validUntil.add(const Duration(hours: 2)));
    return formattedDate;
  }

  int get durationInSeconds => validUntil.difference(DateTime.now()).inSeconds;

  String timeLeft(int secondsLeft) {
    final timeLeft = Duration(seconds: secondsLeft);
    final min = timeLeft.inMinutes < 10
        ? '0${timeLeft.inMinutes}'
        : '${timeLeft.inMinutes}';

    final sec = (timeLeft.inSeconds % 60) < 10
        ? '0${timeLeft.inSeconds % 60}'
        : '${timeLeft.inSeconds % 60}';

    return "$min:$sec";
  }
}
