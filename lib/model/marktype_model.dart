import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';

class MarkType {
  String? id;
  late int status;
  late String name;
  late String label;
  late double weight;
  late String institutionId;

  MarkType.fromMap(this.id, Map<String, dynamic> map) {
    status = map['status'] != null ? map['status'] as int : (throw 'required status in marktype $id');
    name = map['name'] != null ? map['name'] as String : (throw 'required name in marktype $id');
    label = map['label'] != null ? map['label'] as String : (throw 'required label in marktype $id');
    weight = map['weight'] != null ? map['weight'] as double : (throw 'required weight amount in marktype $id');
    institutionId = map['institution_id'] != null ? map['institution_id'] as String : (throw 'required status in marktype $id');
  }

  MarkType.empty() {
    id = 'emptytype123';
    status = 1;
    name = 'regular';
    label = 'обычная';
    weight = 1.0;
    institutionId = '';
  }

  MarkType.fromId(String id);

  static List<MarkType> getAllMarktypes() {
    return Get.find<ProxyStore>().marktypes;
  }
}