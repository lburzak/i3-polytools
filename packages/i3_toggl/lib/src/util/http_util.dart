import 'dart:convert';

String encodeCredentials(String username, String password) {
  final credentialsUtf8 = utf8.encode("$username:$password");
  return base64.encode(credentialsUtf8);
}