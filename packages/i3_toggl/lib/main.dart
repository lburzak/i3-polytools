import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dio/dio.dart';
import 'package:i3_block_sdk/i3_block_sdk.dart';
import 'package:i3_toggl/src/authenticate_command.dart';
import 'package:i3_toggl/src/config.dart';
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

  final authenticated = await sessionManager.checkAuthenticated();
  if (!authenticated) {
    print(Block(text: "Not authenticated"));
    return;
  }

  final entryRepository =
      TimeEntryRepository(dio, sessionStorage, defaultConfig);
  final currentEntry = await entryRepository.getCurrentEntry();
  print(Block(
      text: currentEntry != null
          ? "${currentEntry.safeDescription} ${currentEntry.duration.inBlockFormat}"
          : "No task"));
  exit(0);
}

Future<Block> buildBlock(List<String> args) async {
  return Block(text: "ping");
}

extension EntryFormat on Duration {
  String get inBlockFormat => inHours > 0
      ? "$inHours:${inMinutes % 60}:${inSeconds % 60}"
      : "$inMinutes:${inSeconds % 60}";
}
