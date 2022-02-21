import 'package:args/command_runner.dart';
import 'package:i3_toggl/src/auth/session/toggl_session_manager.dart';

class AuthenticateCommand extends Command {
  @override
  final name = "authenticate";
  @override
  final description = "Create toggl session";
  static final username = 'username';
  static final password = 'password';

  final TogglSessionManager _sessionManager;

  AuthenticateCommand(this._sessionManager) {
    argParser.addOption(username, abbr: 'u', mandatory: true);
    argParser.addOption(password, abbr: 'p', mandatory: true);
  }

  @override
  void run() {
    _sessionManager.authenticate(argResults![username], argResults![password]);
  }
}
