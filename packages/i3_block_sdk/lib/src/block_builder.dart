import 'dart:io';

import 'package:i3_block_sdk/i3_block_sdk.dart';

abstract class BlockBuilder {
  const BlockBuilder();

  Future<Block> build();
}

Future<void> showBlock(BlockBuilder builder) async {
  Block block;

  try {
    block = await builder.build();
  } catch (e) {
    block = Block(
        text: "${builder.runtimeType} failed to build: $e".ellipsized(120),
        state: BlockState.critical);
  }

  print(block);
  exit(0);
}

extension Elipsis on String {
  String ellipsized(int targetLength) =>
      length <= targetLength ? this : substring(0, targetLength) + "...";
}
