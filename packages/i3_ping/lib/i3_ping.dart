import 'dart:io';

import 'package:i3_block_sdk/i3_block_sdk.dart';

const target = 'www.stackoverflow.com';

void main(List<String> args) async {
  final block = await buildBlock(args);
  print(block.encode());
}

Future<Block> buildBlock(List<String> args) async {
  final count = args.isNotEmpty ? int.parse(args[0]) : 2;
  final ping = await readAveragePing(count, target);
  return Block(
      text: ping.round().toString().padLeft(3),
      state: ping > 400 ? BlockState.critical : null,
      icon: "ping"
  );
}

Future<num> readAveragePing(int pingsCount, String target) async {
  final output = await Process.run('ping', ['-c', pingsCount.toString(), target]);
  final rawPing = output.stdout.trim().split('\n').last.split('=')[1].split('/')[1];

  return num.parse(rawPing);
}
