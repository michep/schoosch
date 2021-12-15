import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/people_model.dart';

class CurriculumModel {
  final String id;
  late final String _name;
  late final String? _alias;
  late final String? _masterId;
  final List<String> _studentIds = [];
  PeopleModel? _master;

  CurriculumModel.fromMap(this.id, Map<String, dynamic> map) {
    _name = map['name'] != null ? map['name'] as String : throw '';
    _alias = map['alias'] != null ? map['alias'] as String : null;
    _masterId = map['master_id'] != null ? map['master_id'] as String : null; //TODO: throw
    map['student_ids'] != null ? _studentIds.addAll((map['student_ids'] as List<dynamic>).map((e) => e as String)) : null; //TODO: throw
  }

  String get name => _alias ?? _name;

  Future<PeopleModel?> get master async {
    if (_master == null && _masterId != null) {
      var store = Get.find<FStore>();
      _master = await store.getPeople(_masterId!);
    }
    return _master;
  }

  bool isAvailableForStudent(String studentId) => _studentIds.isEmpty || _studentIds.contains(studentId);
}
