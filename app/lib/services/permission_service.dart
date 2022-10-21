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



}
