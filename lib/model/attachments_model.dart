import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';

class AttachmentModel {
  late final String? _id;
  late final String filename;
  late final Uint8List? filebytes;

  String? get id => _id;

  AttachmentModel.fromMap(this._id, Map<String, dynamic> map) {
    filename = map['filename'] != null ? map['filename'] as String : throw 'need filename key in attachment $_id';
    filebytes = map['filebytes'] != null ? map['filebytes'] as Uint8List : null;
  }

  AttachmentModel.local(this._id, this.filename, this.filebytes);

  Map<String, dynamic> toMap({bool withId = false}) {
    Map<String, dynamic> res = {};
    if (withId) res['_id'] = id;
    res['filename'] = filename;
    if(filebytes != null) res['filebytes'] = filebytes;
    return res;
  }

  Future<void> delete() async {
    await Get.find<ProxyStore>().deleteFile(this);
  }

  Future<AttachmentModel> save() async {
    return await Get.find<ProxyStore>().saveFile(this);
  }

  Future<void> download() async {
    await Get.find<ProxyStore>().downloadFile(this);
  }
}
