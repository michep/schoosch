import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';

enum AttendanceStatus {
  present,
  absent,
}

extension AttendanceStatusExt on AttendanceStatus {
  static const _present = 'present';
  static const _absent = 'absent';

  static AttendanceStatus? _parse(String value) {
    switch (value) {
      case _present:
        return AttendanceStatus.absent;
      case _absent:
        return AttendanceStatus.absent;
      default:
        return null;
    }
  }

  String get _nameString {
    switch (this) {
      case AttendanceStatus.present:
        return _present;
      case AttendanceStatus.absent:
        return _absent;
    }
  }
}

class AttendanceModel {
  final String? _id;
  late final DateTime date;
  late final String person_id;
  late final int lesson_order;
  late final String status;

  String? get id => _id;

  AttendanceModel.fromMap(this._id, Map<String, dynamic> map) {
    date =
        map['date'] != null ? DateTime.fromMillisecondsSinceEpoch((map['date'] as Timestamp).millisecondsSinceEpoch) : throw 'need date key in attendance $_id';
    person_id = map['person_id'] != null ? map['person_id'] as String : throw 'need person_id key in attendance $_id';
    lesson_order = map['lesson_order'] != null ? map['lesson_order'] as int : throw 'need lesson_order key in attendance $_id';
    status = map['status'] != null ? map['status'] as String : throw 'need status key in attendance $_id'; //TODO: status should be a emun with extensions
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['date'] = date;
    res['person_id'] = person_id;
    res['lesson_order'] = lesson_order;
    res['status'] = status;
    return res;
  }
}
