import 'package:i3_block_sdk/i3_block_sdk.dart';
import 'package:i3_toggl/src/connection_error.dart';
import 'package:i3_toggl/src/time_entry.dart';
import 'package:i3_toggl/src/time_entry_repository.dart';
import 'package:i3_toggl/src/toggl_session_manager.dart';

class CurrentEntry extends BlockBuilder {
  final TogglSessionManager _sessionManager;
  final TimeEntryRepository _entryRepository;

  CurrentEntry(this._sessionManager, this._entryRepository);

  @override
  Future<Block> build() async {
    final authenticated = await _sessionManager.checkAuthenticated();

    if (!authenticated) {
      return Block(text: "Not authenticated");
    }

    TimeEntry? currentEntry;

    try {
      currentEntry = await _entryRepository.getCurrentEntry();
    } on ConnectionError {
      return Block(text: "No connection!", state: BlockState.warning);
    }

    return Block(
        text: _entryToText(currentEntry),
        state: _entryToState(currentEntry)
    );
  }
  
  String _entryToText(TimeEntry? entry) => entry != null
      ? "${entry.safeDescription} ${entry.duration.inBlockFormat}"
      : "No task";
  
  BlockState? _entryToState(TimeEntry? entry) {
    if (entry == null) {
      return BlockState.info;
    }

    if (entry.duration.inMinutes > 50) {
      return BlockState.warning;
    }

    if (entry.duration.inHours > 2) {
      return BlockState.critical;
    }

    return null;
  }
}

extension _EntryFormat on Duration {
  String get inBlockFormat => inHours > 0
      ? "$inHours:${inMinutes % 60}:${inSeconds % 60}"
      : "$inMinutes:${inSeconds % 60}";
}

extension _Format on TimeEntry {
  String get safeDescription => description ?? "(No description)";
}
