import 'package:dio/dio.dart';
import 'package:i3_toggl/src/session_storage.dart';
import 'package:i3_toggl/src/toggl_api_constants.dart';

import 'http_util.dart';

class TogglSessionManager {
  final Dio _dio;
  final SessionStorage _sessionStorage;

  TogglSessionManager(this._dio, this._sessionStorage);

  Future<void> authenticate(String username, String password) async {
    final session = await _createSession(username, password);

    if (session == null) {
      throw Error();
    }

    await _sessionStorage.save(session);
  }

  Future<bool> checkAuthenticated() async {
    final session = await _sessionStorage.read();
    return session != null;
  }

  Future<String?> _createSession(String username, String password) async {
    final credentials = encodeCredentials(username, password);
    final headers = {'Authorization': 'Basic $credentials'};

    final response = await _dio.post('$togglApiUrl/sessions',
        options: Options(headers: headers));

    final setCookieHeader = response.headers.value('set-cookie');

    if (setCookieHeader == null) {
      return null;
    }

    return _parseSetCookieHeader(setCookieHeader);
  }

  String _parseSetCookieHeader(String value) {
    final cookies = value.split(";");
    final firstCookie = cookies.first;
    final separatorIndex = firstCookie.indexOf('=');
    return firstCookie.substring(separatorIndex + 1);
  }
}
