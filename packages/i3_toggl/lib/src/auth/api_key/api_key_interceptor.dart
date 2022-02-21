import 'package:dio/dio.dart';
import 'package:i3_toggl/src/util/toggl_api_constants.dart';

import '../../util/http_util.dart';

class ApiKeyAuthInterceptor extends Interceptor {
  ApiKeyAuthInterceptor();
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (togglApiKey.isEmpty) {
      final error = StateError("TOGGL_API_KEY env variable is empty.");
      handler.reject(DioError(requestOptions: options, error: error));
      return;
    }

    final credentials = encodeCredentials(togglApiKey, 'api_token');
    options.headers['Authorization'] = 'Basic $credentials';
    handler.next(options);
  }
}