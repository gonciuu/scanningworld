import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../http/dio_client.dart';
import '../http/http_exception.dart';
import '../models/user/region.dart';

class RegionsProvider with ChangeNotifier {
  List<Region> _regions = [];

  List<Region> get regions => _regions;

  Future<void> fetchRegions() async {
    try {
      final response = await DioClient.dio.get('/regions');
      final regionsRes = response.data as List;
      _regions = regionsRes.map((e) => Region.fromJson(e)).toList();
      notifyListeners();
    } on DioError catch (e) {
      throw HttpError.fromDioError(e);
    } catch (err) {
      throw HttpError(err.toString());
    }
  }


}
