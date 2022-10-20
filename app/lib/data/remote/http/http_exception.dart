

import 'package:dio/dio.dart';

class HttpError implements Exception {
  final String message;
  final int? statusCode;

  HttpError(this.message, {this.statusCode});


  @override
  String toString() {
    return "Error: $message. Sprawdź swoje połączenie z internetem";
  }

  static HttpError fromDioError(DioError dioError){
    if(dioError.response != null && dioError.response!.data != null && dioError.response!.statusCode != null){
      return HttpError(dioError.response!.data['message'].toString(),statusCode: dioError.response!.data['statusCode']);
    }else{
      return HttpError("Błąd połączenia z serwerem. Sprawdź swoje połączenie z internetem");
    }
  }
}