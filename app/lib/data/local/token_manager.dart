


import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../config/app_config.dart';

class TokenManager{
  final storage = const FlutterSecureStorage();

  Future<void> saveRefreshToken(String refresh) async {
    await storage.write(key: API_REFRESH_TOKEN_STORAGE_KEY, value: refresh);
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: API_REFRESH_TOKEN_STORAGE_KEY);
  }

}