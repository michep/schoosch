import 'package:get/get.dart';
import 'package:schoosch/data/fire_store.dart';
import 'package:schoosch/data/people_model.dart';
import 'package:schoosch/data/schedule_model.dart';

class ClassModel {
  final String _id;
  final String _name;
  final int _grade;
  String? _masterId;
  PeopleModel? _master;
  List<ScheduleModel>? _schedule;

  ClassModel(
    this._id,
    this._name,
    this._grade,
    this._masterId,
  );

  ClassModel.fromMap(String id, Map<String, Object?> map)
      : this(
          id,
          map['name'] != null ? map['name'] as String : '',
          map['grade'] != null ? map['grade'] as int : -1,
          map['master_id'] != null ? map['master_id'] as String : null,
        );

  String get id => _id;
  String get name => _name;
  int get grade => _grade;

  Future<PeopleModel?> get master async {
    if (_master == null && _masterId != null) {
      var store = Get.find<FStore>();
      _master = await store.getPeopleModel(_masterId!);
    }
    return _master;
  }

  Future<List<ScheduleModel>> get schedule async {
    if (_schedule == null) {
      var store = Get.find<FStore>();
      _schedule = await store.getSchedulesModel(id);
    }
    return _schedule!;
  }
}
