import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/person_model.dart';

class ReplacementModel {
  late final String? id;
  late final DateTime? date;
  late final int? lessonOrder;
  late final PersonModel? newTeacher;
  late final CurriculumModel? newCurriculum;

  ReplacementModel.fromMap(this.id, Map<String, dynamic> map) {
    date = map['date'] != null ? DateTime.fromMillisecondsSinceEpoch((map['date'] as Timestamp).millisecondsSinceEpoch) : throw '';
    lessonOrder = map['lesson_order'] != null ? map['lesson_order'] as int : throw '';
    newTeacher = map['new_teacher'] ?? null;
    newCurriculum = map['new_curriculum'] ?? null;
  }
}
