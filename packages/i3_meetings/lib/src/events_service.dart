import 'package:i3_meetings/src/event.dart';

abstract class EventsService {
  Future<Event> getNextEvent();
}