// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/person_model.dart';

class MarkModel {
  String? id;
  late String teacherId;
  late String studentId;
  late DateTime date;
  late String curriculumId;
  late int lessonOrder;
  late MarkType type;
  late String comment;
  late int mark;
  TeacherModel? _teacher;
  StudentModel? _student;

  MarkModel.empty(String teacherId, String curriculumId, int lessonOrder, DateTime date)
      : this.fromMap(null, {
          'teacher_id': teacherId,
          'date': date.toIso8601String(),
          'curriculum_id': curriculumId,
          'lesson_order': lessonOrder,
          'student_id': '',
          'type': 'regular',
          'comment': '',
          'mark': 0,
        });

  MarkModel.fromMap(this.id, Map<String, dynamic> map) {
    teacherId = map['teacher_id'] != null ? map['teacher_id'] as String : throw 'need teacher_id key in mark $id';
    studentId = map['student_id'] != null ? map['student_id'] as String : throw 'need student_id key in mark $id';
    date = map['date'] != null ? DateTime.tryParse(map['date'])! : throw 'need date key in mark $id';
    curriculumId = map['curriculum_id'] != null ? map['curriculum_id'] as String : throw 'need curriculum_id key in mark $id';
    lessonOrder = map['lesson_order'] != null ? map['lesson_order'] as int : throw 'need lesson_order key in mark $id';
    type = map['type'] != null ? typeFromString(map['type'] as String) : throw 'need type key in mark $id';
    // if (!['regular', 'test', 'exam'].contains(type)) throw 'incorrect type in mark $id';
    comment = map['comment'] != null ? map['comment'] as String : '';
    mark = map['mark'] != null ? map['mark'] as int : throw 'need mark key in mark $id';

    if (map.containsKey('teacher') && map['teacher'] is Map) {
      _teacher = TeacherModel.fromMap((map['teacher'] as Map<String, dynamic>)['_id'] as String, map['teacher'] as Map<String, dynamic>);
    }

    if (map.containsKey('student') && map['student'] is Map) {
      _student = StudentModel.fromMap((map['student'] as Map<String, dynamic>)['_id'] as String, map['student'] as Map<String, dynamic>);
    }
  }

  Map<String, dynamic> toMap({bool withId = false}) {
    var data = <String, dynamic>{
      'teacher_id': teacherId,
      'student_id': studentId,
      'date': date.toIso8601String(),
      'curriculum_id': curriculumId,
      'lesson_order': lessonOrder,
      'type': stringFromType(type),
      'comment': comment,
      'mark': mark,
    };
    if (withId) data['_id'] = id;
    return data;
  }

  Future<TeacherModel> get teacher async {
    _teacher ??= (await Get.find<ProxyStore>().getPerson(teacherId)).asTeacher;
    return _teacher!;
  }

  Future<StudentModel> get student async {
    _student ??= (await Get.find<ProxyStore>().getPerson(studentId)).asStudent;
    return _student!;
  }

  Future<void> save() async {
    id = await Get.find<ProxyStore>().saveMark(this);
  }

  Future<void> delete() async {
    await Get.find<ProxyStore>().deleteMark(this);
  }

  static MarkType typeFromString(String type) {
    switch (type) {
      case 'regular':
        return MarkType.regular;
      case 'test':
        return MarkType.test;
      case 'exam':
        return MarkType.exam;
      default:
        return MarkType.regular;
    }
  }

  static String stringFromType(MarkType type) {
    switch (type) {
      case MarkType.regular:
        return 'regular';
      case MarkType.test:
        return 'test';
      case MarkType.exam:
        return 'exam';
      default:
        return 'regular';
    }
  }

  static String localizedTypeName(S S, MarkType type) {
    switch (type) {
      case MarkType.regular:
        return S.markTypeRegular;
      case MarkType.test:
        return S.markTypeTest;
      case MarkType.exam:
        return S.markTypeExam;
      default:
        return S.markTypeRegular;
    }
  }

  @override
  String toString() {
    String res = mark.toString();
    if (type == MarkType.exam || type == MarkType.test) {
      res = res += '²';
    }
    return res;
  }
}

enum MarkType { regular, test, exam }
