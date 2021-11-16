import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/people_model.dart';

@immutable
class CurriculumModel {
  final String id;
  late final String _name;
  late final String? _alias;
  late final String? _masterId;
  PeopleModel? _master;

  CurriculumModel.fromMap(this.id, Map<String, dynamic> map) {
    _name = map['name'] != null ? map['name'] as String : '';
    _alias = map['alias'] != null ? map['alias'] as String : null;
    _masterId = map['master_id'] != null ? map['master_id'] as String : null;
  }

  String get name => _alias ?? _name;

  Future<PeopleModel?> get master async {
    if (_master == null && _masterId != null) {
      var store = Get.find<FStore>();
      _master = await store.getPeopleModel(_masterId!);
    }
    return _master;
  }
}
