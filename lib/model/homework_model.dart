import 'package:cloud_firestore/cloud_firestore.dart';

class HomeworkModel {
  final String _id;
  late final String text;
  late final String? _studentId;
  late final String _curriculumId;
  late final String _teacherId;
  late final DateTime date;

  HomeworkModel.fromMap(this._id, Map<String, dynamic> map) {
    text = map['text'] != null ? map['text'] as String : throw 'need text key in homework  $_id';
    date = map['date'] != null ? DateTime.fromMillisecondsSinceEpoch((map['date'] as Timestamp).millisecondsSinceEpoch) : DateTime(2000);
    _curriculumId = map['curriculum_id'] != null ? map['curriculum_id'] as String : throw 'need curriculum_id key in homework  $_id';
    _studentId = map['student_id'] != null ? map['student_id'] as String : null;
    _teacherId = map['teacher_id'] != null ? map['teacher_id'] as String : throw 'need teacher_id key in homework  $_id';
  }

  String? get studentId => _studentId;
}
