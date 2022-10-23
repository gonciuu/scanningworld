import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // Check permissions for user localisation and camera for scan QR code
  static Future<Map<Permission, PermissionStatus>>
      checkInitPermissions() async {
    return await [
      Permission.location,
      Permission.camera,
    ].request();
  }

  static Future<void> checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const PermissionDeniedException(
          'Serwis lokalizacji jest wyłączony. Włącz go w ustawiniach swojego telefonu.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const PermissionDeniedException('Brak uprawnień do lokalizacji.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const PermissionDeniedException(
          'Upraewnienia do lokalizacji są zablokowane. Zmień to w ustawieniach aplikacji.');
    }
  }
}
