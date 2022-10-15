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

  // user and access token needed for requests
  User? _user;

  User? get user => _user;

  String? _accessToken;

  String? get accessToken => _accessToken;

  // get user info after refresh token
  Future<User> getInfoAboutMe() async {
    try {
      final response = await dio.get('/users/me',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      final resUser = User.fromJson(response.data);
      _user = resUser;
      notifyListeners();
      return resUser;
    } on DioError catch (e) {
      throw HttpError.fromDioError(e);
    } catch (err) {
      throw HttpError(err.toString());
    }
  }

  // sign in
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
      //map response to AuthResult
      final authResult = AuthResult.fromJson(response.data);
      final resultSession = authResult.session;

      // save refresh token and pincode
      await secureStorageManager.saveRefreshToken(resultSession.refreshToken);
      await secureStorageManager.savePinCode(pinCode);
      //set access token and user in provider
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


  // sign up
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
      //map response to AuthResult
      final authResult = AuthResult.fromJson(response.data);
      final resultSession = authResult.session;
      // save refresh token and pincode
      await secureStorageManager.saveRefreshToken(resultSession.refreshToken);
      await secureStorageManager.savePinCode(registerData.pinCode);
      //set access token and user in provider
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

  //get new access token and refresh token with old refresh token
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
      //map response to Session
      final session = Session.fromJson(response.data);
      //save new refresh token and access token
      await secureStorageManager.saveRefreshToken(session.refreshToken);
      _accessToken = session.accessToken;
      return session;
    } on DioError catch (e) {
      throw HttpError.fromDioError(e);
    } catch (err) {
      throw HttpError(err.toString());
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      debugPrint(accessToken!);
      await dio.get(
        '/auth/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      await secureStorageManager.deleteAll();
      _accessToken = null;
      _user = null;
      notifyListeners();
    } on DioError catch (e) {
      debugPrint(e.toString());
      throw HttpError.fromDioError(e);
    } catch (err) {
      throw HttpError(err.toString());
    }
  }
}
