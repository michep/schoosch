import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/people_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';

class ClassModel {
  final String id;
  late final String name;
  late final int grade;
  late final String? _masterId;
  late final String _lessontimeId;
  final Map<Week, List<DayScheduleModel>> _schedule = {};
  final List<String> _studentIds = [];
  final List<PeopleModel> _students = [];
  final List<LessontimeModel> _lessontimes = [];
  bool _lessontimesLoaded = false;
  PeopleModel? _master;

  ClassModel.fromMap(this.id, Map<String, dynamic> map) {
    name = map['name'] != null ? map['name'] as String : throw 'need name key in class';
    grade = map['grade'] != null ? map['grade'] as int : throw 'need grade key in class';
    _lessontimeId = map['lessontime_id'] != null ? map['lessontime_id'] as String : throw 'need lessontime_id key in class';
    _masterId = map['master_id'] != null ? map['master_id'] as String : null;
    map['student_ids'] != null ? _studentIds.addAll((map['student_ids'] as List<dynamic>).map((e) => e as String)) : null;
  }

  Future<PeopleModel?> get master async {
    if (_master == null && _masterId != null) {
      var store = Get.find<FStore>();
      _master = await store.getPeopleModel(_masterId!);
    }
    return _master;
  }

  Future<List<DayScheduleModel>> getSchedulesWeek(Week week) async {
    return _schedule[week] ??= await Get.find<FStore>().getSchedulesModelClass(this, week);
  }

  Future<List<LessontimeModel>> getLessontimes() async {
    if (!_lessontimesLoaded) {
      _lessontimes.addAll(await Get.find<FStore>().getClassLessontimeModel(_lessontimeId)); //TODO: fallboack to default lessontimes?
      _lessontimesLoaded = true;
    }
    return _lessontimes;
  }

  Future<LessontimeModel> getLessontime(int n) async {
    if (!_lessontimesLoaded) await getLessontimes();
    return _lessontimes[n - 1];
  }

  static Future<List<ClassModel>> allClasses() {
    return Get.find<FStore>().getClassesModel();
  }

  static Future<ClassModel> currentStudentClass() async {
    return Get.find<FStore>().currentClass;
  }
}
