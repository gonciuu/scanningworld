import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:scanning_world/data/local/secure_storage_manager.dart';

import '../http/dio_client.dart';
import '../http/http_exception.dart';
import '../models/auth.dart';
import '../models/session.dart';
import '../models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  Future<Session> signIn(String phoneNumber, String password,String pinCode) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'phone': phoneNumber,
          'password': password,
        },
      );
      final session = Session.fromJson(response.data);
      await secureStorageManager.saveRefreshToken(session.refreshToken);
      await secureStorageManager.savePinCode(pinCode);
      _accessToken = session.accessToken;
      return session;
    } on DioError catch (e) {
      throw HttpError.fromDioError(e);
    } catch (err) {
      throw HttpError(err.toString());
    }
  }

  Future<Session> register(RegisterData registerData) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {
          "name": registerData.name,
          "email": registerData.email,
          "password": registerData.password,
          "phone": registerData.phone,
          "region": registerData.region,
        },
      );
      final session = Session.fromJson(response.data);
      await secureStorageManager.saveRefreshToken(session.refreshToken);
      await secureStorageManager.savePinCode(registerData.pinCode);
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
      debugPrint(response.data.toString());
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
