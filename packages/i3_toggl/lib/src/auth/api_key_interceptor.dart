import 'package:dio/dio.dart';

import '../http_util.dart';

class ApiKeyAuthInterceptor extends Interceptor {
  final String _apiKey;

  ApiKeyAuthInterceptor(this._apiKey);
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final credentials = encodeCredentials(_apiKey, 'api_token');
    options.headers['Authorization'] = 'Basic $credentials';
  }
}