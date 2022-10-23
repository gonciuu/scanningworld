import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scanning_world/data/local/secure_storage_manager.dart';
import 'package:scanning_world/data/remote/models/auth/auth_result.dart';
import 'package:scanning_world/data/remote/models/user/place.dart';
import '../../../screens/profile/change_account_data_screen.dart';
import '../http/dio_client.dart';
import '../http/http_exception.dart';
import '../models/auth/auth.dart';
import '../models/auth/session.dart';
import '../models/coupon.dart';
import '../models/user/user.dart';

FutureOr<User> parseUser(dynamic responseBody) {
  final resUser = User.fromJson(responseBody);
  return resUser;
}

FutureOr<AuthResult> parseAuthResult(dynamic responseBody) {
  final resAuthResult = AuthResult.fromJson(responseBody);
  return resAuthResult;
}

FutureOr<Session> parseSession(dynamic responseBody) {
  final resSession = Session.fromJson(responseBody);
  return resSession;
}

class AuthProvider with ChangeNotifier {
  final dio = DioClient.dio;
  final SecureStorageManager secureStorageManager = SecureStorageManager();


  // user and access token needed for requests
  User? _user;

  User? get user => _user;

  String? _accessToken;

  String? get accessToken => _accessToken;


  // session needed for refresh token
  // add auth interceptor to catch access token expiration
  void addAuthInterceptor() {
    dio.interceptors
        .add(InterceptorsWrapper(onError: (DioError error, handler) async {
      RequestOptions? origin = error.response?.requestOptions;
      if (error.response?.statusCode == 401) {
        try {
          final sessionRes = await refreshToken();
          if (origin != null) {
            try {
              final response = await dio.request(origin.path,
                  data: origin.data ?? {},
                  options: Options(
                    headers: {
                      'Authorization': 'Bearer ${sessionRes.accessToken}',
                    },
                    followRedirects: false,
                    contentType: 'application/json',
                    method: origin.method,
                  ));
              return handler.resolve(response);
            } on DioError catch (e) {
              // catch another error
              return handler.reject(e);
            }
          }
        } catch (err) {
          return handler.reject(error);
        }
      }
      return handler.reject(error);
    }));
  }

  // get user info after refresh token
  Future<User> getInfoAboutMe() async {
    try {
      final response = await dio.get('/users/me',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      final resUser = await compute(parseUser, response.data);
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
      final authResult = await compute(parseAuthResult, response.data);
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
          "avatar":"male1",
        },
      );
      //map response to AuthResult
      final authResult = await compute(parseAuthResult, response.data);
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
      final session = await compute(parseSession, response.data);
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

  // forgot password
  Future<void> forgotPassword(String phoneNumber) async {
    try {
      await dio.get('/auth/forgot-password?phone=$phoneNumber');
    } on DioError catch (e) {
      throw HttpError.fromDioError(e);
    } catch (err) {
      throw HttpError(err.toString());
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
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
      throw HttpError.fromDioError(e);
    } catch (err) {
      throw HttpError(err.toString());
    }
  }

  // change password
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await dio.patch(
        '/auth/change-password',
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
    } on DioError catch (e) {
      throw HttpError.fromDioError(e);
    } catch (err) {
      throw HttpError(err.toString());
    }
  }

  Future<void> changeUserInfo(ChangeAccountData changeAccountData) async {
    try {
      final responseUser = await dio.patch(
        '/users/details',
        data: {
          'name': changeAccountData.username,
          'email': changeAccountData.email,
          'regionId': changeAccountData.region.id
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      final newUser = await compute(parseUser, responseUser.data);
      _user = newUser;
      notifyListeners();
    } on DioError catch (e) {
      throw HttpError.fromDioError(e);
    } catch (err) {
      throw HttpError(err.toString());
    }
  }

  // on scan QR Code Correctly
  Future<Place> scanPlace(String code,Position position) async {
    try {
      final response = await dio.post(
        '/places/$code',
        data: {
          'lat': position.latitude,
          'lng': position.longitude,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      User newUser = await compute(parseUser, response.data);
      _user = newUser;
      notifyListeners();
      return newUser.scannedPlaces.last;
    } on DioError catch (e) {
      throw HttpError.fromDioError(e);
    } catch (err) {
      throw HttpError(err.toString());
    }
  }

  //on coupon activate
  Future<ActiveCoupon> orderCoupon(String couponId) async {
    try {
      final response = await dio.post(
        '/coupons/activate/$couponId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      User newUser = await compute(parseUser, response.data);
      _user = newUser;
      notifyListeners();
      return newUser.activeCoupons.last;
    } on DioError catch (e) {
      throw HttpError.fromDioError(e);
    } catch (err) {
      throw HttpError(err.toString());
    }
  }

  Future<User> changeAvatar(String avatar) async{
    try {
      final response = await dio.patch(
        '/users/avatar',
        data: {
          'avatar': avatar,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      User newUser = await compute(parseUser, response.data);
      _user = newUser;
      notifyListeners();
      return newUser;
    } on DioError catch (e) {
      throw HttpError.fromDioError(e);
    } catch (err) {
      throw HttpError(err.toString());
    }
  }
}
