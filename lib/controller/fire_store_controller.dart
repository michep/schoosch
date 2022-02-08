import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/daylessontime_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/model/class_model.dart';

class FStore extends GetxController {
  late final FirebaseFirestore _store;
  late final FirebaseStorage _fstorage;
  late DocumentReference _institutionRef;
  late Reference _fstorageRef;
  late Uint8List? _logoImagData;
  PersonModel? _currentUser;
  InstitutionModel? _institution;

  FStore() {
    _fstorage = FirebaseStorage.instance;
    _store = FirebaseFirestore.instance;
    _store.settings = const Settings(persistenceEnabled: false);
    _store.clearPersistence();
  }

  PersonModel? get currentUser => _currentUser;
  InstitutionModel? get currentInstitution => _institution;
  Uint8List? get logoImageData => _logoImagData;

  Future<void> init(String userEmail) async {
    _institution = await _geInstitutionIdByUserEmail(userEmail);
    _institutionRef = _store.collection('institution').doc(_institution!.id);
    _fstorageRef = _fstorage.ref(_institutionRef.id);
    _logoImagData = await _getLogoImageData();
    _currentUser = await _getUserByEmail(userEmail);
  }

  Future<void> reset() async {
    return init(_currentUser!.email);
  }

  void resetCurrentUser() {
    _currentUser = null;
  }

  Future<Uint8List?> _getLogoImageData() async {
    Uint8List? data;
    try {
      data = await _fstorageRef.child('logo.png').getData();
    } catch (error) {
      return null;
    }
    return data;
  }

  Future<List<LessontimeModel>> getLessontime(String id) async {
    List<LessontimeModel> res = [];
    var _lessontimes = await _institutionRef.collection('lessontime').doc(id).collection('time').orderBy('order').get();
    for (var _lessontime in _lessontimes.docs) {
      res.add(LessontimeModel.fromMap(_lessontime.id, _lessontime.data()));
    }
    return res;
  }

  Future<DayLessontimeModel> getDayLessontime(String id) async {
    var res = await _institutionRef.collection('lessontime').doc(id).get();
    return DayLessontimeModel.fromMap(res.id, res.data()!);
  }

  Future<List<DayLessontimeModel>> getAllDayLessontime() async {
    List<DayLessontimeModel> res = [];
    var _timenames = await _institutionRef.collection('lessontime').get();
    for (var val in _timenames.docs) {
      res.add(DayLessontimeModel.fromMap(val.id, val.data()));
    }
    return res;
  }

