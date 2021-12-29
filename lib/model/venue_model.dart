import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';

class VenueModel {
  late String? id;
  late String name;

  VenueModel.empty()
      : this.fromMap(null, <String, dynamic>{
          'name': '',
        });

  VenueModel.fromMap(this.id, Map<String, Object?> map) {
    name = map['name'] != null ? map['name'] as String : throw 'need name key in venue $id';
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['name'] = name;
    return res;
  }

  Future<void> save() async {
    return Get.find<FStore>().saveVenue(this);
  }
}
