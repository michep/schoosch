import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/lesson_model.dart';

class DayScheduleModel {
  final ClassModel _class;
  final String id;
  late final DateTime date;
  late final int day;
  late final DateTime from;
  late final DateTime till;
  List<LessonModel>? _lessons;
  List<LessonModel>? _studentLessons;

  DayScheduleModel.fromMap(this._class, this.id, Map<String, Object?> map) {
    day = map['day'] != null ? map['day'] as int : -1;
    date = Get.find<CurrentWeek>().currentWeek.day(0).add(Duration(days: day - 1));
    from = map['from'] != null ? DateTime.fromMillisecondsSinceEpoch((map['from'] as Timestamp).millisecondsSinceEpoch) : DateTime(2000);
    till = map['till'] != null ? DateTime.fromMillisecondsSinceEpoch((map['till'] as Timestamp).millisecondsSinceEpoch) : DateTime(3000);
  }

  Future<List<LessonModel>> allLessons(Week week) async {
    return _lessons ??= await Get.find<FStore>().getLessonsModel(_class, this, week);
  }

  Future<List<LessonModel>> studentLessons(Week week) async {
    return _studentLessons ??= await Get.find<FStore>().getCurrentUserLessonsModel(_class, this, week);
  }
}
