// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MarkModel {
  String? id;
  late final String _teacherId;
  late final String studentId;
  late final DateTime date;
  late final String _curriculumId;
  late final String _type;
  late final String comment;
  late final int _lessonOrder;
  late final int mark;

  MarkModel.fromMap(this.id, Map<String, dynamic> map) {
    _teacherId = map['teacher_id'] != null ? map['teacher_id'] as String : throw 'need teacher_id key in mark $id';
    studentId = map['student_id'] != null ? map['student_id'] as String : throw 'need student_id key in mark $id';
    date = map['date'] != null ? DateTime.fromMillisecondsSinceEpoch((map['date'] as Timestamp).millisecondsSinceEpoch) : throw 'need date key in mark $id';
    _curriculumId = map['curriculum_id'] != null ? map['curriculum_id'] as String : throw 'need curriculum_id key in mark $id';
    _lessonOrder = map['lesson_order'] != null ? map['lesson_order'] as int : throw 'need lesson_order key in mark $id';
    _type = map['type'] != null ? map['type'] as String : throw 'need type key in mark $id';
    if (!['regular', 'test', 'exam'].contains(_type)) throw 'incorrect type in mark $id';
    comment = map['comment'] != null ? map['comment'] as String : '';
    mark = map['mark'] != null ? map['mark'] as int : throw 'need mark key in mark $id';
  }

  Map<String, dynamic> toMap() {
    return {
      'teacher_id': _teacherId,
      'student_id': studentId,
      'date': date,
      'curriculum_id': _curriculumId,
      'lesson_order': _lessonOrder,
      'type': _type,
      'comment': comment,
      'mark': mark,
    };
  }

  Future<void> save() async {
    id = await Get.find<FStore>().saveMark(this);
  }

  Future<PersonModel> get teacher async {
    return Get.find<FStore>().getPerson(_teacherId);
  }

  Future<PersonModel> get student async {
    return Get.find<FStore>().getPerson(studentId);
  }
}
