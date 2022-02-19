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
    block = Block(text: "${builder.runtimeType} failed to build: $e");
  }

  print(block);
}