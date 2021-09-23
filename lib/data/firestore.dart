import 'dart:async';
import 'package:async/async.dart' show StreamGroup;
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
          (_schedules) => _schedules.docs
              .map((_schedule) => ScheduleModel.fromMap(
                    _schedule.id,
                    _schedule.data(),
                  ))
              .toList(),
        );
    // return _store.collection('class').doc(classId).collection('schedule').orderBy('day').snapshots().asyncMap((_event) {
    //   return Future(() {
    //     List<ScheduleModel> _schedmods = [];
    //     for (var _sched in _event.docs) {
    //       _schedmods.add(value)
    //     }
    //     return [
    //       const ScheduleModel("asd", 2),
    //       const ScheduleModel("asd", 5),
    //     ];
    //   });
    // });
  }

  Stream<List<LessonModel>> getClassScheduleLessonsModel(String classId, String schedId) {
    int day = DateTime.now().day;
    int mon = DateTime.now().month;
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
        data.docs.forEach((_les) => _lessons.add(LessonModel.fromMap(_les.id, _les.data())));
        sink.add(_lessons);
      },
    ));
  }
}
