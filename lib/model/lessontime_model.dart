import 'package:flutter/material.dart';

@immutable
class LessontimeModel {
  final String id;
  late final int order;
  late final TimeOfDay from;
  late final TimeOfDay till;

  LessontimeModel.fromMap(this.id, Map<String, Object?> map) {
    order = map['order'] != null ? map['order'] as int : throw 'need order key in lessontime';
    var f = map['from'] != null ? (map['from'] as String).split(':') : throw 'need from key in lessontime';
    if (f.length != 2) throw 'incorrect from in lessontime';
    var t = map['till'] != null ? (map['till'] as String).split(':') : throw 'need till key in lessontime';
    if (t.length != 2) throw 'incorrect till in lessontime';
    from = TimeOfDay(hour: int.parse(f[0]), minute: int.parse(f[1]));
    till = TimeOfDay(hour: int.parse(t[0]), minute: int.parse(t[1]));
  }

  String format(BuildContext context) {
    return '${from.format(context)} \u2014 ${till.format(context)}';
  }
}
