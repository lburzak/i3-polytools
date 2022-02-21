import 'package:args/command_runner.dart';
import 'package:dio/dio.dart';
import 'package:i3_block_sdk/i3_block_sdk.dart';
import 'package:i3_toggl/src/auth/session_interceptor.dart';
import 'package:i3_toggl/src/authenticate_command.dart';
import 'package:i3_toggl/src/current_entry.dart';
import 'package:i3_toggl/src/session_storage.dart';
import 'package:i3_toggl/src/time_entry_repository.dart';
import 'package:i3_toggl/src/toggl_session_manager.dart';

void main(List<String> args) async {
  final dio = Dio();
  final sessionStorage = SessionStorage();
  final sessionManager = TogglSessionManager(dio, sessionStorage);

  if (args.isNotEmpty) {
    CommandRunner("i3_toggl", "i3_toggl authentication CLI")
      ..addCommand(AuthenticateCommand(sessionManager))
      ..run(args);
    return;
  }

  final interceptor = SessionInterceptor(sessionStorage);
  dio.interceptors.add(interceptor);
  final entryRepository = TimeEntryRepository(dio);

  showBlock(CurrentEntry(sessionManager, entryRepository));
}
