import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:scanning_world/data/http/dio_client.dart';
import 'package:scanning_world/data/http/http_exception.dart';
import 'package:scanning_world/data/models/auth.dart';
import 'package:scanning_world/data/models/session.dart';

import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final dio = DioClient.dio;

  final User? _user = null;

  User? get user => _user;

  Future<Session> signIn(String phoneNumber, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'phone': phoneNumber,
          'password': password,
        },
      );
      return Session.fromJson(response.data!);
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
          "name": registerData.username,
          "email": registerData.email,
          "password": registerData.password,
          "phone": registerData.phoneNumber,
          "region": registerData.city,
        },
      );
      return Session.fromJson(response.data!);
    } on DioError catch (e) {
      throw HttpError.fromDioError(e);
    } catch (err) {
      throw HttpError(err.toString());
    }
  }
}
