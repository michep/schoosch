import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoosch/data/curriculum_model.dart';
import 'package:schoosch/data/lesson_model.dart';
import 'package:schoosch/data/lessontime_model.dart';
import 'package:schoosch/data/people_model.dart';
import 'package:schoosch/data/schedule_model.dart';
import 'package:schoosch/data/venue_model.dart';
import 'package:schoosch/data/weekday_model.dart';
import 'package:schoosch/data/class_model.dart';
import 'package:schoosch/data/yearweek_model.dart';

class FStore extends GetxController {
  final String _email;
  late final FirebaseFirestore _store;
  late final FirebaseFirestore _cachedStore;
  late final DocumentReference _institutionRef;
  late final PeopleModel _currentUser;
  late final ClassModel _currentClass;
  DateTime _currentDate = DateTime.now();

  final List<WeekdaysModel> _weekdaysCache = [];
  final List<YearweekModel> _yearweekCache = [];
  final List<LessontimeModel> _lessontimesCache = [];

  FStore(this._email) {
    FirebaseFirestore.instance.clearPersistence();
    _store = FirebaseFirestore.instance;
    _store.settings = const Settings(persistenceEnabled: false);
    _cachedStore = FirebaseFirestore.instance;
    _cachedStore.settings = const Settings(persistenceEnabled: true);
  }

  Future<void> init() async {
    _institutionRef = _store.collection('institution').doc(await _geInstitutionIdByUserEmail());
    _currentUser = await _getCurrentUserModel();
    _currentClass = await _getCurrentUserClassModel();
    await getWeekdayNameModels();
    await getLessontimeModels();
    await getYearweekModels();
  }

  PeopleModel get currentUser => _currentUser;

  Future<void> getWeekdayNameModels() async {
    var _weekdays = await _cachedStore.collection('weekday').orderBy('order').get();
    for (var _weekday in _weekdays.docs) {
      _weekdaysCache.add(WeekdaysModel.fromMap(_weekday.id, _weekday.data()));
    }
  }

  Future<void> getYearweekModels() async {
    var _yearweeks = await _cachedStore.collection('yearweek').get();
    for (var _yearweek in _yearweeks.docs) {
      _yearweekCache.add(YearweekModel.fromMap(_yearweek.id, _yearweek.data()));
    }
  }

  Future<void> getLessontimeModels() async {
    var _lessontimes = await _institutionRef.collection('lessontime').get();
    for (var _lessontime in _lessontimes.docs) {
      _lessontimesCache.add(LessontimeModel.fromMap(_lessontime.id, _lessontime.data()));
    }
  }

  Future<List<YearweekModel>> getYearweekModel(DateTime date) async {
    return _yearweekCache.where((_yw) => _yw.start!.isBefore(date) && _yw.end!.isAfter(date)).toList();
  }

  Future<WeekdaysModel> getWeekdayNameModel(int order) async {
    return _weekdaysCache[order - 1];
  }

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

  Future<List<ScheduleModel>> getSchedulesModel(String classId) async {
    return Future(() async => (await _institutionRef.collection('class').doc(classId).collection('schedule').orderBy('day').get())
        .docs
        .map(
          (_schedule) => ScheduleModel.fromMap(
            classId,
            _schedule.id,
            _schedule.data(),
          ),
        )
        .toList()
        .where((s) => s.from.isBefore(_currentDate) && s.till.isAfter(_currentDate))
        .toList());
  }

  Future<List<LessonModel>> getLessonsModel(String classId, String schedId) async {
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
    // await lesson.ref.update(lesson.toMap());
    return;
  }

  Future<String> _geInstitutionIdByUserEmail() async {
    var res = await _store.collectionGroup('people').where('email', isEqualTo: _email).limit(1).get();
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

  Future<PeopleModel> _getCurrentUserModel() async {
    var res = await _institutionRef.collection('people').where('email', isEqualTo: _email).limit(1).get();
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
}
