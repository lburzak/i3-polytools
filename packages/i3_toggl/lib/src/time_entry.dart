class TimeEntry {
  final String? description;

  const TimeEntry({
    required this.description,
  });

  String get safeDescription => description ?? "(No description)";

  factory TimeEntry.fromMap(Map<String, dynamic> map) {
    return TimeEntry(
      description: map['description'] as String?,
    );
  }
}
