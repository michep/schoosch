import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/people_model.dart';
import 'package:schoosch/model/day_schedule_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/model/weekday_model.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/yearweek_model.dart';

class FStore extends GetxController {
  late final FirebaseFirestore _store;
  late final FirebaseFirestore _cachedStore;
  late final DocumentReference _institutionRef;
  late final PeopleModel _currentUser;
  late final ClassModel _currentClass;

  // final List<WeekdaysModel> _weekdaysCache = [];
  final Map<int, YearweekModel> _yearweekCache = {};
  final List<LessontimeModel> _lessontimesCache = [];

  FStore() {
    FirebaseFirestore.instance.clearPersistence();
    _store = FirebaseFirestore.instance;
    _store.settings = const Settings(persistenceEnabled: false);
    _cachedStore = FirebaseFirestore.instance;
    _cachedStore.settings = const Settings(persistenceEnabled: true);
  }

  PeopleModel get currentUser => _currentUser;

  Future<void> init(String email) async {
    _institutionRef = _store.collection('institution').doc(await _geInstitutionIdByUserEmail(email));
    _currentUser = await _getCurrentUserModel(email);
    _currentClass = await _getCurrentUserClassModel();
    // await _getWeekdayNameModels();
    await _getLessontimeModels();
    await _getYearweekModels();
  }

  // Future<void> _getWeekdayNameModels() async {
  //   var _weekdays = await _cachedStore.collection('weekday').orderBy('order').get();
  //   for (var _weekday in _weekdays.docs) {
  //     _weekdaysCache.add(WeekdaysModel.fromMap(_weekday.id, _weekday.data()));
  //   }
  // }

  Future<void> _getYearweekModels() async {
    var _yearweeks = await _cachedStore.collection('yearweek').orderBy('order').get();
    for (var _yearweek in _yearweeks.docs) {
      var yw = YearweekModel.fromMap(_yearweek.id, _yearweek.data());
      _yearweekCache[yw.order] = yw;
    }
  }

  Future<void> _getLessontimeModels() async {
    var _lessontimes = await _institutionRef.collection('lessontime').orderBy('order').get();
    for (var _lessontime in _lessontimes.docs) {
      _lessontimesCache.add(LessontimeModel.fromMap(_lessontime.id, _lessontime.data()));
    }
  }

  YearweekModel getYearweekModelByDate(DateTime date) {
    return _yearweekCache.values.where((_yw) => _yw.start.isBefore(date) && _yw.end.isAfter(date)).first;
  }

  YearweekModel? getYearweekModelByWeek(int n) {
    var wm = _yearweekCache.values.where((_yw) => _yw.order == n);
    return wm.length != 1 ? null : wm.first;
  }

  // Future<WeekdaysModel> getWeekdayNameModel(int order) async {
  //   return _weekdaysCache[order - 1];
  // }

  Future<LessontimeModel> getLessontimeModel(int order) async {
    return _lessontimesCache[order - 1];
  }

  Future<List<ClassModel>> getClassesModel() async {
    return Future(() async => (await _institutionRef.collection('class').orderBy('grade').get())
        .docs
        .map(
          (_class) => ClassModel.fromMap(
            _class.id,
            _class.data(),
          ),
        )
        .toList());
  }

  ClassModel get currentClass => _currentClass;

  Future<List<DayScheduleModel>> getSchedulesModel(String classId, YearweekModel currentWeek) async {
    return Future(() async => (await _institutionRef.collection('class').doc(classId).collection('schedule').orderBy('day').get())
        .docs
        .map(
          (_schedule) => DayScheduleModel.fromMap(
            classId,
            _schedule.id,
            _schedule.data(),
          ),
        )
        .where((s) => s.from.isBefore(currentWeek.start) && s.till.isAfter(currentWeek.end))
        .toList());
  }

