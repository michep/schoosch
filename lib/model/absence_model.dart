import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/person_model.dart';

class AbsenceModel {
  final String? _id;
  late final DateTime date;
  late final String personId;
  late final int lessonOrder;
  StudentModel? _student;

  String? get id => _id;

  AbsenceModel.fromMap(this._id, Map<String, dynamic> map) {
    date = map['date'] != null ? DateTime.tryParse(map['date'])! : throw 'need date key in attendance $_id';
    personId = map['person_id'] != null ? map['person_id'] as String : throw 'need person_id key in attendance $_id';
    lessonOrder = map['lesson_order'] != null ? map['lesson_order'] as int : throw 'need lesson_order key in attendance $_id';

    if (map.containsKey('student') && map['student'] is Map) {
      _student = StudentModel.fromMap((map['student'] as Map<String, dynamic>)['_id'] as String, map['student'] as Map<String, dynamic>);
    }
  }

  Map<String, dynamic> toMap({bool withId = false}) {
    Map<String, dynamic> res = {};
    if (withId) res['_id'] = id;
    res['date'] = date.toIso8601String();
    res['person_id'] = personId;
    res['lesson_order'] = lessonOrder;
    return res;
  }

  Future<void> delete(LessonModel lesson) async {
    await Get.find<ProxyStore>().deleteAbsence(this);
  }

  Future<StudentModel> get student async {
    _student ??= (await Get.find<ProxyStore>().getPerson(personId)).asStudent;
    return _student!;
  }
}
