import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/people_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/model/class_model.dart';

class FStore extends GetxController {
  late final FirebaseFirestore _store;
  late final FirebaseFirestore _cachedStore;
  late final DocumentReference _institutionRef;
  late final ClassModel _currentClass;
  late final FirebaseStorage _fstorage;
  late final Reference _fstorageRef;
  late final Uint8List? _logoImagData;

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
  }

  void resetCurrentUser() {
    _currentUser = null;
  }

  Future<Uint8List?> _getLogoImageData() {
    return _fstorageRef.child('logo.png').getData();
  }

  Future<void> _getLessontimeModels() async {
    var _lessontimes = await _institutionRef.collection('lessontime').orderBy('order').get();
    for (var _lessontime in _lessontimes.docs) {
      _lessontimesCache.add(LessontimeModel.fromMap(_lessontime.id, _lessontime.data()));
    }
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

  Future<ClassModel> getClassModelCurrentStudent() async {
    return _currentClass;
  }

  Future<List<DayScheduleModel>> getSchedulesModel(ClassModel aclass, Week currentWeek) async {
    return (await _institutionRef.collection('class').doc(aclass.id).collection('schedule').orderBy('day').get())
        .docs
        .map(
          (schedule) => DayScheduleModel.fromMap(
            aclass,
            schedule.id,
            schedule.data(),
          ),
        )
        .where((s) => s.from.isBefore(currentWeek.day(0)) && s.till.isAfter(currentWeek.day(7)))
        .toList();
  }

  Future<List<LessonModel>> getLessonsModel(ClassModel aclass, DayScheduleModel schedule, Week week) async {
    return (await _institutionRef
            .collection('class')
            .doc(aclass.id)
            .collection('schedule')
            .doc(schedule.id)
            .collection('lesson')
            .orderBy('order')
            .get())
        .docs
        .map((lesson) => LessonModel.fromMap(
              aclass,
              schedule,
              lesson.id,
              lesson.data(),
            ))
        .toList();
  }

  Future<List<LessonModel>> getLessonsModelCurrentStudent(ClassModel aclass, DayScheduleModel schedule, Week week) async {
    List<LessonModel> res = [];
    var less = await getLessonsModel(aclass, schedule, week);

    for (var l in less) {
      var cur = await l.curriculum;
      if (cur != null && cur.isAvailableForStudent(_currentUser!.id)) {
        res.add(l);
      }
    }
    return res;
  }

  Future<List<LessonModel>> getLessonsModelStudent(ClassModel aclass, DayScheduleModel schedule, Week week, String personId) async {
    List<LessonModel> res = [];
    var less = await getLessonsModel(aclass, schedule, week);

    for (var l in less) {
      var cur = await l.curriculum;
      if (cur != null && cur.isAvailableForStudent(personId)) {
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

  Future<Map<PeopleModel, List<String>>> getTeachersCurrentStudent() async {
    var teachers = <PeopleModel, List<String>>{};
    var mast = await (await getClassModelCurrentStudent()).master;
    if (mast != null) {
      teachers[mast] = [
        "Классный руководитель",
      ];
    }

    var days = await (await getClassModelCurrentStudent()).schedule;
    for (var day in days) {
      var dayles = await day.lessonsCurrentStudent(Get.find<CurrentWeek>().currentWeek);
      for (var les in dayles) {
        var cur = await les.curriculum;
        var teach = await cur!.master;
        if (teach != null) {
          if (teachers[teach] == null) {
            teachers[teach] = [cur.name];
          } else if (!teachers[teach]!.contains(cur.name)) {
            teachers[teach]!.add(cur.name);
          }
        }
      }
    }

    return teachers;
  }

  Future saveTeacherRate(String teacherId, String raterId, DateTime date, int rating, String commentary) async {
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
    for (var i in ratings.docs) {
      sum += i.get('rating');
    }
    return sum / ratings.docs.length;
  }

  Future<List<HomeworkModel>> getLessonHomeworkCurrentStudent(DayScheduleModel schedule, CurriculumModel curriculum) async {
    return getLessonHomeworkStudent(schedule, curriculum, currentUser!);
  }

  Future<List<HomeworkModel>> getLessonHomeworkStudent(DayScheduleModel schedule, CurriculumModel curriculum, PeopleModel student) async {
    List<HomeworkModel> ret = [];
    var chw = (await _institutionRef
            .collection('homework')
            .where('date', isGreaterThanOrEqualTo: schedule.date)
            .where('date', isLessThan: schedule.date.add(const Duration(hours: 23, minutes: 59)))
            .where('curriculum_id', isEqualTo: curriculum.id)
            .where('student_id', isNull: true)
            .get())
        .docs
        .map((e) => HomeworkModel.fromMap(e.id, e.data()))
        .toList();
    var cwhu = (await _institutionRef
            .collection('homework')
            .where('date', isGreaterThanOrEqualTo: schedule.date)
            .where('date', isLessThan: schedule.date.add(const Duration(hours: 23, minutes: 59)))
            .where('curriculum_id', isEqualTo: curriculum.id)
            .where('student_id', isEqualTo: student.id)
            .get())
        .docs
        .map((e) => HomeworkModel.fromMap(e.id, e.data()))
        .toList();

    ret.addAll(chw);
    ret.addAll(cwhu);
    return ret;
  }

  Future<List<HomeworkModel>> getLessonHomework(DayScheduleModel schedule, CurriculumModel curriculum) async {
    return (await _institutionRef
            .collection('homework')
            .where('date', isGreaterThanOrEqualTo: schedule.date)
            .where('date', isLessThan: schedule.date.add(const Duration(hours: 23, minutes: 59)))
            .where('curriculum_id', isEqualTo: curriculum.id)
            .get())
        .docs
        .map((e) => HomeworkModel.fromMap(e.id, e.data()))
        .toList();
  }

  Future<List<MarkModel>> getLessonMarkCurrentStudent(DayScheduleModel schedule, LessonModel lesson) async {
    return (await _institutionRef
            .collection('mark')
            .where('date', isGreaterThanOrEqualTo: schedule.date)
            .where('date', isLessThan: schedule.date.add(const Duration(hours: 23, minutes: 59)))
            .where('curriculum_id', isEqualTo: (await lesson.curriculum)!.id)
            .where('lesson_order', isEqualTo: lesson.order)
            .where('student_id', isEqualTo: currentUser!.id)
            .get())
        .docs
        .map((e) => MarkModel.fromMap(e.id, e.data()))
        .toList();
  }
}
