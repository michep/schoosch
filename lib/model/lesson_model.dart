// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:schoosch/controller/mongo_controller.dart';
import 'package:schoosch/model/absence_model.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';

enum LessonType {
  normal,
  replaced,
  replacment,
  empty,
}

extension LessonTypeExt on LessonType {
  static LessonType getType(int? i) {
    switch (i) {
      case 0:
        return LessonType.normal;
      case 1:
        return LessonType.replaced;
      case 2:
        return LessonType.replacment;
      case 3:
        return LessonType.empty;
      default:
        return LessonType.normal;
    }
  }
}

class LessonModel {
  final ClassModel aclass;
  final DayScheduleModel schedule;
  ObjectId? id;
  late int order;
  late final ObjectId? curriculumId;
  late final ObjectId? venueId;
  final Map<String, HomeworkModel?> _homeworksThisLesson = {};
  final Map<String, HomeworkModel?> _homeworksNextLesson = {};
  final Map<String, List<MarkModel>> marks = {};
  CurriculumModel? _curriculum;
  VenueModel? _venue;
  LessontimeModel? _lessontime;
  LessonModel? replaceLesson;
  LessonType? type;

  LessonModel.empty(ClassModel aclass, DayScheduleModel schedule, int order)
      : this.fromMap(aclass, schedule, null, <String, dynamic>{
          'order': order,
          'curriculum_id': '',
          'venue_id': '',
        });

  LessonModel.fromMap(this.aclass, this.schedule, this.id, Map<String, Object?> map) {
    type = map['type'] != null ? LessonTypeExt.getType((map['type'] as int)) : LessonType.normal;
    order = map['order'] != null ? map['order'] as int : throw 'need order key in lesson $id';
    curriculumId = map['curriculum_id'] != null
        ? map['curriculum_id'] as ObjectId
        : type == LessonType.empty
            ? null
            : throw 'need curriculum_id key in lesson $id';
    venueId = map['venue_id'] != null
        ? map['venue_id'] as ObjectId
        : type == LessonType.empty
            ? null
            : throw 'need venue_id key in lesson $id';
  }

  void setReplacedType() {
    type = LessonType.replaced;
  }

  Future<CurriculumModel?> get curriculum async {
    if (curriculumId == null) return null;
    return _curriculum ??= await Get.find<MStore>().getCurriculum(curriculumId!);
  }

  Future<VenueModel?> get venue async {
    if (venueId == null) return null;
    return _venue ??= await Get.find<MStore>().getVenue(venueId!);
  }

  Future<LessontimeModel> get lessontime async {
    return _lessontime ??= await aclass.getLessontime(order);
  }

  Future<HomeworkModel?> homeworkThisLessonForClass(DateTime date, {bool forceRefresh = false}) async {
    if (_homeworksThisLesson['class'] == null || forceRefresh) {
      _homeworksThisLesson['class'] = await Get.find<MStore>().getHomeworkForClassBeforeDate(aclass, (await curriculum)!, date);
    }
    return _homeworksThisLesson['class'];
  }

  Future<HomeworkModel?> homeworkThisLessonForStudent(StudentModel student, DateTime date, {bool forceRefresh = false}) async {
    if (_homeworksThisLesson[student.id!.toHexString()] == null || forceRefresh) {
      _homeworksThisLesson[student.id!.toHexString()] = await Get.find<MStore>().getHomeworkForStudentBeforeDate(aclass, (await curriculum)!, student, date);
    }
    return _homeworksThisLesson[student.id!];
  }

  Future<Map<String, HomeworkModel?>> homeworkThisLessonForClassAndStudent(StudentModel student, DateTime date, {bool forceRefresh = false}) async {
    if (_homeworksThisLesson[student.id!.toHexString()] == null || forceRefresh) {
      _homeworksThisLesson[student.id!.toHexString()] = await Get.find<MStore>().getHomeworkForStudentBeforeDate(aclass, (await curriculum)!, student, date);
    }
    if (_homeworksThisLesson['class'] == null || forceRefresh) {
      _homeworksThisLesson['class'] = await Get.find<MStore>().getHomeworkForClassBeforeDate(aclass, (await curriculum)!, date);
    }

    return {
      'student': _homeworksThisLesson[student.id],
      'class': _homeworksThisLesson['class'],
    };
  }

  Future<Map<String, HomeworkModel?>> homeworkThisLessonForClassAndAllStudents(DateTime date, {bool forceRefresh = false}) async {
    var studs = await aclass.students();
    for (StudentModel stud in studs) {
      if (_homeworksThisLesson[stud.id!.toHexString()] == null || forceRefresh) {
        _homeworksThisLesson[stud.id!.toHexString()] = await Get.find<MStore>().getHomeworkForStudentBeforeDate(aclass, (await curriculum)!, stud, date);
      }
    }
    if (_homeworksThisLesson['class'] == null || forceRefresh) {
      _homeworksThisLesson['class'] = await Get.find<MStore>().getHomeworkForClassBeforeDate(aclass, (await curriculum)!, date);
    }
    return _homeworksThisLesson;
  }

