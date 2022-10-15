


import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_config.dart';

class SecureStorageManager{
  final storage = const FlutterSecureStorage();


  // Check if this is the first time the user is using the app (include after reinstall)
  // If it is, then set the value to false and delete the secure storage data
  Future<void> checkFirstSignIn() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(IS_FIRST_LOG_IN_STORAGE_KEY) ?? true) {
      await storage.deleteAll();
      prefs.setBool(IS_FIRST_LOG_IN_STORAGE_KEY, false);
    }
  }


  // Save the refresh token in secure storage
  Future<void> saveRefreshToken(String refresh) async {
    await storage.write(key: API_REFRESH_TOKEN_STORAGE_KEY, value: refresh);
  }

  // Get the refresh token from secure storage
  Future<String?> getRefreshToken() async {
    return await storage.read(key: API_REFRESH_TOKEN_STORAGE_KEY);
  }

  // save the pin code in secure storage
  Future<void> savePinCode(String pinCode) async {
    await storage.write(key: USER_LOGIN_PIN_CODE_STORAGE_KEY, value: pinCode);
  }

  // Get the pin code from secure storage
  Future<String?> getPinCode() async {
    return await storage.read(key: USER_LOGIN_PIN_CODE_STORAGE_KEY);
  }


  // Delete pin code from secure storage
  Future<void> deletePinCode() async {
    await storage.delete(key: USER_LOGIN_PIN_CODE_STORAGE_KEY);
  }

  // Delete the refresh token from secure storage
  Future<void> deleteRefreshToken() async {
    await storage.delete(key: API_REFRESH_TOKEN_STORAGE_KEY);
  }


}