  Future<List<ClassModel>> getAllClasses() async {
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

  Future<String> saveClass(ClassModel aclass) async {
    if (aclass.id != null) {
      await _institutionRef.collection('class').doc(aclass.id).set(aclass.toMap());
      return aclass.id!;
    } else {
      var v = await _institutionRef.collection('class').add(aclass.toMap());
      return v.id;
    }
  }

  Future<List<StudentScheduleModel>> getClassWeekSchedule(ClassModel aclass, Week currentWeek) async {
    return (await _institutionRef.collection('class').doc(aclass.id).collection('schedule').orderBy('day').get())
        .docs
        .map(
          (schedule) => StudentScheduleModel.fromMap(
            aclass,
            schedule.id,
            schedule.data(),
          ),
        )
        .where((s) => s.from!.isBefore(currentWeek.day(5)) && (s.till == null || s.till!.isAfter(currentWeek.day(4))))
        .toList();
  }

  Future<List<StudentScheduleModel>> getClassDaySchedule(ClassModel aclass, int day) async {
    return (await _institutionRef.collection('class').doc(aclass.id).collection('schedule').orderBy('from').get())
        .docs
        .map(
          (schedule) => StudentScheduleModel.fromMap(
            aclass,
            schedule.id,
            schedule.data(),
          ),
        )
        .where((s) => s.day == day)
        .toList();
  }

  Future<String> saveDaySchedule(DayScheduleModel schedule) async {
    if (schedule.id != null) {
      await _institutionRef.collection('class').doc(schedule.aclass.id).collection('schedule').doc(schedule.id).set(schedule.toMap());
      return schedule.id!;
    } else {
      var v = await _institutionRef.collection('class').doc(schedule.aclass.id).collection('schedule').add(schedule.toMap());
      return v.id;
    }
  }

  Future<List<LessonModel>> getScheduleLessons(ClassModel aclass, DayScheduleModel schedule) async {
    return (await _institutionRef.collection('class').doc(aclass.id).collection('schedule').doc(schedule.id).collection('lesson').orderBy('order').get())
        .docs
        .map((lesson) => LessonModel.fromMap(
              aclass,
              schedule,
              lesson.id,
              lesson.data(),
            ))
        .toList();
  }

  Future<List<LessonModel>> getScheduleLessonsForStudent(ClassModel aclass, StudentScheduleModel schedule, StudentModel student) async {
    List<LessonModel> res = [];
    var less = await getScheduleLessons(aclass, schedule);

    for (var l in less) {
      var cur = await l.curriculum;
      if (cur != null && cur.isAvailableForStudent(student.id!)) {
        res.add(l);
      }
    }
    return res;
  }

  Future<String> saveLesson(LessonModel lesson) async {
    if (lesson.id != null) {
      await _institutionRef
          .collection('class')
          .doc(lesson.aclass.id)
          .collection('schedule')
          .doc(lesson.schedule.id)
          .collection('lesson')
          .doc(lesson.id)
          .set(lesson.toMap());
      return lesson.id!;
    } else {
      var v = await _institutionRef
          .collection('class')
          .doc(lesson.aclass.id)
          .collection('schedule')
          .doc(lesson.schedule.id)
          .collection('lesson')
          .add(lesson.toMap());
      return v.id;
    }
  }

  Future<void> deleteLesson(LessonModel lesson) async {
    if (lesson.id != null) {
      await _institutionRef
          .collection('class')
          .doc(lesson.aclass.id)
          .collection('schedule')
          .doc(lesson.schedule.id)
          .collection('lesson')
          .doc(lesson.id)
          .delete();
    }
  }

  Future<PersonModel> getPerson(String id) async {
    var res = await _institutionRef.collection('people').doc(id).get();
    return PersonModel.fromMap(res.id, res.data()!);
  }

  Future<List<PersonModel>> getAllPeople() async {
    return (await _institutionRef.collection('people').get())
        .docs
        .map(
          (person) => PersonModel.fromMap(
            person.id,
            person.data(),
          ),
        )
        .toList();
  }

  Future<List<PersonModel>> getPeopleByIds(List<String> ids) async {
    List<PersonModel> res = [];
    for (var id in ids) {
      var p = await getPerson(id);
      res.add(p);
    }
    return res;
  }

  Future<String> savePerson(PersonModel person) async {
    if (person.id != null) {
      await _institutionRef.collection('people').doc(person.id).set(person.toMap());
      return person.id!;
    } else {
      var v = await _institutionRef.collection('people').add(person.toMap());
      return v.id;
    }
  }

  Future<List<CurriculumModel>> getAllCurriculums() async {
    return (await _institutionRef.collection('curriculum').get())
        .docs
        .map(
          (curr) => CurriculumModel.fromMap(
            curr.id,
            curr.data(),
          ),
        )
        .toList();
  }

  Future<CurriculumModel> getCurriculum(String id) async {
    var res = await _institutionRef.collection('curriculum').doc(id).get();
    return CurriculumModel.fromMap(res.id, res.data()!);
  }

  Future<String> saveCurriculum(CurriculumModel curriculum) async {
    if (curriculum.id != null) {
      await _institutionRef.collection('curriculum').doc(curriculum.id).set(curriculum.toMap());
      return curriculum.id!;
    } else {
      var v = await _institutionRef.collection('curriculum').add(curriculum.toMap());
      return v.id;
    }
  }

  Future<List<VenueModel>> getAllVenues() async {
    return (await _institutionRef.collection('venue').get())
        .docs
        .map(
          (venue) => VenueModel.fromMap(
            venue.id,
            venue.data(),
          ),
        )
        .toList();
  }

  Future<String> saveVenue(VenueModel venue) async {
    if (venue.id != null) {
      await _institutionRef.collection('venue').doc(venue.id).set(venue.toMap());
      return venue.id!;
    } else {
      var v = await _institutionRef.collection('venue').add(venue.toMap());
      return v.id;
    }
  }

  Future<VenueModel> getVenue(String id) async {
    var res = await _institutionRef.collection('venue').doc(id).get();
    return VenueModel.fromMap(res.id, res.data()!);
  }

  Future<InstitutionModel> _geInstitutionIdByUserEmail(String email) async {
    var res = await _store.collectionGroup('people').where('email', isEqualTo: email).limit(1).get();
    if (res.docs.isEmpty) {
      throw 'User with provided email was not found in any Institution';
    }
    var inst = await res.docs[0].reference.parent.parent!.get();
    if (!inst.exists) {
      throw 'Institution was not found';
    }
    return InstitutionModel.fromMap(inst.id, inst.data()!);
  }

  Future<PersonModel> _getUserByEmail(String email) async {
    var res = await _institutionRef.collection('people').where('email', isEqualTo: email).limit(1).get();
    if (res.docs.isEmpty) {
      throw 'User with provided email was not found in current Institution';
    }
    return PersonModel.fromMap(res.docs[0].id, res.docs[0].data());
  }

  Future<ClassModel?> getClassForStudent(PersonModel student) async {
    var res = await _institutionRef.collection('class').where('student_ids', arrayContains: student.id).limit(1).get();
    if (res.docs.isEmpty) {
      return null;
    } else {
      return ClassModel.fromMap(res.docs[0].id, res.docs[0].data());
    }
  }

  Future<Map<TeacherModel, List<String>>> getClassTeachers(ClassModel aclass) async {
    var teachers = <TeacherModel, List<String>>{};
    var mast = await aclass.master;
    if (mast != null) {
      teachers[mast] = [
        'Классный руководитель',
      ];
    }
    var cw = Get.find<CurrentWeek>().currentWeek; //TODO: currentWeek should be parameter
    var days = await aclass.getSchedulesWeek(cw);
    for (var day in days) {
      var dayles = await day.lessonsForStudent(PersonModel.currentStudent!);
      for (var les in dayles) {
        var cur = await les.curriculum;
        var teach = await cur!.master;
        if (teach != null) {
          if (teachers[teach] == null) {
            teachers[teach] = [cur.aliasOrName];
          } else if (!teachers[teach]!.contains(cur.aliasOrName)) {
            teachers[teach]!.add(cur.aliasOrName);
          }
        }
      }
    }

    return teachers;
  }

  Future<void> saveTeacherRating(TeacherModel teacher, PersonModel user, DateTime date, int rating, String comment) async {
    Map<String, dynamic> data = {};
    data['ratedate'] = Timestamp.fromDate(date);
    data['rater_id'] = user.id;
    data['rating'] = rating;
    data['teacher_id'] = teacher.id;
    data['commentary'] = comment;
    await _institutionRef.collection('teachersrates').add(data);
  }

  Future saveMark(
      TeacherModel user, PersonModel student, CurriculumModel curriculum, DateTime date, int mark, int lessonOrder, String markType, String comment) async {
    Map<String, dynamic> data = {};
    data['comment'] = comment;
    data['curriculum_id'] = curriculum.id;
    data['date'] = Timestamp.fromDate(date);
    data['lesson_order'] = lessonOrder;
    data['mark'] = mark;
    data['student_id'] = student.id;
    data['teacher_id'] = user.id;
    data['type'] = markType;
    return _institutionRef.collection('mark').add(data);
  }

  Future saveHomework(String homeworkText, CurriculumModel curriculum, TeacherModel teacher, DateTime date, {StudentModel? student}) async {
    Map<String, dynamic> data = {};
    data['text'] = homeworkText;
    data['student_id'] = student?.id;
    data['teacher_id'] = teacher.id;
    data['curriculum_id'] = curriculum.id;
    data['date'] = date;
    return _institutionRef.collection('homework').add(data);
  }

  Future<double> getAverageTeacherRating(TeacherModel teacher) async {
    double sum = 0;
    var ratings = await _institutionRef.collection('teachersrates').where('teacher_id', isEqualTo: teacher.id).get();
    for (var i in ratings.docs) {
      sum += i.get('rating');
    }
    return sum / ratings.docs.length;
  }

  Future<List<HomeworkModel>> getLessonHomeworksForStudent(DayScheduleModel schedule, CurriculumModel curriculum, StudentModel student, DateTime date) async {
    List<HomeworkModel> ret = [];
    var chw = (await _institutionRef
            .collection('homework')
            // .where('date', isGreaterThanOrEqualTo: schedule.date)
            .where('date', isLessThan: date)
            .where('curriculum_id', isEqualTo: curriculum.id)
            .where('student_id', isNull: true)
            .orderBy('date', descending: true)
            .limit(1)
            .get())
        .docs
        .map((e) => HomeworkModel.fromMap(e.id, e.data()))
        .toList();
    var cwhu = (await _institutionRef
            .collection('homework')
            .where('date', isLessThan: date)
            .where('curriculum_id', isEqualTo: curriculum.id)
            .where('student_id', isEqualTo: student.id)
            .orderBy('date', descending: true)
            .limit(1)
            .get())
        .docs
        .map((e) => HomeworkModel.fromMap(e.id, e.data()))
        .toList();

    ret.addAll(chw);
    ret.addAll(cwhu);
    return ret;
  }

  Future<List<HomeworkModel>> getLessonHomeworks(DayScheduleModel schedule, CurriculumModel curriculum, DateTime date) async {
    return (await _institutionRef
            .collection('homework')
            .where('date', isGreaterThanOrEqualTo: date)
            .where('date', isLessThan: date.add(const Duration(hours: 23, minutes: 59)))
            .where('curriculum_id', isEqualTo: curriculum.id)
            .get())
        .docs
        .map((e) => HomeworkModel.fromMap(e.id, e.data()))
        .toList();
  }

  Future<List<MarkModel>> getLessonMarksForStudent(DayScheduleModel schedule, LessonModel lesson, StudentModel student, DateTime date) async {
    return (await _institutionRef
            .collection('mark')
            .where('date', isGreaterThanOrEqualTo: date)
            .where('date', isLessThan: date.add(const Duration(hours: 23, minutes: 59)))
            .where('curriculum_id', isEqualTo: (await lesson.curriculum)!.id)
            .where('lesson_order', isEqualTo: lesson.order)
            .where('student_id', isEqualTo: student.id)
            .get())
        .docs
        .map((e) => MarkModel.fromMap(e.id, e.data()))
        .toList();
  }

  Future<List<TeacherScheduleModel>> getTeacherWeekSchedule(TeacherModel teacher, Week week) async {
    var curriculums = await _institutionRef.collection('curriculum').where('master_id', isEqualTo: teacher.id).get();
    if (curriculums.docs.isEmpty) return [];
    List<String> curriculumIds = [];
    for (var curr in curriculums.docs) {
      curriculumIds.add(curr.id);
    }
    var lessons = await _store.collectionGroup('lesson').where('curriculum_id', whereIn: curriculumIds).get();
    Map<String, List<QueryDocumentSnapshot<Map<String, dynamic>>>> schedulesMap = {};
    for (var lesson in lessons.docs) {
      var schedule = lesson.reference.parent.parent!;
      if (schedulesMap[schedule.path] == null) schedulesMap[schedule.path] = [];
      schedulesMap[schedule.path]!.add(lesson);
    }
    Map<int, TeacherScheduleModel> days = {};
    for (var schedulePath in schedulesMap.keys) {
      var schedule = await _store.doc(schedulePath).get();
      var fr = schedule.get('from') != null ? DateTime.fromMillisecondsSinceEpoch((schedule.get('from') as Timestamp).millisecondsSinceEpoch) : DateTime(2000);
      var ti = schedule.get('till') != null ? DateTime.fromMillisecondsSinceEpoch((schedule.get('till') as Timestamp).millisecondsSinceEpoch) : DateTime(3000);
      if (fr.isBefore(week.day(5)) && ti.isAfter(week.day(4))) {
        var day = schedule.get('day');
        var aclass = await schedule.reference.parent.parent!.get();
        var classmodel = ClassModel.fromMap(aclass.id, aclass.data()!);
        if (days[day] == null) {
          var schedulemodel = TeacherScheduleModel.fromMap(classmodel, schedule.id, schedule.data()!);
          days[day] = schedulemodel;
        }
        var schedulemodel = days[day]!;
        List<LessonModel> lessonsList = [];
        for (var lesson in schedulesMap[schedulePath]!) {
          var lessonmodel = LessonModel.fromMap(classmodel, schedulemodel, lesson.id, lesson.data());
          lessonsList.add(lessonmodel);
        }
        schedulemodel.addLessons(lessonsList);
      }
    }
    var res = days.values.toList();
    res.sort((a, b) => a.day.compareTo(b.day));
    return res;
  }
}
