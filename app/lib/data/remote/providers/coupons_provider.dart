import 'package:dio/dio.dart';
import 'package:scanning_world/data/remote/http/dio_client.dart';
import 'package:scanning_world/data/remote/http/http_exception.dart';
import 'package:flutter/foundation.dart';
import '../models/coupon.dart';

class CouponsProvider with ChangeNotifier {
  final dio = DioClient.dio;

  List<Coupon> _coupons = [];

  List<Coupon> get coupons => [..._coupons];

  Future<List<Coupon>> getCoupons(String regionId) async {
    try {
      final response = await dio.get('/coupons/$regionId');
      final couponsList =
          (response.data as List).map((e) => Coupon.fromJson(e)).toList();
      _coupons = couponsList;
      notifyListeners();
      return couponsList;
    } on DioError catch (e) {
      throw HttpError.fromDioError(e);
    } catch (err) {
      throw HttpError(err.toString());
    }
  }

  Coupon? getCouponById(String id) {
    if (coupons.any((element) => element.id == id)) {
      return coupons.firstWhere((element) => element.id == id);
    } else {
      return null;
    }
  }

}
