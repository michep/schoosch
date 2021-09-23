import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schoosch/data/lesson_model.dart';
import 'package:schoosch/data/schedule_model.dart';
import 'package:schoosch/data/weekday_model.dart';
import 'package:schoosch/data/class_model.dart';

class FS {
  late final FirebaseFirestore _store;

  FS._constructor() : _store = FirebaseFirestore.instance;
  static final FS _instance = FS._constructor();
  static FS get instance => _instance;

  Stream<WeekdaysModel> getWeekdayNameModel(int order) {
    return _store.collection('weekdays').doc(order.toString()).get().asStream().map(
          (_weekday) => WeekdaysModel.fromMap(
            order.toString(),
            _weekday.data()!,
          ),
        );
  }

  Stream<List<ClassModel>> getClassesModel() {
    return _store.collection('class').get().asStream().map(
          (_classes) => _classes.docs
              .map(
                (_class) => ClassModel.fromMap(
                  _class.id,
                  _class.data(),
                ),
              )
              .toList(),
        );
  }

  Stream<List<ScheduleModel>> getClassSchedulesModel(String classId) {
    return _store.collection('class').doc(classId).collection('schedule').orderBy('day').get().asStream().map(
          (_schedules) => _schedules.docs.map((_schedule) => ScheduleModel.fromMap(_schedule.id, _schedule.data())).toList(),
        );
  }

  Stream<List<ScheduleModel>> getClassSchedulesWithLessonsModel(String classId) {
    return _store.collection('class').doc(classId).collection('schedule').orderBy('day').snapshots().asyncMap((_event) {
      return Future(() async {
        List<ScheduleModel> _schedmods = [];
        for (var _sched in _event.docs) {
          List<LessonModel> _lessons = [];
          await for (var ll in getClassScheduleLessonsModel(classId, _sched.id).take(1)) {
            _lessons = ll;
          }
          _schedmods.add(ScheduleModel.fromMap(_sched.id, _sched.data(), _lessons));
        }
        return _schedmods;
      });
    });
  }

  Stream<List<LessonModel>> getClassScheduleLessonsModel(String classId, String schedId) {
    return _store
        .collection('class')
        .doc(classId)
        .collection('schedule')
        .doc(schedId)
        .collection('lesson')
        .orderBy('order')
        .snapshots()
        .transform(StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<LessonModel>>.fromHandlers(
      handleData: (data, sink) {
        List<LessonModel> _lessons = [];
        for (var _les in data.docs) {
          _lessons.add(LessonModel.fromMap(_les.id, _les.data()));
        }
        sink.add(_lessons);
      },
    ));
  }
}
