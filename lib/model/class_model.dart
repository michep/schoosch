import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/daylessontime_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/model/status_enum.dart';

class ClassModel {
  String? _id;
  late final String name;
  late final int grade;
  late final String _masterId;
  late final String _dayLessontimeId;
  late final StatusModel status;

  final List<String> _studentIds = [];
  final List<StudentModel> _students = [];
  bool _studentsLoaded = false;
  final List<LessontimeModel> _lessontimes = [];
  bool _lessontimesLoaded = false;
  TeacherModel? _master;
  final Map<Week, List<ClassScheduleModel>> _weekClassSchedules = {};
  final Map<Week, List<StudentScheduleModel>> _weekStudentSchedules = {};
  final Map<int, List<StudentScheduleModel>> _daySchedules = {};
  final Map<String, List<CurriculumModel>> _curriculums = {};

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
    status = map['status'] != null ? StatusModel.parse(map['status']) : StatusModel.active;
    _dayLessontimeId = map['lessontime_id'] != null ? map['lessontime_id'] as String : throw 'need lessontime_id key in class $_id';
    _masterId = map['master_id'] != null ? map['master_id'] as String : throw 'need master_id key in class $_id';
    map['student_ids'] != null ? _studentIds.addAll((map['student_ids'] as List<dynamic>).map((e) => e as String)) : null;

    if (map.containsKey('master') && map['master'] is Map) {
      _master = TeacherModel.fromMap((map['master'] as Map<String, dynamic>)['_id'] as String, map['master'] as Map<String, dynamic>);
    }

    if (map.containsKey('lessontime') && map['lessontime'] is Map) {
      var times = DayLessontimeModel.fromMap((map['lessontime'] as Map<String, dynamic>)['_id'] as String, map['lessontime'] as Map<String, dynamic>);
      _lessontimes.addAll(times.lessontimesSync!);
    }

    if (map.containsKey('student') && map['student'] is List) {
      var s = (map['student'] as List).map<StudentModel>((e) {
        var data = e as Map<String, dynamic>;
        return StudentModel.fromMap(data['_id'], data);
      }).toList();
      _students.addAll(s);
      _studentsLoaded = true;
    }
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
    _master ??= (await Get.find<ProxyStore>().getPerson(_masterId)).asTeacher;
    return _master!;
  }

  Future<List<ClassScheduleModel>> getClassSchedulesWeek(Week week, {bool forceRefresh = false}) async {
    if (_weekClassSchedules[week] == null || forceRefresh) {
      _weekClassSchedules[week] = await Get.find<ProxyStore>().getClassWeekSchedule(this, week);
    }
    return _weekClassSchedules[week]!;
  }

  Future<List<StudentScheduleModel>> getStudentSchedulesWeek(Week week, StudentModel student, {bool forceRefresh = false}) async {
    if (_weekStudentSchedules[week] == null || forceRefresh) {
      _weekStudentSchedules[week] = await Get.find<ProxyStore>().getStudentWeekSchedule(this, week, student);
    }
    return _weekStudentSchedules[week]!;
  }

  Future<void> createReplacement(Map<String, dynamic> map) async {
    return await Get.find<ProxyStore>().createReplacement(this, map);
  }

  Future<List<StudentScheduleModel>> getSchedulesDay(int day, {bool forceRefresh = false}) async {
    if (_daySchedules[day] == null || forceRefresh) {
      _daySchedules[day] = await Get.find<ProxyStore>().getClassDaySchedule(this, day);
    }
    return _daySchedules[day]!;
  }

  Future<LessontimeModel> getLessontime(int n) async {
    if (!_lessontimesLoaded) {
      _lessontimes.addAll(
        await Get.find<ProxyStore>().getLessontimes(_dayLessontimeId),
      );
      _lessontimes.sort((a, b) => a.order.compareTo(b.order));
      _lessontimesLoaded = true; //TODO: fallback to default lessontimes?
    }
    return _lessontimes[n - 1];
  }

  Future<DayLessontimeModel?> getDayLessontime() async {
    if (_dayLessontimeId.isEmpty) return null;
    return Get.find<ProxyStore>().getDayLessontime(_dayLessontimeId);
  }

  Future<Map<TeacherModel, List<String>>> get teachers async {
    return Get.find<ProxyStore>().getClassTeachers(this);
  }

  Future<List<StudentModel>> students({forceRefresh = false}) async {
    if (!_studentsLoaded || forceRefresh) {
      _students.clear();
      _students.addAll((await Get.find<ProxyStore>().getPeopleByIds(_studentIds)).map((e) => e.asStudent!));
      _studentsLoaded = true;
    }
    return _students;
  }

  // Future<List<int>> freeLessonsForDate(DateTime date) async {
  //   return await Get.find<MStore>().getFreeLessonsOnDay(this, date);
  // }

  Future<List<CurriculumModel>> curriculums(StudyPeriodModel period, {bool forceRefresh = false}) async {
    if (forceRefresh || !_curriculums.containsKey(period.id!)) {
      _curriculums[period.id!] = await Get.find<ProxyStore>().getClassCurriculums(this, period);
    }
    return _curriculums[period.id!]!;
  }

  Map<String, dynamic> toMap({bool withId = false}) {
    Map<String, dynamic> res = {};
    if (withId) res['_id'] = id;
    res['name'] = name;
    res['grade'] = grade;
    res['status'] = status.nameInt;
    res['master_id'] = _masterId;
    res['student_ids'] = _studentIds;
    res['lessontime_id'] = _dayLessontimeId;
    return res;
  }

  Future<ClassModel> save() async {
    var id = await Get.find<ProxyStore>().saveClass(this);
    _id ??= id;
    return this;
  }

  Future<void> delete() async {
    // await Get.find<ProxyStore>().deleteClass(this);
    throw UnsupportedError;
  }
}
