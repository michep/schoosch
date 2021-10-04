import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:schoosch/data/lesson_model.dart';
import 'package:schoosch/data/lessontime_model.dart';
import 'package:schoosch/data/schedule_model.dart';
import 'package:schoosch/data/weekday_model.dart';
import 'package:schoosch/data/class_model.dart';
import 'package:schoosch/data/datasource_interface.dart';

class FS extends GetxController implements SchooschDatasource {
  late final FirebaseFirestore _store;
  late final FirebaseFirestore _cachedStore;
  final List<WeekdaysModel> _weekdaysCache = [];
  final List<LessontimeModel> _lessontimesCache = [];

  FS() {
    FirebaseFirestore.instance.clearPersistence();
    _store = FirebaseFirestore.instance;
    _store.settings = const Settings(persistenceEnabled: false);
    _cachedStore = FirebaseFirestore.instance;
    _cachedStore.settings = const Settings(persistenceEnabled: true);
  }

  @override
  Future<void> init() async {
    await getWeekdayNameModels();
    await getLessontimeModels();
  }

  @override
  Future<void> getWeekdayNameModels() async {
    var _weekdays = await _cachedStore.collection('weekdays').get();
    for (var _weekday in _weekdays.docs) {
      _weekdaysCache.add(WeekdaysModel(_weekday.id, _weekday.get('name')));
    }
  }

  @override
  Future<void> getLessontimeModels() async {
    var _lessontimes = await _cachedStore.collection('lessonTime').get();
    for (var _lessontime in _lessontimes.docs) {
      _lessontimesCache.add(LessontimeModel(_lessontime.id, _lessontime.get('from'), _lessontime.get('to')));
    }
  }

  @override
  Future<WeekdaysModel> getWeekdayNameModel(int order) async {
    return _weekdaysCache[order - 1];
  }

  @override
  Future<LessontimeModel> getLessontimeModel(int order) async {
    return _lessontimesCache[order - 1];
  }

  @override
  Future<List<ClassModel>> getClassesModel() {
    return Future(() async => (await _store.collection('class').get())
        .docs
        .map(
          (_class) => ClassModel.fromMap(
            _class.id,
            _class.data(),
          ),
        )
        .toList());
  }

  @override
  Future<List<ScheduleModel>> getSchedulesModel(String classId) {
    return Future(() async => (await _store.collection('class').doc(classId).collection('schedule').orderBy('day').get())
        .docs
        .map(
          (_schedule) => ScheduleModel.fromMap(
            _schedule.id,
            _schedule.data(),
          ),
        )
        .toList());
  }

  @override
  Future<List<ScheduleModel>> getSchedulesWithLessonsModel(String classId) {
    return Future(() async {
      List<ScheduleModel> _schedmods = [];
      var _scheds = await _store.collection('class').doc(classId).collection('schedule').orderBy('day').get();
      for (var _sched in _scheds.docs) {
        var _lessmods = await getLessonsModel(classId, _sched.id);
        _schedmods.add(ScheduleModel.fromMap(_sched.id, _sched.data(), _lessmods));
      }
      return _schedmods;
    });
  }

  @override
  Future<List<LessonModel>> getLessonsModel(String classId, String schedId) {
    return Future(() async {
      List<LessonModel> _lessmods = [];
      var _lessons =
          await _store.collection('class').doc(classId).collection('schedule').doc(schedId).collection('lesson').orderBy('order').get();
      for (var _less in _lessons.docs) {
        var _time = await getLessontimeModel(_less.data()['order']);
        Map<String, dynamic> _timeMap = {'timeFrom': _time.from, 'timeTill': _time.till};
        _timeMap.addAll(_less.data());
        _lessmods.add(LessonModel.fromMap(_less.reference, _less.id, _timeMap));
      }
      return _lessmods;
    });
  }

  @override
  Future<void> updateLesson(LessonModel lesson) async {
    await lesson.ref.update(lesson.toMap());
  }
}
