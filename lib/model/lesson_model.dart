// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/replacement_model.dart';
import 'package:schoosch/model/venue_model.dart';

enum LessonType {
  normal,
  replaced,
  replacment
}

extension LessonTypeExt on LessonType {
  static LessonType getType(int? i) {
    switch (i) {
      case 0: return LessonType.normal; 
      case 1: return LessonType.replaced;
      case 2: return LessonType.replacment;
      default: return LessonType.normal; 
    }
  }
}

class LessonModel {
  final ClassModel aclass;
  final DayScheduleModel schedule;
  String? _id;
  late int order;
  late final String _curriculumId;
  late final String _venueId;
  final Map<String, HomeworkModel?> _homeworks = {};
  final Map<String, List<MarkModel>> _marks = {};
  CurriculumModel? _curriculum;
  VenueModel? _venue;
  LessontimeModel? _lessontime;
  LessonModel? replaceLesson;
  LessonType? type;

  String? get id => _id;

  LessonModel.empty(ClassModel aclass, DayScheduleModel schedule, int order)
      : this.fromMap(aclass, schedule, null, <String, dynamic>{
          'order': order,
          'curriculum_id': '',
          'venue_id': '',
        });

  LessonModel.fromMap(this.aclass, this.schedule, this._id, Map<String, Object?> map) {
    order = map['order'] != null ? map['order'] as int : throw 'need order key in lesson $_id';
    _curriculumId = map['curriculum_id'] != null ? map['curriculum_id'] as String : throw 'need curriculum_id key in lesson $_id';
    _venueId = map['venue_id'] != null ? map['venue_id'] as String : throw 'need venue_id key in lesson $_id';
    type =  map['type'] != null ? LessonTypeExt.getType((map['type'] as int)) : LessonType.normal;
  }

  // static LessonModel fromReplacement(LessonModel lessonmodel, ReplacementModel replacement) {
  //   return LessonModel.fromMap(lessonmodel.aclass, lessonmodel.schedule, lessonmodel._id, {
  //     'order': replacement.lessonOrder,
  //     'curriculum_id': replacement.curriculum!.id,
  //     'venue_id': replacement.venue!.id,
  //     'type': 2
  //   });
  // }

  void setReplacedType() {
    type = LessonType.replaced;
  }

  Future<CurriculumModel?> get curriculum async {
    if (_curriculumId.isNotEmpty) {
      return _curriculum ??= await Get.find<FStore>().getCurriculum(_curriculumId);
    }
    return null;
  }

  Future<VenueModel?> get venue async {
    if (_venueId.isNotEmpty) {
      return _venue ??= await Get.find<FStore>().getVenue(_venueId);
    }
    return null;
  }

  Future<LessontimeModel> get lessontime async {
    return _lessontime ??= await aclass.getLessontime(order);
  }

  // Future<LessonModel?> getReplacement(DateTime date) async {
  //   if (replaceLesson == null) {
  //     var rep = await Get.find<FStore>().getLessonReplacement(aclass, date, order);
  //     if (rep != null) {
  //       replaceLesson =  LessonModel.fromMap(aclass, schedule, _id, {
  //         'order': order,
  //         'curriculum_id': rep.newCurriculum!.id,
  //         'venue_id': rep.newVenue!.id,
  //       });
  //     } else {
  //       replaceLesson = null;
  //     }
  //   }
  //   return replaceLesson;
  // }

  Future<HomeworkModel?> homeworkForStudent(StudentModel student, DateTime date) async {
    if (_homeworks[student.id] == null) {
      _homeworks[student.id!] = await Get.find<FStore>().getLessonHomeworkForStudent(schedule, (await curriculum)!, student, date);
    }
    return _homeworks[student.id!];
  }

  Future<HomeworkModel?> homeworkForClass(DateTime date) async {
    if (_homeworks['class'] == null) {
      _homeworks['class'] = await Get.find<FStore>().getLessonHomeworkForClass(schedule, (await curriculum)!, date);
    }
    return _homeworks['class'];
  }

  Future<HomeworkModel?> hasHomework(DateTime date) async {
    if (_homeworks['class'] == null) {
      _homeworks['class'] = await Get.find<FStore>().alreadyHasHomework(
        date,
        (await curriculum)!,
      );
    }
    return _homeworks['class'];
  }

  Future<Map<String, HomeworkModel?>> homeworkForStudentAndClass(
    StudentModel student,
    DateTime date, {
    bool forceRefresh = false,
  }) async {
    if (_homeworks[student.id] == null || forceRefresh) {
      _homeworks[student.id!] = await Get.find<FStore>().getLessonHomeworkForStudent(schedule, (await curriculum)!, student, date);
    }
    if (_homeworks['class'] == null || forceRefresh) {
      _homeworks['class'] = await Get.find<FStore>().getLessonHomeworkForClass(schedule, (await curriculum)!, date);
      // return [_homeworks[student.id!]!, _homeworks['class']!];
    }

    return {
      'student': _homeworks[student.id],
      'class': _homeworks['class'],
    };
  }

  Future<Map<String, dynamic>> homeworkForEveryone(DateTime date, {bool forceRefresh = false}) async {
    var studs = await aclass.students();
    for (StudentModel u in studs) {
      if (_homeworks[u.id] == null || forceRefresh) {
        _homeworks[u.id!] = await Get.find<FStore>().getLessonHomeworkForStudent(schedule, (await curriculum)!, u, date);
      }
    }
    if (_homeworks['class'] == null || forceRefresh) {
      _homeworks['class'] = await Get.find<FStore>().getLessonHomeworkForClass(schedule, (await curriculum)!, date);
      // return [_homeworks[student.id!]!, _homeworks['class']!];
    }
    return _homeworks;
  }

  // Future<List<HomeworkModel?>> homeworks(DateTime date) async {
  //   if (!_homeworksLoaded) {
  //     var hws = await Get.find<FStore>().getLessonHomeworks(schedule, (await curriculum)!, date);
  //     for(var hw in hws) {
  //       hw.studentId != null ? _homeworks[hw.studentId!] = hw : _homeworks['class'] = hw;
  //     }
  //     _homeworksLoaded = true;
  //   }
  //   return _homeworks.values.toList();
  // }

  Future<List<MarkModel>> marksForStudent(StudentModel student, DateTime date, {bool forceUpdate = false}) async {
    if (_marks[student.id] == null || forceUpdate) {
      _marks[student.id!] = await Get.find<FStore>().getLessonMarksForStudent(schedule, this, student, date);
    }

    return _marks[student.id!]!;
  }

  Future<String> marksForStudentAsString(StudentModel student, DateTime date) async {
    var ms = await marksForStudent(student, date);
    return ms.map((e) => e.mark.toString()).join('; ');
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['order'] = order;
    res['curriculum_id'] = _curriculumId;
    res['venue_id'] = _venueId;
    return res;
  }

  Future<LessonModel> save() async {
    var id = await Get.find<FStore>().saveLesson(this);
    _id ??= id;
    return this;
  }

  Future<void> delete() async {
    return Get.find<FStore>().deleteLesson(this);
  }
}

class ReplacementModel extends LessonModel {
  ReplacementModel.fromMap(ClassModel aclass, DayScheduleModel schedule, String? id, Map<String, dynamic> map): super.fromMap(aclass, schedule, id, map);
}
