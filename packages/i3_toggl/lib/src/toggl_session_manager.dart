import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:i3_toggl/src/session_storage.dart';

import 'config.dart';

class TogglSessionManager {
  final Dio _dio;
  final SessionStorage _sessionStorage;
  final Config _config;

  TogglSessionManager(this._dio, this._sessionStorage, this._config);

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
    final credentials = _encodeCredentials(username, password);
    final headers = {'Authorization': 'Basic $credentials'};

    final response = await _dio.post('${_config.apiUrl}/sessions',
        options: Options(headers: headers));

    final setCookieHeader = response.headers.value('set-cookie');

    if (setCookieHeader == null) {
      return null;
    }

    return _parseSetCookieHeader(setCookieHeader);
  }

  String _encodeCredentials(String username, String password) {
    final credentialsUtf8 = utf8.encode("$username:$password");
    return base64.encode(credentialsUtf8);
  }

  String _parseSetCookieHeader(String value) {
    final cookies = value.split(";");
    final firstCookie = cookies.first;
    final separatorIndex = firstCookie.indexOf('=');
    return firstCookie.substring(separatorIndex + 1);
  }
}
