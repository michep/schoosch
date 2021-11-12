import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/lesson_model.dart';

class DayScheduleModel {
  final String classId;
  final String id;
  late final DateTime date;
  late final int day;
  late final DateTime from;
  late final DateTime till;
  List<LessonModel>? _lessons;

  DayScheduleModel.fromMap(this.classId, this.id, Map<String, Object?> map) {
    day = map['day'] != null ? map['day'] as int : -1;
    date = Get.find<CurrentWeek>().currentWeek.start.add(Duration(days: day - 1));
    from = map['from'] != null ? DateTime.fromMillisecondsSinceEpoch((map['from'] as Timestamp).millisecondsSinceEpoch) : DateTime(2000);
    till = map['till'] != null ? DateTime.fromMillisecondsSinceEpoch((map['till'] as Timestamp).millisecondsSinceEpoch) : DateTime(3000);
  }

  Future<List<LessonModel>> lessons(int week) async {
    return _lessons ??= await Get.find<FStore>().getLessonsModel(classId, id, week);
  }
}
