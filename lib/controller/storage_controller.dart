import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';

class FStorage extends GetxController {
  late final FirebaseStorage _fstorage;
  late Reference _fstorageRef;
  late Uint8List? _logoImagData;

  FStorage() {
    _fstorage = FirebaseStorage.instance;
  }

  Uint8List? get logoImageData => _logoImagData;

  Future<void> init(Db db) async {
    ;

    var fs = GridFS(db);
    var file = await fs.getFile('logo.png');
  }
}
