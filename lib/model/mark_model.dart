// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/person_model.dart';

class MarkModel {
  String? id;
  late String teacherId;
  late String studentId;
  late String curriculumId;
  late String comment;
  late int mark;
  StudentModel? _student;
  TeacherModel? _teacher;
  CurriculumModel? _curriculum;

  MarkModel.fromMap(this.id, Map<String, dynamic> map) {
    teacherId = map['teacher_id'] != null ? map['teacher_id'] as String : throw 'need teacher_id key in mark $id';
    studentId = map['student_id'] != null ? map['student_id'] as String : throw 'need student_id key in mark $id';
    curriculumId = map['curriculum_id'] != null ? map['curriculum_id'] as String : throw 'need curriculum_id key in mark $id';
    comment = map['comment'] != null ? map['comment'] as String : '';
    mark = map['mark'] != null ? map['mark'] as int : throw 'need mark key in mark $id';

    if (map.containsKey('teacher') && map['teacher'] is Map) {
      _teacher = TeacherModel.fromMap((map['teacher'] as Map<String, dynamic>)['_id'] as String, map['teacher'] as Map<String, dynamic>);
    }

    if (map.containsKey('student') && map['student'] is Map) {
      _student = StudentModel.fromMap((map['student'] as Map<String, dynamic>)['_id'] as String, map['student'] as Map<String, dynamic>);
    }
  }

  Future<TeacherModel> get teacher async {
    _teacher ??= (await Get.find<ProxyStore>().getPerson(teacherId)).asTeacher;
    return _teacher!;
  }

  Future<StudentModel> get student async {
    _student ??= (await Get.find<ProxyStore>().getPerson(studentId)).asStudent;
    return _student!;
  }

  Future<CurriculumModel> get curriculum async {
    _curriculum ??= (await Get.find<ProxyStore>().getCurriculum(curriculumId));
    return _curriculum!;
  }

  Future<void> delete() async {
    await Get.find<ProxyStore>().deleteMark(this);
  }

  @override
  String toString() {
    return mark.toString();
  }
}

class LessonMarkModel extends MarkModel {
  late DateTime date;
  late int lessonOrder;
  late MarkType type;

  LessonMarkModel.empty(String teacherId, String curriculumId, int lessonOrder, DateTime date)
      : this.fromMap(null, {
          'teacher_id': teacherId,
          'student_id': '',
          'curriculum_id': curriculumId,
          'date': date.toIso8601String(),
          'lesson_order': lessonOrder,
          'type': 'regular',
          'comment': '',
          'mark': 0,
        });

  LessonMarkModel.fromMap(String? id, Map<String, dynamic> map) : super.fromMap(id, map) {
    date = map['date'] != null ? DateTime.tryParse(map['date'])! : throw 'need date key in mark $id';
    lessonOrder = map['lesson_order'] != null ? map['lesson_order'] as int : throw 'need lesson_order key in mark $id';
    type = map['type'] != null ? MarkTypeExt._parse(map['type'] as String) : throw 'need type key in mark $id';

    if (map.containsKey('curriculum') && map['curriculum'] is Map) {
      _curriculum = CurriculumModel.fromMap((map['curriculum'] as Map<String, dynamic>)['_id'] as String, map['curriculum'] as Map<String, dynamic>);
    }
  }

  Map<String, dynamic> toMap({bool withId = false}) {
    var data = <String, dynamic>{
      'teacher_id': teacherId,
      'student_id': studentId,
      'curriculum_id': curriculumId,
      'date': date.toIso8601String(),
      'lesson_order': lessonOrder,
      'type': type.nameString,
      'comment': comment,
      'mark': mark,
    };
    if (withId) data['_id'] = id;
    return data;
  }

  Future<void> save() async {
    id = await Get.find<ProxyStore>().saveLessonMark(this);
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

enum MarkType {
  regular,
  test,
  exam,
}

extension MarkTypeExt on MarkType {
  static const _regular = 'regular';
  static const _test = 'test';
  static const _exam = 'exam';

  static MarkType _parse(String value) {
    switch (value) {
      case _regular:
        return MarkType.regular;
      case _test:
        return MarkType.test;
      case _exam:
        return MarkType.exam;
      default:
        throw 'unkown type';
    }
  }

  String get nameString {
    switch (this) {
      case MarkType.regular:
        return _regular;
      case MarkType.test:
        return _test;
      case MarkType.exam:
        return _exam;
    }
  }

  String localizedName(S S) {
    switch (this) {
      case MarkType.regular:
        return S.markTypeRegular;
      case MarkType.test:
        return S.markTypeTest;
      case MarkType.exam:
        return S.markTypeExam;
    }
  }
}

class PeriodMarkModel extends MarkModel {
  late String periodId;
  final String type = 'period';

  PeriodMarkModel.fromMap(String? id, Map<String, dynamic> map) : super.fromMap(id, map) {
    periodId = map['period_id'] != null ? map['period_id'] as String : throw 'need period_id key in mark $id';
  }

  PeriodMarkModel.empty(String teacherId, String curriculumId, String periodId)
      : this.fromMap(null, {
          'teacher_id': teacherId,
          'student_id': '',
          'curriculum_id': curriculumId,
          'period_id': periodId,
          'type': 'period',
          'comment': '',
          'mark': 0,
        });

  Map<String, dynamic> toMap({bool withId = false}) {
    var data = <String, dynamic>{
      'teacher_id': teacherId,
      'student_id': studentId,
      'curriculum_id': curriculumId,
      'period_id': periodId,
      'type': type,
      'comment': comment,
      'mark': mark,
    };
    if (withId) data['_id'] = id;
    return data;
  }

  Future<void> save() async {
    id = await Get.find<ProxyStore>().savePeriodMark(this);
  }
}