  Future<List<LessonModel>> getLessonsModel(String classId, String schedId, int week) async {
    return Future(() async => (await _institutionRef
            .collection('class')
            .doc(classId)
            .collection('schedule')
            .doc(schedId)
            .collection('lesson')
            .orderBy('order')
            .get())
        .docs
        .map((e) => LessonModel.fromMap(
              classId,
              schedId,
              e.id,
              e.data(),
            ))
        .toList());
  }

  Future<PeopleModel> getPeopleModel(String id) async {
    var res = await _institutionRef.collection('people').doc(id).get();
    return PeopleModel.fromMap(res.id, res.data()!);
  }

  Future<CurriculumModel> getCurriculumModel(String id) async {
    var res = await _institutionRef.collection('curriculum').doc(id).get();
    return CurriculumModel.fromMap(res.id, res.data()!);
  }

  Future<VenueModel> getVenueModel(String id) async {
    var res = await _institutionRef.collection('venue').doc(id).get();
    return VenueModel.fromMap(res.id, res.data()!);
  }

  Future<void> updateLesson(LessonModel lesson) async {
    return _institutionRef
        .collection('class')
        .doc(lesson.classId)
        .collection('schedule')
        .doc(lesson.scheduleId)
        .collection('lesson')
        .doc(lesson.id)
        .update(lesson.toMap());
  }

  Future<String> _geInstitutionIdByUserEmail(String email) async {
    var res = await _store.collectionGroup('people').where('email', isEqualTo: email).limit(1).get();
    if (res.docs.isEmpty) {
      throw 'User with provided email was not found in any Institution';
    }
    var instid = res.docs[0].reference.path.split('/')[1];
    var inst = await _store.collection('institution').doc(instid).get();
    if (!inst.exists) {
      throw 'Institution was not found';
    }
    return inst.id;
  }

  Future<PeopleModel> _getCurrentUserModel(String email) async {
    var res = await _institutionRef.collection('people').where('email', isEqualTo: email).limit(1).get();
    if (res.docs.isEmpty) {
      throw 'User with provided email was not found in current Institution';
    }
    return PeopleModel.fromMap(res.docs[0].id, res.docs[0].data());
  }

  Future<ClassModel> _getCurrentUserClassModel() async {
    var res = await _institutionRef.collection('class').where('student_ids', arrayContains: _currentUser.id).limit(1).get();
    if (res.docs.isEmpty) {
      throw 'Current user is not assigned to any class';
    }
    return ClassModel.fromMap(res.docs[0].id, res.docs[0].data());
  }

  Future<Map<PeopleModel, List<String>>> getUserTeachers() async {
    var teachers = <PeopleModel, List<String>> {};
    var mast = await currentClass.master;
    if(mast != null) {
      teachers[mast] = ["Классный руководитель",];
    }

    var days = await currentClass.schedule;
    for(var day in days) {
      var dayles = await day.lessons(Get.find<CurrentWeek>().currentWeek.order);
      for(var les in dayles) {
        var cur = await les.curriculum;
        var teach = await cur.master;
        if(teach != null) {
          if(teachers[teach] == null) {
            teachers[teach] = [cur.name];
          }
          else if (!teachers[teach]!.contains(cur.name)) {
            teachers[teach]!.add(cur.name);
          }
        }
      }
    }

    return teachers;
  }

  Future saveRate(String teacherId, String raterId, DateTime date, int rating, String commentary) async {
    Map<String, dynamic> data = {};
    data['ratedate'] = Timestamp.fromDate(date);
    data['rater_id'] = raterId;
    data['rating'] = rating;
    data['teacher_id'] = teacherId;
    data['commentary'] = commentary;
    return _institutionRef.collection('teachersrates').add(data);
  }

  Future<double> getAverageTeacherRating(String teacherid) async {
    double sum = 0;
    var ratings = await _institutionRef.collection('teachersrates').where('teacher_id', isEqualTo: teacherid).get();
    for(var i in ratings.docs) {
      sum += i.get('rating');
    }
    return sum / ratings.docs.length;
  }
}
