import 'package:get/get.dart';
import 'package:schoosch/controller/mongo_controller.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/person_model.dart';

class AbsenceModel {
  final String? _id;
  late final DateTime date;
  late final String personId;
  late final int lessonOrder;
  // late final String status;

  String? get id => _id;

  AbsenceModel.fromMap(this._id, Map<String, dynamic> map) {
    date = map['date'] != null ? DateTime.tryParse(map['date'])! : throw 'need date key in attendance $_id';
    personId = map['person_id'] != null ? map['person_id'] as String : throw 'need person_id key in attendance $_id';
    lessonOrder = map['lesson_order'] != null ? map['lesson_order'] as int : throw 'need lesson_order key in attendance $_id';
    // status = map['status'] != null ? map['status'] as String : throw 'need status key in attendance $_id'; //TODO: status should be a emun with extensions
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['date'] = date;
    res['person_id'] = personId;
    res['lesson_order'] = lessonOrder;
    // res['status'] = status;
    return res;
  }

  Future<void> delete(LessonModel lesson) async {
    Get.find<MStore>().deleteAbsence(lesson, this);
  }

  Future<StudentModel> get student async {
    return (await Get.find<ProxyStore>().getPerson(personId)).asStudent!;
  }
}
