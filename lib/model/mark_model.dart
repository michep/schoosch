import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/people_model.dart';

class MarkModel {
  late final String id;
  late final String _teacherId;
  late final String _studentId;
  late final DateTime _date;
  late final String _curriculumId;
  late final String _type;
  late final String comment;
  late final int _lessonOrder;
  late final int mark;

  MarkModel.fromMap(this.id, Map<String, dynamic> map) {
    _teacherId = map['teacher_id'] != null ? map['teacher_id'] as String : throw 'need teacher_id key in mark';
    _studentId = map['student_id'] != null ? map['student_id'] as String : throw 'need student_id key in mark';
    _date = map['date'] != null
        ? DateTime.fromMillisecondsSinceEpoch((map['date'] as Timestamp).millisecondsSinceEpoch)
        : throw 'need date key in mark';
    _curriculumId = map['curriculum_id'] != null ? map['curriculum_id'] as String : throw 'need curriculum_id key in mark';
    _lessonOrder = map['lesson_order'] != null ? map['lesson_order'] as int : throw 'need lesson_order key in mark';
    _type = map['type'] != null ? map['type'] as String : throw 'need type key in mark';
    if (!['regular', 'test', 'exam'].contains(_type)) throw 'incorrect type in mark';
    comment = map['comment'] != null ? map['comment'] as String : '';
    mark = map['mark'] != null ? map['mark'] as int : throw 'need mark key in mark';
  }

  Future<PeopleModel> get teacher async {
    return Get.find<FStore>().getPeople(_teacherId);
  }

  Future<PeopleModel> get student async {
    return Get.find<FStore>().getPeople(_studentId);
  }
}
