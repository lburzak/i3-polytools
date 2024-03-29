import 'dart:io';

import 'package:i3_block_sdk/i3_block_sdk.dart';

const defaultTarget = 'www.stackoverflow.com';

void main(List<String> args) async {
  await showBlock(Ping(
      count: args.isNotEmpty ? int.parse(args[0]) : 2, target: defaultTarget));
}

class Ping extends BlockBuilder {
  final int count;
  final String target;

  const Ping({
    required this.count,
    required this.target,
  });

  @override
  Future<Block> build() async {
    final ping = await readAveragePing();

    if (ping == null) {
      return Block(text: '---', icon: "ping");
    }

    return Block(
        text: ping.round().toString().padLeft(3),
        state: ping > 400 ? BlockState.critical : null,
        icon: "ping"
    );
  }

  Future<num?> readAveragePing() async {
    final result = await Process.run('ping', ['-c', count.toString(), target]);

    if (result.exitCode > 0) {
      return null;
    }

    final rawPing =
        result.stdout.trim().split('\n').last.split('=')[1].split('/')[1];

    return num.parse(rawPing);
  }
}
