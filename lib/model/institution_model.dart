import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/class_model.dart';

class InstitutionModel {
  late final String id;
  late final String name;
  late final String address;

  InstitutionModel.fromMap(this.id, Map<String, dynamic> map) {
    name = map['name'] != null ? map['name'] as String : throw 'need name key in institution';
    address = map['address'] != null ? map['address'] as String : '';
  }

  Future<List<ClassModel>> get classes {
    return Get.find<FStore>().getClasses();
  }
}
