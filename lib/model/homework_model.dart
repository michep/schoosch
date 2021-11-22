import 'package:cloud_firestore/cloud_firestore.dart';

class HomeworkModel {
  late final String id;
  late final String text;
  late final String? _studentId;
  late final String _curriculumId;
  late final DateTime date;

  HomeworkModel.fromMap(this.id, Map<String, dynamic> map) {
    text = map['text'] != null ? map['text'] as String : throw 'need text key in homework';
    date = map['date'] != null ? DateTime.fromMillisecondsSinceEpoch((map['date'] as Timestamp).millisecondsSinceEpoch) : DateTime(2000);
    _curriculumId = map['curriculum_id'] != null ? map['curriculum_id'] as String : throw 'need curriculum_id key in homework';
    _studentId = map['student_id'] != null ? map['student_id'] as String : '';
  }
}
