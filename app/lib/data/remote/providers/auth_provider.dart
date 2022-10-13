import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:scanning_world/data/local/token_manager.dart';

import '../http/dio_client.dart';
import '../http/http_exception.dart';
import '../models/auth.dart';
import '../models/session.dart';
import '../models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final dio = DioClient.dio;
  final TokenManager tokenManager = TokenManager();

  User? _user;

  User? get user => _user;

  String? _accessToken;

  String? get accessToken => _accessToken;

  Future<Session> signIn(String phoneNumber, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'phone': phoneNumber,
          'password': password,
        },
      );
      final session = Session.fromJson(response.data);
      await tokenManager.saveRefreshToken(session.refreshToken);
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
      await tokenManager.saveRefreshToken(session.refreshToken);
      _accessToken = session.accessToken;
      return session;
    } on DioError catch (e) {
      throw HttpError.fromDioError(e);
    } catch (err) {
      throw HttpError(err.toString());
    }
  }
}
