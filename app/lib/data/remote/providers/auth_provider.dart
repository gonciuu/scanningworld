import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:scanning_world/data/local/secure_storage_manager.dart';
import 'package:scanning_world/data/remote/models/auth/auth_result.dart';

import '../http/dio_client.dart';
import '../http/http_exception.dart';
import '../models/auth/auth.dart';
import '../models/auth/session.dart';

import '../models/user/user.dart';

class AuthProvider with ChangeNotifier {
  final dio = DioClient.dio;
  final SecureStorageManager secureStorageManager = SecureStorageManager();

  User? _user;

  User? get user => _user;

  String? _accessToken;

  String? get accessToken => _accessToken;

  Future<User> getInfoAboutMe() async {
    try {
      final response = await dio.get('/users/me',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      final resUser = User.fromJson(response.data);
      _user = resUser;
      notifyListeners();
      return resUser;
    } on DioError catch (e) {
      debugPrint(e.toString());
      throw HttpError.fromDioError(e);
    }
  }

  Future<AuthResult> signIn(
      String phoneNumber, String password, String pinCode) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'phone': phoneNumber,
          'password': password,
        },
      );
      final authResult = AuthResult.fromJson(response.data);
      final resultSession = authResult.session;

      await secureStorageManager.saveRefreshToken(resultSession.refreshToken);
      await secureStorageManager.savePinCode(pinCode);
      _accessToken = resultSession.accessToken;
      _user = authResult.user;
      notifyListeners();
      return authResult;
    } on DioError catch (e) {
      throw HttpError.fromDioError(e);
    } catch (err) {
      throw HttpError(err.toString());
    }
  }

  Future<AuthResult> register(RegisterData registerData) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {
          "name": registerData.name,
          "email": registerData.email,
          "password": registerData.password,
          "phone": registerData.phone,
          "regionId": registerData.regionId,
        },
      );
      final authResult = AuthResult.fromJson(response.data);
      final resultSession = authResult.session;
      await secureStorageManager.saveRefreshToken(resultSession.refreshToken);
      await secureStorageManager.savePinCode(registerData.pinCode);
      _accessToken = resultSession.accessToken;
      _user = authResult.user;
      notifyListeners();
      return authResult;
    } on DioError catch (e) {
      debugPrint("HUJ2${e.toString()}");
      throw HttpError.fromDioError(e);
    } catch (err) {
      debugPrint("HUJ${err.toString()}");
      throw HttpError(err.toString());
    }
  }

  Future<Session> refreshToken() async {
    try {
      final currentRefreshToken = await secureStorageManager.getRefreshToken();

      final response = await dio.get(
        '/auth/refresh',
        options: Options(
          headers: {
            'Authorization': 'Bearer $currentRefreshToken',
          },
        ),
      );
      final session = Session.fromJson(response.data);
      await secureStorageManager.saveRefreshToken(session.refreshToken);
      _accessToken = session.accessToken;
      return session;
    } on DioError catch (e) {
      debugPrint(e.toString());
      throw HttpError.fromDioError(e);
    } catch (err) {
      debugPrint(err.toString());
      throw HttpError(err.toString());
    }
  }
}
