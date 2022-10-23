import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../http/dio_client.dart';
import '../http/http_exception.dart';
import '../models/user/region.dart';


FutureOr<List<Region>> parseRegions(dynamic responseBody) {
  final parsed =responseBody as List;
  return parsed.map<Region>((json) => Region.fromJson(json)).toList();
}

class RegionsProvider with ChangeNotifier {
  List<Region> _regions = [];

  List<Region> get regions => _regions;


  Future<void> fetchRegions() async {
    try {
      final response = await DioClient.dio.get('/regions');
      final r =  await compute(parseRegions, response.data);
      _regions = r;
      notifyListeners();
    } on DioError catch (e) {
      throw HttpError.fromDioError(e);
    } catch (err) {
      throw HttpError(err.toString());
    }
  }


}
