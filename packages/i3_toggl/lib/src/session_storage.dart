import 'dart:io';

import 'package:path/path.dart';

final _homePath = Platform.environment['HOME']!;
final _sessionFilePath =
    join(_homePath, ".config", "polytools", "toggl_session");

class SessionStorage {
  final File _sessionFile = File(_sessionFilePath);

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
