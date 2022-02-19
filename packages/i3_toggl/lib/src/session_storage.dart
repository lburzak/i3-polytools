import 'dart:io';

import 'package:i3_toggl/src/config.dart';

class SessionStorage {
  final File _sessionFile;

  SessionStorage(Config config) : _sessionFile = File(config.sessionFilePath);

  Future<void> save(String value) async {
    final exists = await _sessionFile.exists();
    if (!exists) {
      await _sessionFile.create(recursive: true);
    }

    await _sessionFile.writeAsString(value);
  }

  Future<String?> read() async {
    final exists = await _sessionFile.exists();
    if (!exists) {
      return null;
    }

    return await _sessionFile.readAsString();
  }
}
