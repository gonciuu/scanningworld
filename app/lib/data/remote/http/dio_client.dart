import 'package:dio/dio.dart';
import 'package:scanning_world/config/app_config.dart';

class DioClient {
  static Dio dio = Dio(BaseOptions(
    baseUrl: API_BASE_URL,
    connectTimeout: API_CONNECT_TIMEOUT,
    receiveTimeout: API_RECEIVE_TIMEOUT,
    contentType: 'application/json',
  ));


}
