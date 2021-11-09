import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/lesson_model.dart';

class DayScheduleModel {
  final String _classId;
  final String id;
  final int day;
  final DateTime from;
  final DateTime till;
  List<LessonModel>? _lessons;

  DayScheduleModel(
    this._classId,
    this.id,
    this.day,
    this.from,
    this.till,
  );

  DayScheduleModel.fromMap(String classId, String id, Map<String, Object?> map)
      : this(
          classId,
          id,
          map['day'] != null ? map['day'] as int : -1,
          map['from'] != null ? DateTime.fromMillisecondsSinceEpoch((map['from'] as Timestamp).millisecondsSinceEpoch) : DateTime(2000),
          map['till'] != null ? DateTime.fromMillisecondsSinceEpoch((map['till'] as Timestamp).millisecondsSinceEpoch) : DateTime(3000),
        );

  Future<List<LessonModel>> lessons(int week) async {
    if (_lessons == null) {
      var store = Get.find<FStore>();
      _lessons = await store.getLessonsModel(_classId, id, week);
    }
    return _lessons!;
  }
}
