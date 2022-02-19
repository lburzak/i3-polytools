import 'package:dio/dio.dart';
import 'package:i3_toggl/src/config.dart';
import 'package:i3_toggl/src/connection_error.dart';
import 'package:i3_toggl/src/session_storage.dart';
import 'package:i3_toggl/src/time_entry.dart';

class TimeEntryRepository {
  final SessionStorage _sessionStorage;
  final Config _config;
  final Dio _dio;

  TimeEntryRepository(this._dio, this._sessionStorage, this._config);

  Future<TimeEntry?> getCurrentEntry() async {
    final session = await _sessionStorage.read();
    final cookie = "${_config.sessionCookieKey}=$session";
    final options = Options(headers: {
      'Cookie': cookie
    });
    Response response;

    try {
      response = await _dio.get(
          "${_config.apiUrl}/time_entries/current",
          options: options);
    } on DioError {
      throw ConnectionError();
    }

    final data = response.data['data'];
    if (data == null) {
      return null;
    }
    return TimeEntry.fromMap(data);
  }
}