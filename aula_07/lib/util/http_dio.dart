import 'package:dio/dio.dart';

class HttpDio {
  final Dio _dio = Dio();
  late Options _options;

  HttpDio() {
    initDio();
  }

  Dio get instance => _dio;
  Options get options => _options;

  void initDio() {
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    _options = Options(
      contentType: Headers.jsonContentType,
      followRedirects: false,
      validateStatus: (status) {
        return true;
      },
    );
  }
}
