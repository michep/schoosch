import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:mutex/mutex.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/utils.dart';

class DayScheduleModel {
  String? _id;
  late int day;
  late final DateTime? from;
  late final DateTime? till;
  final List<LessonModel> _lessons = [];
  bool _lessonsLoaded = false;
  final Mutex _lessonsMutex = Mutex();

  String? get id => _id;

  DayScheduleModel.fromMap(this._id, Map<String, dynamic> map) {
    day = map['day'] != null ? map['day'] as int : throw 'need day key in schedule $_id';
    if (day < 1 || day > 7) throw 'incorrect day in schedule $id';
    from = map['from'] != null ? DateTime.tryParse(map['from']) : throw 'need from key in schedule $_id';
    till = map['till'] != null ? DateTime.tryParse(map['till']) : null;
  }

  String get formatPeriod {
    return Utils.formatPeriod(from!, till);
  }
}

class ClassScheduleModel extends DayScheduleModel {
  final ClassModel _class;
  ClassModel get aclass => _class;

  ClassScheduleModel.empty(ClassModel aclass, int day)
      : this.fromMap(aclass, null, <String, dynamic>{
          'day': day,
          'from': DateTime(1900).toIso8601String(),
          'till': null,
        });

  ClassScheduleModel.fromMap(this._class, String? id, Map<String, dynamic> map) : super.fromMap(id, map);

  Future<List<LessonModel>> lessons({bool forceRefresh = false, DateTime? date, bool needsEmpty = false}) async {
    await _lessonsMutex.acquire();
    if (!_lessonsLoaded || forceRefresh) {
      _lessons.clear();
      _lessons.addAll(await Get.find<ProxyStore>().getScheduleLessons(
        _class,
        this,
        date: date,
        needsEmpty: needsEmpty,
      ));
      _lessonsLoaded = true;
    }
    _lessonsMutex.release();
    return _lessons;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['day'] = day;
    res['from'] = from;
    res['till'] = till;
    return res;
  }

  Future<ClassScheduleModel> save() async {
    var id = await Get.find<ProxyStore>().saveDaySchedule(this);
    _id ??= id;
    return this;
  }
}

class StudentScheduleModel extends ClassScheduleModel {
  final List<LessonModel> _studentLessons = [];
  bool _studentLessonsLoaded = false;
  final Mutex _studentLessonsMutex = Mutex();

  StudentScheduleModel.fromMap(ClassModel aclass, String id, Map<String, Object?> map) : super.fromMap(aclass, id, map) {
    if (map.containsKey('lesson') && map['lesson'].runtimeType == List) {
      for (var l in map['lesson'] as List) {
        _studentLessons.add(LessonModel.fromMap(aclass, this, l['_id'], l));
      }
      _studentLessonsLoaded = true;
    }
  }

  Future<List<LessonModel>> lessonsForStudent(StudentModel student, {DateTime? date}) async {
    await _studentLessonsMutex.acquire();
    if (!_studentLessonsLoaded) {
      _studentLessons.addAll(await Get.find<ProxyStore>().getScheduleLessonsForStudent(_class, this, student, date));
      _studentLessonsLoaded = true;
    }
    _studentLessonsMutex.release();
    return _studentLessons;
  }
}

class TeacherScheduleModel extends DayScheduleModel {
  late final List<LessonModel> _teacherLessons = [];

  TeacherScheduleModel.fromMap(String id, Map<String, Object?> map) : super.fromMap(id, map) {
    if (map.containsKey('lesson') && map['lesson'].runtimeType == List) {
      for (var l in map['lesson'] as List) {
        var aclass = ClassModel.fromMap(l['class']['_id'], l['class']);
        _teacherLessons.add(LessonModel.fromMap(aclass, this, l['_id'], l));
      }
    }
  }

  // void addLessons(List<LessonModel> lessons) {
  //   _teacherLessons.addAll(lessons);
  //   _teacherLessons.sort((a, b) => a.order.compareTo(b.order));
  // }

  Future<List<LessonModel>> lessonsForTeacher(TeacherModel teacher, Week week) async {
    return _teacherLessons;
  }

  // Future<List<LessonModel>> getLessons() async {
  //   return _teacherLessons;
  // }
}
