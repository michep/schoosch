import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart' as isoweek;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:mutex/mutex.dart';
import 'package:schoosch/controller/mongo_controller.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/daylessontime_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';

class ClassModel {
  ObjectId? id;
  late final String name;
  late final int grade;
  late final ObjectId _masterId;
  late final ObjectId _dayLessontimeId;
  final List<ObjectId> _studentIds = [];
  final List<StudentModel> _students = [];
  bool _studentsLoaded = false;
  final Mutex _studentsMutex = Mutex();
  final List<LessontimeModel> _lessontimes = [];
  bool _lessontimesLoaded = false;
  final Mutex __lessontimesMutex = Mutex();
  TeacherModel? _master;
  final Map<isoweek.Week, List<StudentScheduleModel>> _weekSchedules = {};
  final Map<int, List<StudentScheduleModel>> _daySchedules = {};
  final List<CurriculumModel> _curriculums = [];
  bool _curriculumsLoaded = false;
  final Mutex _curriculumsMutex = Mutex();

  ClassModel.empty()
      : this.fromMap(null, <String, dynamic>{
          'name': '',
          'grade': 0,
          'master_id': ObjectId().empty(),
          'lessontime_id': ObjectId().empty(),
          'student_ids': <ObjectId>[],
        });

  ClassModel.fromMap(this.id, Map<String, dynamic> map) {
    name = map['name'] != null ? map['name'] as String : throw 'need name key in class $id';
    grade = map['grade'] != null ? map['grade'] as int : throw 'need grade key in class $id';
    _dayLessontimeId = map['lessontime_id'] != null ? map['lessontime_id'] as ObjectId : throw 'need lessontime_id key in class $id';
    _masterId = map['master_id'] != null ? map['master_id'] as ObjectId : throw 'need master_id key in class $id';
    map['student_ids'] != null ? _studentIds.addAll((map['student_ids'] as List).map((e) => e as ObjectId)) : null;
  }

  @override
  operator ==(other) {
    if (other is ClassModel) {
      return id == other.id;
    }
    return this == other;
  }

  @override
  int get hashCode => Object.hash(id, '');

  @override
  String toString() {
    return name;
  }

  Future<TeacherModel?> get master async {
    if (_masterId.isEmpty) return null;
    if (_master == null) {
      var store = Get.find<MStore>();
      _master = (await store.getPerson(_masterId)).asTeacher;
    }
    return _master!;
  }

  Future<List<StudentScheduleModel>> getSchedulesWeek(isoweek.Week week) async {
    return _weekSchedules[week] ??= await Get.find<MStore>().getClassWeekSchedule(this, week);
  }

  Future<void> createReplacement(Map<String, dynamic> map) async {
    return await Get.find<MStore>().createReplacement(this, map);
  }

  Future<List<StudentScheduleModel>> getSchedulesDay(int day, {bool forceRefresh = false}) async {
    if (_daySchedules[day] == null || forceRefresh) {
      _daySchedules[day] = await Get.find<MStore>().getClassDaySchedule(this, day);
    }
    return _daySchedules[day]!;
  }

  Future<LessontimeModel> getLessontime(int n) async {
    await __lessontimesMutex.acquire();
    if (!_lessontimesLoaded) {
      _lessontimes.addAll(
        await Get.find<MStore>().getLessontimes(_dayLessontimeId),
      );
      _lessontimes.sort((a, b) => a.order.compareTo(b.order));
      _lessontimesLoaded = true; //TODO: fallboack to default lessontimes?
    }
    __lessontimesMutex.release();
    return _lessontimes[n - 1];
  }

  Future<DayLessontimeModel?> getDayLessontime() async {
    if (_dayLessontimeId.isEmpty) return null;
    return Get.find<MStore>().getDayLessontime(_dayLessontimeId);
  }

  Future<Map<TeacherModel, List<String>>> get teachers async {
    return Get.find<MStore>().getClassTeachers(this);
  }

  Future<List<StudentModel>> students({forceRefresh = false}) async {
    await _studentsMutex.acquire();
    if (!_studentsLoaded || forceRefresh) {
      _students.clear();
      _students.addAll((await Get.find<MStore>().getPeopleByIds(_studentIds)).map((e) => e.asStudent!));
      _studentsLoaded = true;
    }
    _studentsMutex.release();
    return _students;
  }

  Future<List<int>> freeLessonsForDate(DateTime date) async {
    return await Get.find<MStore>().getFreeLessonsOnDay(this, date);
  }

  // Future<Set<CurriculumModel>> getUniqueCurriculums({bool forceRefresh = false}) async {
  //   if(allCurriculums.isEmpty || forceRefresh) {
  //     var weekschedules = await getSchedulesWeek(Week.current());
  //     for(var sched in weekschedules) {
  //       var les = await sched.allLessons();
  //       for(var l in les) {
  //         var cur = await l.curriculum;
  //         allCurriculums.add(cur!);
  //       }
  //     }
  //   }
  //   return allCurriculums;
  // }

  Future<List<CurriculumModel>> curriculums({bool forceRefresh = false}) async {
    await _curriculumsMutex.acquire();
    if (!_curriculumsLoaded || forceRefresh) {
      _curriculums.clear();
      _curriculums.addAll(await Get.find<MStore>().getClassCurriculums(this));
      _curriculumsLoaded = true;
    }
    _curriculumsMutex.release();
    return _curriculums;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['name'] = name;
    res['grade'] = grade;
    res['master_id'] = _masterId;
    res['student_ids'] = _studentIds;
    res['lessontime_id'] = _dayLessontimeId;
    return res;
  }

  Future<ClassModel> save() async {
    var nid = await Get.find<MStore>().saveClass(this);
    id ??= nid;
    return this;
  }
}
