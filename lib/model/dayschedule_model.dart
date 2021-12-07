import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/lesson_model.dart';

class DayScheduleModel {
  final ClassModel _class;
  late final Week _week;
  final String id;
  late final int day;
  late final DateTime from;
  late final DateTime till;
  final List<LessonModel> _lessons = [];
  bool _lessonsLoaded = false;
  final List<LessonModel> _studentLessons = [];
  bool _studentLessonsLoaded = false;

  DayScheduleModel.fromMap(this._class, this._week, this.id, Map<String, Object?> map) {
    day = map['day'] != null ? map['day'] as int : throw 'need day key in schedule';
    if (day < 1 || day > 7) throw 'incorrect day in schedule';
    from = map['from'] != null ? DateTime.fromMillisecondsSinceEpoch((map['from'] as Timestamp).millisecondsSinceEpoch) : DateTime(2000);
    till = map['till'] != null ? DateTime.fromMillisecondsSinceEpoch((map['till'] as Timestamp).millisecondsSinceEpoch) : DateTime(3000);
  }

  ClassModel get aclass => _class;

  DateTime get date => _week.days[day - 1];

  Future<List<LessonModel>> lessons(Week week) async {
    if (!_lessonsLoaded) {
      _lessons.addAll(await Get.find<FStore>().getLessonsModel(_class, this, week));
      _lessonsLoaded = true;
    }
    return _lessons;
  }

  Future<List<LessonModel>> lessonsCurrentStudent(Week week) async {
    if (!_studentLessonsLoaded) {
      _studentLessons.addAll(await Get.find<FStore>().getLessonsModelCurrentStudent(_class, this, week));
      _studentLessonsLoaded = true;
    }
    return _studentLessons;
  }
}
