import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/people_model.dart';

class CurriculumModel {
  final String _id;
  final String _name;
  final String? _alias;
  PeopleModel? _master;
  String? _masterId;

  CurriculumModel(
    this._id,
    this._name,
    this._alias,
  );

  String get id => _id;
  String get name => _alias ?? _name;

  Future<PeopleModel> get master async {
    if (_master == null && _masterId != null) {
      var store = Get.find<FStore>();
      _master = await store.getPeopleModel(_masterId!);
    }
    return _master!;
  }

  CurriculumModel.fromMap(String id, Map<String, dynamic> map)
      : this(
          id,
          map['name'] != null ? map['name'] as String : '',
          map['alias'] != null ? map['alias'] as String : null,
        );
}
