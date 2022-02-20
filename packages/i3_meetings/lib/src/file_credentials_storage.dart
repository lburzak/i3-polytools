import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:i3_meetings/src/credentials_storage.dart';

class FileCredentialsStorage implements CredentialsStorage {
  final File _credentialsFile;

  FileCredentialsStorage(String path) : _credentialsFile = File(path);

  @override
  Future<AccessCredentials?> get() async {
    final fileExists = await _credentialsFile.exists();
    if (!fileExists) {
      return null;
    }

    final fileContent = await _credentialsFile.readAsString();

    try {
      final json = jsonDecode(fileContent);
      return AccessCredentials.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> put(AccessCredentials accessCredentials) async {
    final map = accessCredentials.toJson();
    final json = jsonEncode(map);
    await ensureCredentialsFileExists();
    await _credentialsFile.writeAsString(json);
  }

  Future<void> ensureCredentialsFileExists() async {
    final fileExists = await _credentialsFile.exists();
    if (!fileExists) {
      await _credentialsFile.create(recursive: true);
    }
  }
}
