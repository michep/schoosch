import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schoosch/data/lesson_model.dart';
import 'package:schoosch/data/lessontime_model.dart';
import 'package:schoosch/data/schedule_model.dart';
import 'package:schoosch/data/weekday_model.dart';
import 'package:schoosch/data/class_model.dart';

class FS {
  late final FirebaseFirestore _store;
  late final FirebaseFirestore _cachedStore;

  FS._constructor() {
    FirebaseFirestore.instance.clearPersistence();
    _store = FirebaseFirestore.instance;
    _store.settings = const Settings(persistenceEnabled: false);
    _cachedStore = FirebaseFirestore.instance;
    _cachedStore.settings = const Settings(persistenceEnabled: true);
  }
  static final FS _instance = FS._constructor();
  static FS get instance => _instance;

  Stream<WeekdaysModel> getWeekdayNameModel(int order) {
    return _cachedStore.collection('weekdays').doc(order.toString()).snapshots().asyncMap(
          (_weekday) => WeekdaysModel.fromMap(
            order.toString(),
            _weekday.data()!,
          ),
        );
  }

  Stream<LessontimeModel> getLessontimeModel(int order) {
    return _cachedStore.collection('lessonTime').doc(order.toString()).snapshots().asyncMap(
          (_lessontime) => LessontimeModel.fromMap(
            order.toString(),
            _lessontime.data()!,
          ),
        );
  }

  Stream<List<ClassModel>> getClassesModel() {
    return _store.collection('class').snapshots().asyncMap(
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

  Stream<List<ScheduleModel>> getSchedulesModel(String classId) {
    return _store.collection('class').doc(classId).collection('schedule').orderBy('day').snapshots().asyncMap(
          (_schedules) => _schedules.docs.map((_schedule) => ScheduleModel.fromMap(_schedule.id, _schedule.data())).toList(),
        );
  }

  Stream<List<ScheduleModel>> getSchedulesWithLessonsModel(String classId) {
    return _store.collection('class').doc(classId).collection('schedule').orderBy('day').snapshots().asyncMap((_schedules) {
      return Future<List<ScheduleModel>>(() async {
        List<ScheduleModel> _schedmods = [];
        for (var _sched in _schedules.docs) {
          List<LessonModel> _lessons = [];
          await for (var ll in getLessonsModel(classId, _sched.id).take(1)) {
            _lessons = ll;
          }
          _schedmods.add(ScheduleModel.fromMap(_sched.id, _sched.data(), _lessons));
        }
        return _schedmods;
      });
    });
  }

  Stream<List<LessonModel>> getLessonsModel(String classId, String schedId) {
    return _store
        .collection('class')
        .doc(classId)
        .collection('schedule')
        .doc(schedId)
        .collection('lesson')
        .orderBy('order')
        .snapshots()
        .asyncMap((_lessons) {
      return Future<List<LessonModel>>(() async {
        List<LessonModel> _lessmods = [];
        for (var _les in _lessons.docs) {
          await for (var t in getLessontimeModel(_les.data()['order']).take(1)) {
            Map<String, dynamic> _data = {'timeFrom': t.from, 'timeTill': t.till};
            _data.addAll(_les.data());
            _lessmods.add(LessonModel.fromMap(_les.id, _data));
          }
        }
        return _lessmods;
      });
    });
  }
}
