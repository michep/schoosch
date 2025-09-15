import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';

class AttachmentModel {
  late final String? _id;
  late final String filename;

  String? get id => _id;

  AttachmentModel.fromMap(this._id, Map<String, dynamic> map) {
    filename = map['filename'] != null ? map['filename'] as String : throw 'need filename key in attachment $_id';
  }

  Map<String, dynamic> toMap({bool withId = false}) {
    Map<String, dynamic> res = {};
    if (withId) res['_id'] = id;
    res['filename'] = filename;
    return res;
  }

  Future<void> delete() async {
    await Get.find<ProxyStore>().deleteFile(this);
  }
}
