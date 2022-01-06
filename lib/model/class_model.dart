import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/daylessontime_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';

class ClassModel {
  String? _id;
  late final String name;
  late final int grade;
  late final String _masterId;
  late final String _dayLessontimeId;
  final List<String> _studentIds = [];
  final List<StudentModel> _students = [];
  bool _studentsLoaded = false;
  final List<LessontimeModel> _lessontimes = [];
  bool _lessontimesLoaded = false;
  TeacherModel? _master;
  final Map<Week, List<StudentScheduleModel>> _weekSchedules = {};
  final Map<int, List<StudentScheduleModel>> _daySchedules = {};

  String? get id => _id;

  ClassModel.empty()
      : this.fromMap(null, <String, dynamic>{
          'name': '',
          'grade': 0,
          'master_id': '',
          'lessontime_id': '',
          'student_ids': <String>[],
        });

  ClassModel.fromMap(this._id, Map<String, dynamic> map) {
    name = map['name'] != null ? map['name'] as String : throw 'need name key in class $_id';
    grade = map['grade'] != null ? map['grade'] as int : throw 'need grade key in class $_id';
    _dayLessontimeId = map['lessontime_id'] != null ? map['lessontime_id'] as String : throw 'need lessontime_id key in class $_id';
    _masterId = map['master_id'] != null ? map['master_id'] as String : throw 'need master_id key in class $_id';
    map['student_ids'] != null ? _studentIds.addAll((map['student_ids'] as List<dynamic>).map((e) => e as String)) : null;
  }

  Future<TeacherModel?> get master async {
    if (_masterId.isEmpty) return null;
    if (_master == null) {
      var store = Get.find<FStore>();
      _master = (await store.getPerson(_masterId)).asTeacher;
    }
    return _master!;
  }

  Future<List<StudentScheduleModel>> getSchedulesWeek(Week week) async {
    return _weekSchedules[week] ??= await Get.find<FStore>().getClassWeekSchedule(this, week);
  }

  Future<List<StudentScheduleModel>> getSchedulesDay(int day, {bool forceRefresh = false}) async {
    if (_daySchedules[day] == null || forceRefresh) {
      _daySchedules[day] = await Get.find<FStore>().getClassDaySchedule(this, day);
    }
    return _daySchedules[day]!;
  }

  Future<List<LessontimeModel?>?> getLessontimes() async {
    if (_dayLessontimeId.isEmpty) return null;
    if (!_lessontimesLoaded) {
      _lessontimes.addAll(await Get.find<FStore>().getLessontime(_dayLessontimeId)); //TODO: fallboack to default lessontimes?
      _lessontimesLoaded = true;
    }
    return _lessontimes;
  }

  Future<LessontimeModel> getLessontime(int n) async {
    if (!_lessontimesLoaded) await getLessontimes();
    return _lessontimes[n - 1];
  }

  Future<DayLessontimeModel?> getDayLessontime() async {
    if (_dayLessontimeId.isEmpty) return null;
    return Get.find<FStore>().getDayLessontime(_dayLessontimeId);
  }

  Future<Map<TeacherModel, List<String>>> get teachers async {
    return Get.find<FStore>().getClassTeachers(this);
  }

  Future<List<StudentModel>> students({forceRefresh = false}) async {
    if (!_studentsLoaded || forceRefresh) {
      _students.clear();
      _students.addAll((await Get.find<FStore>().getPeopleByIds(_studentIds)).map((e) => e.asStudent!));
      _studentsLoaded = true;
    }
    return _students;
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
    var id = await Get.find<FStore>().saveClass(this);
    _id ??= id;
    return this;
  }
}
