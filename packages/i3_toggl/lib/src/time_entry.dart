class TimeEntry {
  final String? description;
  final Duration duration;

  const TimeEntry({required this.description, required this.duration});

  factory TimeEntry.fromMap(Map<String, dynamic> map) {
    int duration = map['duration'] as int;
    return TimeEntry(
        description: map['description'] as String?,
        duration: Duration(
            seconds:
                duration >= 0 ? duration : _calculateRunningSeconds(duration)));
  }

  static int _calculateRunningSeconds(int durationSeconds) {
    final currentSecondsSinceEpoch = DateTime.now().secondsSinceEpoch;
    return currentSecondsSinceEpoch + durationSeconds;
  }
}

extension SecondsEpoch on DateTime {
  int get secondsSinceEpoch => millisecondsSinceEpoch ~/ 1000;
}
