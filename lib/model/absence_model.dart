import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/person_model.dart';

class AbsenceModel {
  final String? _id;
  late final DateTime date;
  late final String person_id;
  late final int lesson_order;
  // late final String status;

  String? get id => _id;

  AbsenceModel.fromMap(this._id, Map<String, dynamic> map) {
    date =
        map['date'] != null ? DateTime.fromMillisecondsSinceEpoch((map['date'] as Timestamp).millisecondsSinceEpoch) : throw 'need date key in attendance $_id';
    person_id = map['person_id'] != null ? map['person_id'] as String : throw 'need person_id key in attendance $_id';
    lesson_order = map['lesson_order'] != null ? map['lesson_order'] as int : throw 'need lesson_order key in attendance $_id';
    // status = map['status'] != null ? map['status'] as String : throw 'need status key in attendance $_id'; //TODO: status should be a emun with extensions
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['date'] = date;
    res['person_id'] = person_id;
    res['lesson_order'] = lesson_order;
    // res['status'] = status;
    return res;
  }

  Future<void> delete(LessonModel lesson) async {
    Get.find<FStore>().deleteAbsence(lesson, this);
  }

  Future<StudentModel> get student async {
    return (await Get.find<FStore>().getPerson(person_id)).asStudent!;
  }
}
