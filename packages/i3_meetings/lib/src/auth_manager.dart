import 'dart:io';

import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:i3_meetings/src/credentials_storage.dart';

const clientId = String.fromEnvironment('CLIENT_ID');
const clientSecret = String.fromEnvironment('CLIENT_SECRET');

class AuthManager {
  final CredentialsStorage _credentialsStorage;
  final _clientId = ClientId(clientId, clientSecret);
  static const _scopes = [CalendarApi.calendarReadonlyScope];

  AuthManager(this._credentialsStorage);

  Future<http.Client> createClient() async {
    final credentials = await _credentialsStorage.get();

    return credentials != null
        ? _createClientWithCredentials(credentials)
        : await _createClientViaConsent();
  }

  http.Client _createClientWithCredentials(AccessCredentials credentials) {
    final baseClient = http.Client();
    return autoRefreshingClient(_clientId, credentials, baseClient);
  }

  Future<http.Client> _createClientViaConsent() async {
    final client = await clientViaUserConsent(
        _clientId, _scopes, _openUriInDefaultBrowser);
    _credentialsStorage.put(client.credentials);
    return client;
  }

  void _openUriInDefaultBrowser(String uri) {
    Process.run("xdg-open", [uri]);
  }
}
