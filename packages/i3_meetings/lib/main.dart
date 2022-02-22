import 'dart:io';

import 'package:googleapis/calendar/v3.dart';
import 'package:i3_block_sdk/i3_block_sdk.dart';
import 'package:i3_meetings/src/auth_manager.dart';
import 'package:i3_meetings/src/file_credentials_storage.dart';
import 'package:i3_meetings/src/google_events_service.dart';
import 'package:path/path.dart';

final homePath = Platform.environment["HOME"]!;
final defaultCredentialsPath = join(
    homePath, ".config", "polytools", "i3_meetings_credentials.json");

void main(List<String> args) async {
  final credentialsStorage = FileCredentialsStorage(defaultCredentialsPath);
  final authManager = AuthManager(credentialsStorage);

  await showBlock(Meetings(authManager));
}

class Meetings extends BlockBuilder {
  final AuthManager _authManager;

  Meetings(this._authManager);

  @override
  Future<Block> build() async {
    final client = await _authManager.createClient();
    final api = CalendarApi(client);
    const calendars = ['Personal'];
    final service = GoogleEventsService(api, calendarsNames: calendars);
    final nearest = await service.getNextEvent();

    return Block(text: nearest.summary ?? "No summary");
  }
}
