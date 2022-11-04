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

    if (map.containsKey('lesson') && map['lesson'] is List) {
      for (var l in map['lesson'] as List) {
        var aclass = ClassModel.fromMap(l['class']['_id'], l['class']);
        _lessons.add(LessonModel.fromMap(aclass, this, l['_id'], l));
      }
      _lessonsLoaded = true;
    }
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

  Future<List<LessonModel>> classLessons({bool forceRefresh = false, DateTime? date, bool needsEmpty = false}) async {
    await _lessonsMutex.acquire();
    if (!_lessonsLoaded) {
      _lessons.addAll(await Get.find<ProxyStore>().getScheduleLessons(_class, this, date: date, needsEmpty: needsEmpty));
      _lessonsLoaded = true;
    }
    _lessonsMutex.release();
    return _lessons;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['day'] = day;
    res['from'] = from!.toIso8601String();
    res['till'] = till?.toIso8601String();
    return res;
  }

  Future<ClassScheduleModel> save() async {
    var id = await Get.find<ProxyStore>().saveDaySchedule(this);
    _id ??= id;
    return this;
  }
}

class StudentScheduleModel extends ClassScheduleModel {
  StudentScheduleModel.fromMap(ClassModel aclass, String id, Map<String, Object?> map) : super.fromMap(aclass, id, map);

  Future<List<LessonModel>> studentLessons(StudentModel student, {DateTime? date}) async {
    await _lessonsMutex.acquire();
    if (!_lessonsLoaded) {
      _lessons.addAll(await Get.find<ProxyStore>().getScheduleLessonsForStudent(_class, this, student, date));
      _lessonsLoaded = true;
    }
    _lessonsMutex.release();
    return _lessons;
  }
}

class TeacherScheduleModel extends DayScheduleModel {
  TeacherScheduleModel.fromMap(String id, Map<String, Object?> map) : super.fromMap(id, map);

  Future<List<LessonModel>> teacherLessons(TeacherModel teacher, Week week) async {
    return _lessons;
  }
}
