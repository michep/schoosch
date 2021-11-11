import 'package:flutter/material.dart';

@immutable
class LessontimeModel {
  final String id;
  late final int order;
  late final TimeOfDay from;
  late final TimeOfDay till;

  LessontimeModel.fromMap(this.id, Map<String, Object?> map) {
    order = map['order'] as int;
    var f = (map['from'] as String).split(':');
    var t = (map['till'] as String).split(':');
    from = TimeOfDay(hour: int.parse(f[0]), minute: int.parse(f[1]));
    till = TimeOfDay(hour: int.parse(t[0]), minute: int.parse(t[1]));
  }
}
