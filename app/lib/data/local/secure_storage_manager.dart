


import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../config/app_config.dart';

class SecureStorageManager{
  final storage = const FlutterSecureStorage();

  Future<void> saveRefreshToken(String refresh) async {
    await storage.write(key: API_REFRESH_TOKEN_STORAGE_KEY, value: refresh);
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: API_REFRESH_TOKEN_STORAGE_KEY);
  }



  Future<void> savePinCode(String pinCode) async {
    await storage.write(key: USER_LOGIN_PIN_CODE, value: pinCode);
  }

  Future<String?> getPinCode() async {
    return await storage.read(key: USER_LOGIN_PIN_CODE);
  }

  Future<void> deletePinCode() async {
    await storage.delete(key: USER_LOGIN_PIN_CODE);
  }

  Future<void> deleteRefreshToken() async {
    await storage.delete(key: API_REFRESH_TOKEN_STORAGE_KEY);
  }


}