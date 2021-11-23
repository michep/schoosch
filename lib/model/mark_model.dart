import 'package:cloud_firestore/cloud_firestore.dart';

class MarkModel {
  late final String id;
  late final String _teacherId;
  late final String _studentId;
  late final DateTime date;
  late final String _curriculumId;
  late final String _type;
  late final int _lessonOrder;
  late final int mark;

  MarkModel.fromMap(this.id, Map<String, dynamic> map) {
    _teacherId = map['teacher_id'] != null ? map['teacher_id'] as String : throw 'need teacher_id key in mark';
    _studentId = map['student_id'] != null ? map['student_id'] as String : throw 'need student_id key in mark';
    date = map['date'] != null
        ? DateTime.fromMillisecondsSinceEpoch((map['date'] as Timestamp).millisecondsSinceEpoch)
        : throw 'need date key in mark';
    _curriculumId = map['curriculum_id'] != null ? map['curriculum_id'] as String : throw 'need curriculum_id key in mark';
    _lessonOrder = map['lesson_order'] != null ? map['lesson_order'] as int : throw 'need lesson_order key in mark';
    _type = map['type'] != null ? map['type'] as String : throw 'need type key in mark';
    if (!['regular', 'test', 'exam'].contains(_type)) throw 'incorrect type in mark';
    mark = map['mark'] != null ? map['mark'] as int : throw 'need mark key in mark';
  }
}