  Future<HomeworkModel?> homeworOnDateForClass(DateTime date, {bool forceRefresh = false}) async {
    if (_homeworksNextLesson['class'] == null || forceRefresh) {
      _homeworksNextLesson['class'] = await Get.find<MStore>().getHomeworkForClassOnDate(aclass, (await curriculum)!, date);
    }
    return _homeworksNextLesson['class'];
  }

  Future<HomeworkModel?> homeworkOnDateForStudent(StudentModel student, DateTime date, {bool forceRefresh = false}) async {
    if (_homeworksNextLesson['class'] == null || forceRefresh) {
      _homeworksNextLesson['class'] = await Get.find<MStore>().getHomeworkForStudentOnDate(aclass, (await curriculum)!, student, date);
    }
    return _homeworksNextLesson['class'];
  }

  Future<Map<String, HomeworkModel?>> homeworkOnDateForClassAndStudent(StudentModel student, DateTime date, {bool forceRefresh = false}) async {
    if (_homeworksNextLesson[student.id!.toHexString()] == null || forceRefresh) {
      _homeworksNextLesson[student.id!.toHexString()] = await Get.find<MStore>().getHomeworkForStudentOnDate(aclass, (await curriculum)!, student, date);
    }
    if (_homeworksNextLesson['class'] == null || forceRefresh) {
      _homeworksNextLesson['class'] = await Get.find<MStore>().getHomeworkForClassOnDate(aclass, (await curriculum)!, date);
    }

    return {
      'student': _homeworksNextLesson[student.id],
      'class': _homeworksNextLesson['class'],
    };
  }

  Future<Map<String, HomeworkModel?>> homeworkOnDateForClassAndAllStudents(DateTime date, {bool forceRefresh = false}) async {
    var studs = await aclass.students();
    for (StudentModel stud in studs) {
      if (_homeworksNextLesson[stud.id!.toHexString()] == null || forceRefresh) {
        _homeworksNextLesson[stud.id!.toHexString()] = await Get.find<MStore>().getHomeworkForStudentOnDate(aclass, (await curriculum)!, stud, date);
      }
    }
    if (_homeworksNextLesson['class'] == null || forceRefresh) {
      _homeworksNextLesson['class'] = await Get.find<MStore>().getHomeworkForClassOnDate(aclass, (await curriculum)!, date);
    }
    return _homeworksNextLesson;
  }

  Future<Map<String, List<MarkModel>>> getAllMarks(DateTime date) async {
    Map<String, List<MarkModel>> res = {};
    var mrks = await Get.find<MStore>().getAllLessonMarks(this, date);
    for (var mrk in mrks) {
      if (res[mrk.studentId.toHexString()] == null) {
        res[mrk.studentId.toHexString()] = [mrk];
      } else {
        res[mrk.studentId.toHexString()]!.add(mrk);
      }
    }
    return res;
  }

  Future<List<MarkModel>> marksForStudent(StudentModel student, DateTime date, {bool forceRefresh = false}) async {
    if (marks[student.id!.toHexString()] == null || forceRefresh) {
      marks[student.id!.toHexString()] = await Get.find<MStore>().getStudentLessonMarks(this, student, date);
    }

    return marks[student.id!]!;
  }

  Future<void> saveMark(MarkModel mark) async {
    mark.save();
  }

  Future<String> marksForStudentAsString(StudentModel student, DateTime date) async {
    var ms = await marksForStudent(student, date, forceRefresh: true);
    return ms.map((e) => e.mark.toString()).join('; ');
  }

  Future<List<AbsenceModel>> getAllAbsences(DateTime date, {bool forceUpdate = false}) async {
    return Get.find<MStore>().getAllAbsences(this, date);
  }

  Future<void> createAbsence(AbsenceModel absence) async {
    return Get.find<MStore>().createAbsence(this, absence);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['order'] = order;
    res['curriculum_id'] = curriculumId;
    res['venue_id'] = venueId;
    return res;
  }

  Future<LessonModel> save() async {
    var nid = await Get.find<MStore>().saveLesson(this);
    id ??= nid;
    return this;
  }

  Future<void> delete() async {
    return Get.find<MStore>().deleteLesson(this);
  }
}

class ReplacementModel extends LessonModel {
  ReplacementModel.fromMap(ClassModel aclass, DayScheduleModel schedule, ObjectId? id, Map<String, dynamic> map) : super.fromMap(aclass, schedule, id, map) {
    type = LessonType.replacment;
  }
}

class EmptyLesson extends LessonModel {
  EmptyLesson.fromMap(ClassModel aclass, DayScheduleModel schedule, ObjectId? id, int order)
      : super.fromMap(aclass, schedule, id, {
          'order': order,
          'curriculum_id': null,
          'venue_id': null,
          'type': 3,
        });

  void setAsEmpty() {
    type == LessonType.empty;
  }
}
