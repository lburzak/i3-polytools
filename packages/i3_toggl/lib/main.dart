import 'package:dio/dio.dart';
import 'package:i3_block_sdk/i3_block_sdk.dart';
import 'package:i3_toggl/src/auth/api_key/api_key_interceptor.dart';
import 'package:i3_toggl/src/current_entry_block.dart';
import 'package:i3_toggl/src/data/time_entry_repository.dart';

void main(List<String> args) async {
  final dio = Dio()..interceptors.add(ApiKeyAuthInterceptor());
  final entryRepository = TimeEntryRepository(dio);

  showBlock(CurrentEntry(entryRepository));
}
