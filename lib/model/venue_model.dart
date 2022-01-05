import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';

class VenueModel {
  late String? _id;
  late String name;

  String? get id => _id;

  VenueModel.empty()
      : this.fromMap(null, <String, dynamic>{
          'name': '',
        });

  VenueModel.fromMap(this._id, Map<String, Object?> map) {
    name = map['name'] != null ? map['name'] as String : throw 'need name key in venue $id';
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['name'] = name;
    return res;
  }

  Future<VenueModel> save() async {
    var id = await Get.find<FStore>().saveVenue(this);
    _id ??= id;
    return this;
  }
}
