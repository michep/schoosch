import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoosch/data/fire_store.dart';
import 'package:schoosch/data/lesson_model.dart';

class ScheduleModel {
  final String _classId;
  final String _id;
  final int _day;
  final DateTime _from;
  final DateTime _till;
  List<LessonModel>? _lessons;

  ScheduleModel(
    this._classId,
    this._id,
    this._day,
    this._from,
    this._till,
  );

  ScheduleModel.fromMap(String classId, String id, Map<String, Object?> map)
      : this(
          classId,
          id,
          map['day'] != null ? map['day'] as int : -1,
          map['from'] != null ? DateTime.fromMillisecondsSinceEpoch((map['from'] as Timestamp).millisecondsSinceEpoch) : DateTime(2000),
          map['till'] != null ? DateTime.fromMillisecondsSinceEpoch((map['till'] as Timestamp).millisecondsSinceEpoch) : DateTime(3000),
        );

  String get id => _id;
  int get day => _day;
  DateTime get from => _from;
  DateTime get till => _till;

  Future<List<LessonModel>> get lessons async {
    if (_lessons == null) {
      var store = Get.find<FStore>();
      _lessons = await store.getLessonsModel(_classId, _id);
    }
    return _lessons!;
  }
}
