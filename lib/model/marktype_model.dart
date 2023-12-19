import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/model/status_enum.dart';

class MarkType {
  String? _id;
  late StatusModel status;
  late String name;
  late String label;
  late double weight;
  // late String institutionId;

  MarkType.fromMap(this._id, Map<String, dynamic> map) {
    map['status'] != null ? status = StatusModel.parse(map['status']) : throw 'need status key in marktype $id';
    name = map['name'] != null ? map['name'] as String : (throw 'required name in marktype $_id');
    label = map['label'] != null ? map['label'] as String : (throw 'required label in marktype $_id');
    weight = map['weight'] != null ? map['weight'] as double : (throw 'required weight amount in marktype $_id');
    // institutionId = map['institution_id'] != null ? map['institution_id'] as String : (throw 'required status in marktype $_id');
  }

  String? get id => _id;

  MarkType.empty() {
    _id = 'emptyid';
    status = StatusModel.active;
    name = 'пустой тип';
    label = 'пустой тип';
    weight = 1.0;
    // institutionId = Get.find<ProxyStore>().institution.id;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['_id'] = _id;
    res['status'] = status.nameInt;
    res['name'] = name;
    res['label'] = label;
    res['weight'] = weight;
    // res['institution_id'] = institutionId;
    return res;
  }

  static MarkType fromId(String id) {
    MarkType t = Get.find<ProxyStore>().typeFromId(id)!;
    return t;
  }

  static List<MarkType> getAllMarktypes() {
    return Get.find<ProxyStore>().marktypes;
  }

  Future<MarkType> save() async {
    var id = await Get.find<ProxyStore>().saveMarktype(this);
    _id ??= id;
    return this;
  }

  Future<void> delete() async {
    if (_id != null) return Get.find<ProxyStore>().deleteMarktype(this);
  }
}
