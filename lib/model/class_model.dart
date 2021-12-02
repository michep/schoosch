import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/people_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';

class ClassModel {
  final String id;
  late final String name;
  late final int grade;
  late final String? _masterId;
  PeopleModel? _master;
  final Map<Week, List<DayScheduleModel>> _schedule = {};

  ClassModel.fromMap(this.id, Map<String, Object?> map) {
    name = map['name'] != null ? map['name'] as String : '';
    grade = map['grade'] != null ? map['grade'] as int : -1;
    _masterId = map['master_id'] != null ? map['master_id'] as String : null;
  }

  Future<PeopleModel?> get master async {
    if (_master == null && _masterId != null) {
      var store = Get.find<FStore>();
      _master = await store.getPeopleModel(_masterId!);
    }
    return _master;
  }

  Future<List<DayScheduleModel>> getSchedulesWeek(Week week) async {
    return _schedule[week] ??= await Get.find<FStore>().getSchedulesModel(this, week);
  }

  static Future<List<ClassModel>> allClasses() {
    return Get.find<FStore>().getClassesModel();
  }

  static Future<ClassModel> currentStudentClass() async {
    return Get.find<FStore>().currentClass;
  }
}
