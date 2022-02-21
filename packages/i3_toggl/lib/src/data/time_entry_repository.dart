import 'package:dio/dio.dart';
import 'package:i3_toggl/src/util/toggl_api_constants.dart';

import 'model/connection_error.dart';
import 'model/time_entry.dart';

class TimeEntryRepository {
  final Dio _dio;

  TimeEntryRepository(this._dio);

  Future<TimeEntry?> getCurrentEntry() async {
    Response response;

    try {
      response = await _dio.get("$togglApiUrl/time_entries/current",);
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