import 'package:dio/dio.dart';
import 'package:i3_toggl/src/util/toggl_api_constants.dart';

import 'session_storage.dart';

class SessionInterceptor extends Interceptor {
  final SessionStorage _sessionStorage;

  SessionInterceptor(this._sessionStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _sessionStorage.read().then((session) {
      options.headers['Cookie'] = "$sessionCookieKey=$session";
      handler.next(options);
    });
  }
}