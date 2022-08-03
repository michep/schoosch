import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/utils.dart';

class DayScheduleModel {
  final ClassModel _class;
  String? _id;
  late int day;
  late final DateTime? from;
  late final DateTime? till;
  final List<LessonModel> _lessons = [];
  bool _lessonsLoaded = false;

  String? get id => _id;
  ClassModel get aclass => _class;

  DayScheduleModel.empty(ClassModel aclass, int day)
      : this.fromMap(aclass, null, <String, dynamic>{
          'day': day,
          'from': Timestamp.fromDate(DateTime(1900)),
          'till': null,
        });

  DayScheduleModel.fromMap(this._class, this._id, Map<String, dynamic> map) {
    day = map['day'] != null ? map['day'] as int : throw 'need day key in schedule $_id';
    if (day < 1 || day > 7) throw 'incorrect day in schedule $id';
    from =
        map['from'] != null ? DateTime.fromMillisecondsSinceEpoch((map['from'] as Timestamp).millisecondsSinceEpoch) : throw 'need from key in schedule $_id';
    till = map['till'] != null ? DateTime.fromMillisecondsSinceEpoch((map['till'] as Timestamp).millisecondsSinceEpoch) : null;
  }

  String get formatPeriod {
    return Utils.formatPeriod(from!, till);
  }

  Future<List<LessonModel>> allLessons({bool forceRefresh = false, DateTime? date}) async {
    if (!_lessonsLoaded || forceRefresh) {
      _lessons.clear();
      _lessons.addAll(await Get.find<FStore>().getScheduleLessons(_class, this, date: date));
      _lessonsLoaded = true;
    }
    return _lessons;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['day'] = day;
    res['from'] = from;
    res['till'] = till;
    return res;
  }

  Future<DayScheduleModel> save() async {
    var id = await Get.find<FStore>().saveDaySchedule(this);
    _id ??= id;
    return this;
  }
}

class StudentScheduleModel extends DayScheduleModel {
  final List<LessonModel> _studentLessons = [];
  bool _studentLessonsLoaded = false;

  StudentScheduleModel.fromMap(ClassModel aclass, String id, Map<String, Object?> map) : super.fromMap(aclass, id, map);

  Future<List<LessonModel>> lessonsForStudent(StudentModel student, {DateTime? date}) async {
    if (!_studentLessonsLoaded) {
      _studentLessons.addAll(await Get.find<FStore>().getScheduleLessonsForStudent(_class, this, student, date));
      _studentLessonsLoaded = true;
    }
    return _studentLessons;
  }
}

class TeacherScheduleModel extends DayScheduleModel {
  late final List<LessonModel> _teacherLessons = [];

  TeacherScheduleModel.fromMap(ClassModel aclass, String id, Map<String, Object?> map) : super.fromMap(aclass, id, map);

  void addLessons(List<LessonModel> lessons) {
    _teacherLessons.addAll(lessons);
    _teacherLessons.sort((a, b) => a.order.compareTo(b.order));
  }

  Future<List<LessonModel>> lessonsForTeacher(TeacherModel teacher, Week week) async {
    return _teacherLessons;
  }

  Future<List<LessonModel>> getLessons() async {
    return _teacherLessons;
  }
}
