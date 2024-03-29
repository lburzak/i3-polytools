import 'package:i3_block_sdk/i3_block_sdk.dart';
import 'package:i3_toggl/src/data/time_entry_repository.dart';

import 'data/model/connection_error.dart';
import 'data/model/time_entry.dart';

class CurrentEntry extends BlockBuilder {
  final TimeEntryRepository _entryRepository;

  CurrentEntry(this._entryRepository);

  @override
  Future<Block> build() async {
    TimeEntry? currentEntry;

    try {
      currentEntry = await _entryRepository.getCurrentEntry();
    } on ConnectionError {
      return Block(text: "No connection!", state: BlockState.warning);
    }

    return Block(
        icon: "power",
        text: _entryToText(currentEntry),
        state: _entryToState(currentEntry));
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
  String get inBlockFormat =>
      (inHours > 0 ? "${inHours.padded}:" : "") +
      "${inMinutes.padded}:${inSeconds.padded}";
}

extension _TimePadding on num {
  String get padded => (this % 60).toString().padLeft(2, '0');
}

extension _Format on TimeEntry {
  String get safeDescription => description ?? "(No description)";
}
