import 'package:flutter/material.dart';

class LessontimeModel {
  final String? _id;
  late final int order;
  late final TimeOfDay from;
  late final TimeOfDay till;

  String? get id => _id;

  LessontimeModel.fromMap(this._id, Map<String, Object?> map) {
    order = map['order'] != null ? map['order'] as int : throw 'need order key in lessontime $id';
    var f = map['from'] != null ? (map['from'] as String).split(':') : throw 'need from key in lessontime $id';
    if (f.length != 2) throw 'incorrect from in lessontime $id';
    var t = map['till'] != null ? (map['till'] as String).split(':') : throw 'need till key in lessontime $id';
    if (t.length != 2) throw 'incorrect till in lessontime $id';
    from = TimeOfDay(hour: int.parse(f[0]), minute: int.parse(f[1]));
    till = TimeOfDay(hour: int.parse(t[0]), minute: int.parse(t[1]));
  }

  String format(BuildContext context) {
    return '${from.format(context)} \u2014 ${till.format(context)}';
  }
}
