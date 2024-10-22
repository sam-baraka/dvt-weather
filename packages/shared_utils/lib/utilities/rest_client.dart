import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class RestClient {
  late Dio dio;

  RestClient({BaseOptions? options}) {
    create(options);
  }
  void create([BaseOptions? options]) {
    dio = Dio(options);

    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        maxWidth: 200,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
      ));
    }
  }
}
