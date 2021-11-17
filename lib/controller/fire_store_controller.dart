import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/people_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/yearweek_model.dart';

class FStore extends GetxController {
  late final FirebaseFirestore _store;
  late final FirebaseFirestore _cachedStore;
  late final DocumentReference _institutionRef;
  late final ClassModel _currentClass;
  late final FirebaseStorage _fstorage;
  late final Reference _fstorageRef;
  late final Uint8List? _logoImagData;

  final Map<int, YearweekModel> _yearweekCache = {};
  final List<LessontimeModel> _lessontimesCache = [];

  PeopleModel? _currentUser;

  FStore() {
    _fstorage = FirebaseStorage.instance;
    FirebaseFirestore.instance.clearPersistence();
    _store = FirebaseFirestore.instance;
    _store.settings = const Settings(persistenceEnabled: false);
    _cachedStore = FirebaseFirestore.instance;
    _cachedStore.settings = const Settings(persistenceEnabled: true);
  }

  PeopleModel? get currentUser => _currentUser;

  Uint8List? get logoImageData => _logoImagData;

  Future<void> init(String email) async {
    _institutionRef = _store.collection('institution').doc(await _geInstitutionIdByUserEmail(email));
    _fstorageRef = _fstorage.ref((await _institutionRef.get()).id);
    _logoImagData = await _getLogoImageData();
    _currentUser = await _getCurrentUserModel(email);
    _currentClass = await _getCurrentUserClassModel();
    await _getLessontimeModels();
    await _getYearweekModels();
  }

  void resetCurrentUser() {
    _currentUser = null;
  }

  Future<Uint8List?> _getLogoImageData() {
    return _fstorageRef.child('logo.png').getData();
  }

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

  Future<LessontimeModel> getLessontimeModel(int order) async {
    return _lessontimesCache[order - 1];
  }

  Future<List<ClassModel>> getClassesModel() async {
    return (await _institutionRef.collection('class').orderBy('grade').get())
        .docs
        .map(
          (_class) => ClassModel.fromMap(
            _class.id,
            _class.data(),
          ),
        )
        .toList();
  }

  Future<ClassModel> getCurrentUserClassModel() async {
    return _currentClass;
  }

  Future<List<DayScheduleModel>> getSchedulesModel(String classId, YearweekModel currentWeek) async {
    return (await _institutionRef.collection('class').doc(classId).collection('schedule').orderBy('day').get())
        .docs
        .map(
          (schedule) => DayScheduleModel.fromMap(
            classId,
            schedule.id,
            schedule.data(),
          ),
        )
        .where((s) => s.from.isBefore(currentWeek.start) && s.till.isAfter(currentWeek.end))
        .toList();
  }

  Future<List<LessonModel>> getLessonsModel(String classId, String schedId, int week) async {
    return (await _institutionRef
            .collection('class')
            .doc(classId)
            .collection('schedule')
            .doc(schedId)
            .collection('lesson')
            .orderBy('order')
            .get())
        .docs
        .map((lesson) => LessonModel.fromMap(
              classId,
              schedId,
              lesson.id,
              lesson.data(),
            ))
        .toList();
  }

  Future<List<LessonModel>> getCurrentUserLessonsModel(String classId, String schedId, int week) async {
    List<LessonModel> res = [];
    var less = await getLessonsModel(classId, schedId, week);

    for (var l in less) {
      var cur = await l.curriculum;
      if (cur != null && cur.isAvailableForPerson(_currentUser!.id)) {
        res.add(l);
      }
    }
    return res;
  }

  Future<List<LessonModel>> getStudentLessonsModel(String classId, String schedId, int week, String personId) async {
    List<LessonModel> res = [];
    var less = await getLessonsModel(classId, schedId, week);

    for (var l in less) {
      var cur = await l.curriculum;
      if (cur != null && cur.isAvailableForPerson(personId)) {
        res.add(l);
      }
    }
    return res;
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
    if (_currentUser == null) {
      throw 'No current user set';
    }
    var res = await _institutionRef.collection('class').where('student_ids', arrayContains: _currentUser!.id).limit(1).get();
    if (res.docs.isEmpty) {
      throw 'Current user is not assigned to any class';
    }
    return ClassModel.fromMap(res.docs[0].id, res.docs[0].data());
  }
}
