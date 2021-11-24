import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/people_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';

class ClassModel {
  final String id;
  late final String name;
  late final int grade;
  late final String? _masterId;
  PeopleModel? _master;
  final Map<int, List<DayScheduleModel>> _schedule = {};

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

  Future<List<DayScheduleModel>> get schedule async {
    var cw = Get.find<CurrentWeek>().currentWeek;
    return _schedule[cw.weekNumber] ??= await Get.find<FStore>().getSchedulesModel(this, cw);
  }

  static Future<List<ClassModel>> classes() {
    return Get.find<FStore>().getClassesModel();
  }

  static Future<ClassModel> classCurrentStudent() {
    return Get.find<FStore>().getClassModelCurrentStudent();
  }
}
