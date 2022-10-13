

import 'package:dio/dio.dart';

class HttpError implements Exception {
  final String message;
  final int? statusCode;

  HttpError(this.message, {this.statusCode});

  static HttpError fromDioError(DioError dioError){
    if(dioError.response != null){
      return HttpError(dioError.response!.data['message'],statusCode: dioError.response!.data['statusCode']);
    }else{
      return HttpError("Błąd połączenia z serwerem");
    }
  }
}