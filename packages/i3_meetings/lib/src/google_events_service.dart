import 'package:googleapis/calendar/v3.dart';
import 'package:i3_meetings/src/event.dart' as model;
import 'package:i3_meetings/src/events_service.dart';

class GoogleEventsService implements EventsService {
  final CalendarApi _api;
  final List<String> calendarsNames;

  GoogleEventsService(this._api, {required this.calendarsNames});

  @override
  Future<model.Event> getNextEvent() async {
    final applicableIds = await _getCalendarsIds();
    final potentialEvents = await Future.wait(
        applicableIds.map((id) async => await _getClosestEvent(id)));
    final events =
    potentialEvents.where((element) => element != null).cast<Event>();
    final nearestEvent = events.reduce((value, element) => _nearerEvent(value, element));
    return model.Event(
      summary: nearestEvent.summary
    );
  }

  Future<Iterable<String>> _getCalendarsIds() async {
    final result = await _api.calendarList.list();
    final calendars = result.items;

    if (calendars == null) {
      throw Error();
    }

    return calendars
        .where((element) =>
    element.summary != null && calendarsNames.contains(element.summary))
        .map((e) => e.id)
        .where((e) => e != null).cast<String>();
  }

  Future<Event?> _getClosestEvent(String calendarId) async {
    final result =
    await _api.events.list(calendarId, orderBy: "startTime", maxResults: 1);

    return result.items?.first;
  }

  Event _nearerEvent(Event first, Event second) =>
      first.start!.dateTime!.isBefore(second.start!.dateTime!) ? first : second;
}
