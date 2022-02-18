import 'dart:convert';

import 'block_state.dart';

class Block {
  final String? icon;
  final BlockState? state;
  final String text;

  const Block({this.icon, this.state, required this.text});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'text': text
    };

    if (icon != null) {
      map['icon'] = icon;
    }

    if (state != null) {
      map['state'] = state?.serialize();
    }

    return map;
  }

  String encode() => json.encode(toMap());
}