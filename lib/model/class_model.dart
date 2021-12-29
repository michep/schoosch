import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/daylessontime_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';

class ClassModel {
  late String? id;
  late String name;
  late int grade;
  late String masterId;
  late String dayLessontimeId;
  final Map<Week, List<StudentScheduleModel>> _schedule = {};
  final List<String> studentIds = [];
  final List<StudentModel> _students = [];
  final List<LessontimeModel> _lessontimes = [];
  bool _lessontimesLoaded = false;
  bool _studentsLoaded = false;
  PersonModel? _master;

  ClassModel.empty()
      : this.fromMap(null, <String, dynamic>{
          'name': '',
          'grade': null,
          'master_id': '',
          'lessontime_id': '',
          'student_ids': <String>[],
        });

  ClassModel.fromMap(this.id, Map<String, dynamic> map) {
    name = map['name'] != null ? map['name'] as String : throw 'need name key in class $id';
    grade = map['grade'] != null ? map['grade'] as int : throw 'need grade key in class $id';
    dayLessontimeId = map['lessontime_id'] != null ? map['lessontime_id'] as String : throw 'need lessontime_id key in class $id';
    masterId = map['master_id'] != null ? map['master_id'] as String : throw 'need master_id key in class $id';
    map['student_ids'] != null ? studentIds.addAll((map['student_ids'] as List<dynamic>).map((e) => e as String)) : null;
  }

  Future<TeacherModel?> get master async {
    if (_master == null && masterId != null) {
      var store = Get.find<FStore>();
      _master = await store.getPerson(masterId);
    }
    return _master!.asTeacher;
  }

  Future<List<StudentScheduleModel>> getSchedulesWeek(Week week) async {
    return _schedule[week] ??= await Get.find<FStore>().getClassWeekSchedule(this, week);
  }

  Future<List<LessontimeModel>> getLessontimes() async {
    if (!_lessontimesLoaded) {
      _lessontimes.addAll(await Get.find<FStore>().getLessontime(dayLessontimeId)); //TODO: fallboack to default lessontimes?
      _lessontimesLoaded = true;
    }
    return _lessontimes;
  }

  Future<LessontimeModel> getLessontime(int n) async {
    if (!_lessontimesLoaded) await getLessontimes();
    return _lessontimes[n - 1];
  }

  Future<DayLessontimeModel> getDayLessontime() async {
    return Get.find<FStore>().getDayLessontime(dayLessontimeId);
  }

  Future<Map<TeacherModel, List<String>>> get teachers async {
    return Get.find<FStore>().getClassTeachers(this);
  }

  Future<List<StudentModel>> get students async {
    if (!_studentsLoaded) {
      _students.addAll((await Get.find<FStore>().getPeopleByIds(studentIds)).map((e) => e.asStudent!));
      _studentsLoaded = true;
    }
    return _students;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['name'] = name;
    res['grade'] = grade;
    res['master_id'] = masterId;
    res['student_ids'] = studentIds;
    res['lessontime_id'] = dayLessontimeId;
    return res;
  }

  Future<void> save() async {
    return Get.find<FStore>().saveClass(this);
  }
}
