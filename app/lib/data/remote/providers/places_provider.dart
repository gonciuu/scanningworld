import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:scanning_world/data/remote/http/dio_client.dart';

import '../http/http_exception.dart';
import '../models/user/place.dart';

FutureOr<List<Place>> parsePlaces(dynamic responseBody) {
  final parsed =responseBody as List;
  return parsed.map<Place>((json) => Place.fromJson(json)).toList();
}

class PlacesProvider with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get places => [..._places];

  MapController? _mapController;

  MapController? get mapController => _mapController;


  void setControllers(MapController mc) {
    _mapController = mc;
  }

  final dio = DioClient.dio;

  Future<List<Place>> getPlaces(String regionId) async {
    try {
      final response = await dio.get('/places/$regionId');
      final placesRes = await compute(parsePlaces, response.data);
      _places = placesRes;
      notifyListeners();
      return placesRes;
    } on DioError catch (e) {
      throw HttpError.fromDioError(e);
    } catch (err) {
      throw HttpError(err.toString());
    }
  }

  //get place by id
  Place? getPlaceById(String id) {
    if (places.any((element) => element.id == id)) {
      return places.firstWhere((element) => element.id == id);
    } else {
      return null;
    }
  }
}
