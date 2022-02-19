import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dio/dio.dart';
import 'package:i3_block_sdk/i3_block_sdk.dart';
import 'package:i3_toggl/src/authenticate_command.dart';
import 'package:i3_toggl/src/config.dart';
import 'package:i3_toggl/src/current_entry.dart';
import 'package:i3_toggl/src/session_storage.dart';
import 'package:i3_toggl/src/time_entry_repository.dart';
import 'package:i3_toggl/src/toggl_session_manager.dart';
import 'package:path/path.dart' as p;

final homePath = Platform.environment["HOME"]!;
final defaultConfig = Config(
    apiUrl: "https://api.track.toggl.com/api/v8",
    sessionCookieKey: "__Host-timer-session",
    sessionFilePath: p.join(homePath, ".config", "polytools", "toggl_session"));

void main(List<String> args) async {
  final dio = Dio();
  final sessionStorage = SessionStorage(defaultConfig);
  final sessionManager =
      TogglSessionManager(dio, sessionStorage, defaultConfig);

  if (args.isNotEmpty) {
    CommandRunner("i3_toggl", "i3_toggl authentication CLI")
      ..addCommand(AuthenticateCommand(sessionManager))
      ..run(args);
    return;
  }

  final entryRepository =
      TimeEntryRepository(dio, sessionStorage, defaultConfig);

  showBlock(CurrentEntry(sessionManager, entryRepository));
}