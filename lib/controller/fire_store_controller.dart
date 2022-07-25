import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/chat_model.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/daylessontime_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/message_model.dart';
import 'package:schoosch/model/node_model.dart';
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

  Future<List<LessontimeModel>> getLessontimes(String id) async {
    List<LessontimeModel> res = [];
    var lessontimes = await _institutionRef.collection('lessontime').doc(id).collection('time').get();
    for (var lessontime in lessontimes.docs) {
      res.add(LessontimeModel.fromMap(lessontime.id, lessontime.data()));
    }
    return res;
  }

  Future<String> saveLessontime(DayLessontimeModel daylessontime, LessontimeModel lessontime) async {
    await _institutionRef.collection('lessontime').doc(daylessontime.id).collection('time').doc(lessontime.id).set(lessontime.toMap());
    return lessontime.id;
  }

  Future<void> deleteLessontime(DayLessontimeModel daylessontime, LessontimeModel lessontime) async {
    await _institutionRef.collection('lessontime').doc(daylessontime.id).collection('time').doc(lessontime.id).delete();
  }

  Future<DayLessontimeModel> getDayLessontime(String id) async {
    var res = await _institutionRef.collection('lessontime').doc(id).get();
    return DayLessontimeModel.fromMap(res.id, res.data()!);
  }

  Future<List<DayLessontimeModel>> getAllDayLessontime() async {
    List<DayLessontimeModel> res = [];
    var timenames = await _institutionRef.collection('lessontime').get();
    for (var val in timenames.docs) {
      res.add(DayLessontimeModel.fromMap(val.id, val.data()));
    }
    return res;
  }

  Future<String> saveDayLessontime(DayLessontimeModel dayLessontime) async {
    if (dayLessontime.id != null) {
      await _institutionRef.collection('lessontime').doc(dayLessontime.id).set(dayLessontime.toMap());
      return dayLessontime.id!;
    } else {
      var v = await _institutionRef.collection('class').add(dayLessontime.toMap());
      return v.id;
    }
  }

  Future<ClassModel> getClass(String id) async {
    var res = await _institutionRef.collection('class').doc(id).get();
    return ClassModel.fromMap(res.id, res.data()!);
  }

  Future<List<ClassModel>> getAllClasses() async {
    return (await _institutionRef.collection('class').orderBy('grade').get())
        .docs
        .map(
          (aclass) => ClassModel.fromMap(
            aclass.id,
            aclass.data(),
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

  Future<List<LessonModel>> getScheduleLessons(ClassModel aclass, DayScheduleModel schedule, {DateTime? date}) async {
    List<LessonModel> res = [];
    var less = (await _institutionRef.collection('class').doc(aclass.id).collection('schedule').doc(schedule.id).collection('lesson').orderBy('order').get())
        .docs
        .map((lesson) => LessonModel.fromMap(
              aclass,
              schedule,
              lesson.id,
              lesson.data(),
            ))
        .toList();
    List<ReplacementModel> reps = [];
    if (date != null) {
      reps.addAll((await getReplacementsOnDate(aclass, schedule, date)).toList());
    }

    int maxOrder = 1;
    for(var l in less) {
      if(l.order > maxOrder) {
        maxOrder = l.order;
      }
    }

    List<int> empt = List.generate(maxOrder, (index) => index + 1);
    empt.removeWhere((element) {
      for(var l in less) {
        if(l.order == element) {
          return true;
        }
      }
      return false;
    });

    for(var i in empt) {
      var nl = EmptyLesson.fromMap(aclass, schedule, '$i', i);
      nl.setAsEmpty();
      less.add(nl);
    }

    for (var l in less) {
      LessonModel? nl;
      for (var r in reps) {
        if (l.order == r.order) {
          l.setReplacedType();
          nl = r;
        }
      }
      res.add(nl ?? l);
    }
    res.sort((a, b) => a.order.compareTo(b.order),);
    return res;
  }

  Future<List<LessonModel>> getScheduleLessonsForStudent(ClassModel aclass, StudentScheduleModel schedule, StudentModel student, DateTime? date) async {
    List<LessonModel> res = [];
    var less = await getScheduleLessons(aclass, schedule, date: date);

    for (var l in less) {
      var cur = l.type == LessonType.empty ? null : await l.curriculum;
      if ((cur != null && cur.isAvailableForStudent(student.id!)) || l.type == LessonType.empty) {
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

  // Future<List<PersonModel>> getPeopleByName(String query) async {
  //   if(query.length < 2) return [];
  //   var a = await _institutionRef.collection('people').orderBy('nickname').startAt([query]).endAt([query + '\uf8ff']).get();

  // }

  Future<String> savePerson(PersonModel person) async {
    var data = person.toMap();
    if (person.asParent != null) data.addAll(person.asParent!.toMap());
    if (person.asObserver != null) data.addAll(person.asObserver!.toMap());
    if (person.id != null) {
      await _institutionRef.collection('people').doc(person.id).set(data);
      return person.id!;
    } else {
      var v = await _institutionRef.collection('people').add(data);
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

  Future<List<NodeModel>> getAllNodes() async {
    return (await _institutionRef.collection('node').get())
        .docs
        .map(
          (n) => NodeModel.fromMap(
            n.id,
            n.data(),
          ),
        )
        .toList();
  }

  Future<Map<String, List<String>>> getAllNodeConnections() async {
    Map<String, List<String>> res = {};
    var docs = (await _institutionRef.collection('connection').get()).docs;
    for (var doc in docs) {
      var nid = doc['node_id'] as String;
      res[nid] = [];
      List<dynamic> ll = doc['connection_ids'];
      for (var l in ll) {
        res[nid]!.add(l as String);
      }
    }
    return res;
  }

  Future<List<int>> getAllFloors() async {
    List<int> res = [];
    var lilst = (await _institutionRef.collection('venue').get())
        .docs
        .map(
          (e) => VenueModel.fromMap(
            e.id,
            e.data(),
          ),
        )
        .toList();
    for (var i in lilst) {
      if (!res.contains(i.floor) && i.floor != 0) {
        res.add(i.floor!);
      }
    }
    res.sort();
    return res;
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

  Stream<DocumentSnapshot> markStream(MarkModel mark) {
    var a = _institutionRef.collection('mark').doc(mark.id).snapshots();
    return a;
  }

  Future saveHomework(String homeworkText, CurriculumModel curriculum, TeacherModel teacher, DateTime date, {StudentModel? student}) async {
    Map<String, dynamic> data = {};
    data['text'] = homeworkText;
    data['student_id'] = student?.id;
    data['teacher_id'] = teacher.id;
    data['curriculum_id'] = curriculum.id;
    data['date'] = date;
    // data['checked_users'] = [];
    return _institutionRef.collection('homework').add(data);
  }

  Future updateHomeworkChecked(HomeworkModel homework) async {
    var a = _institutionRef.collection('homework').doc(homework.id).collection('completions');
    var b = await a.where('completed_by', isEqualTo: currentUser!.id).get();
    if (b.docs.isEmpty) {
      return await a.add({
        'completed_by': currentUser!.id,
        'confirmed_by': null,
        'completed_time': DateTime.now(),
        'confirmed_time': DateTime.now(),
        'status': 1,
      });
    } else {
      if ((await a.doc(b.docs[0].id).get()).data()!['status'] == 1) {
        return await a.doc(b.docs[0].id).update({
          'status': 0,
        });
      } else if ((await a.doc(b.docs[0].id).get()).data()!['status'] == 0) {
        return await a.doc(b.docs[0].id).update({
          'status': 1,
          'completed_time': DateTime.now(),
        });
      }
    }
  }

  Future<CompletionFlagModel?> hasMyCompletion(HomeworkModel hw) async {
    var a = _institutionRef.collection('homework').doc(hw.id).collection('completions');
    var b = await a.where('completed_by', isEqualTo: currentUser!.id).get();
    if (b.docs.isEmpty) {
      return null;
    } else {
      return CompletionFlagModel.fromMap(
        b.docs[0].id,
        b.docs[0].data(),
      );
    }
  }

  Future createCompletion(HomeworkModel hw) async {
    var a = _institutionRef.collection('homework').doc(hw.id).collection('completions');
    // var b = (await a.where('completed_by', isEqualTo: currentUser!.id).get()).docs.first;
    return await a.add({
      'completed_by': currentUser!.id,
      'confirmed_by': null,
      'completed_time': DateTime.now(),
      'confirmed_time': null,
      'status': 1,
    });
  }

  Future<void> completeCompletion(HomeworkModel hw, CompletionFlagModel c) async {
    var a = _institutionRef.collection('homework').doc(hw.id).collection('completions');
    return await a.doc(c.id).update({
      'completed_time': DateTime.now(),
      'status': 1,
    });
  }

  Future<CompletionFlagModel?> refreshCompletion(HomeworkModel hw, CompletionFlagModel c) async {
    var a = _institutionRef.collection('homework').doc(hw.id).collection('completions');
    var b = await a.doc(c.id).get();
    return CompletionFlagModel.fromMap(b.id, b.data()!);
  }

  Future<void> uncompleteCompletion(HomeworkModel hw, CompletionFlagModel c) async {
    var a = _institutionRef.collection('homework').doc(hw.id).collection('completions');
    return await a.doc(c.id).update({
      'status': 0,
    });
  }

  Future<void> confirmHomework(HomeworkModel homework) async {
    var a = _institutionRef.collection('homework').doc(homework.id).collection('completions');
    var b = await a.where('completed_by', isEqualTo: currentUser!.id).limit(1).get();
    if (b.docs.isNotEmpty) {
      if ((await a.doc(b.docs[0].id).get()).data()!['status'] == 1) {
        return await a.doc(b.docs[0].id).update({
          'status': 2,
        });
      }
    }
  }

  Future<void> confirmCompletion(HomeworkModel homework, CompletionFlagModel completion) async {
    var a = _institutionRef.collection('homework').doc(homework.id).collection('completions').doc(completion.id);
    return a.update({
      'status': 2,
      'confirmed_by': currentUser!.id!,
      'confirmed_time': DateTime.now(),
    });
  }

  Future<void> unconfirmCompletion(HomeworkModel homework, CompletionFlagModel completion) async {
    var a = _institutionRef.collection('homework').doc(homework.id).collection('completions').doc(completion.id);
    return a.update({
      'status': 1,
    });
  }

  // Future<void> updateHomeworkUncheck(HomeworkModel homework) {
  //   var a = _institutionRef.collection('homework').doc(homework.id);
  //   var b = (await a.get()).data()!['checked_users'];
  //   return await _institutionRef.collection('homework').doc(homework.id).update({
  //     'checked_users': [
  //       ...(b),
  //       currentUser!.id,
  //     ]
  //   });
  // }

  Future<CompletionFlagModel?> getHomeworkCompletion(HomeworkModel homework) async {
    var a = _institutionRef.collection('homework').doc(homework.id).collection('completions');
    var b = await a.where('completed_by', isEqualTo: currentUser!.id).get();
    if (b.docs.isEmpty) {
      return null;
    } else {
      return CompletionFlagModel.fromMap(
        b.docs[0].id,
        b.docs[0].data(),
      );
    }
  }

  Future<List<CompletionFlagModel>> getAllHomeworkCompletions(HomeworkModel homework) async {
    var a = await _institutionRef.collection('homework').doc(homework.id).collection('completions').get();
    return a.docs.map((e) {
      return CompletionFlagModel.fromMap(
        e.id,
        e.data(),
      );
    }).toList();
  }

  Future<double> getAverageTeacherRating(TeacherModel teacher) async {
    double sum = 0;
    var ratings = await _institutionRef.collection('teachersrates').where('teacher_id', isEqualTo: teacher.id).get();
    for (var i in ratings.docs) {
      sum += i.get('rating');
    }
    return sum / ratings.docs.length;
  }

  Future<HomeworkModel?> getLessonHomeworkForStudent(DayScheduleModel schedule, CurriculumModel curriculum, StudentModel student, DateTime date) async {
    var res = await _institutionRef
        .collection('homework')
        .where('date', isLessThan: date) //.subtract(const Duration(hours: 23, minutes: 59))
        .where('date', isLessThan: date.add(const Duration(hours: 23, minutes: 59)))
        .where('curriculum_id', isEqualTo: curriculum.id)
        .where('student_id', isEqualTo: student.id)
        .orderBy('date', descending: true)
        .limit(1)
        .get();
    return res.docs.isNotEmpty ? HomeworkModel.fromMap(res.docs[0].id, res.docs[0].data()) : null;
  }

  Future<HomeworkModel?> getLessonHomeworkForClass(DayScheduleModel schedule, CurriculumModel curriculum, DateTime date) async {
    var res = await _institutionRef
        .collection('homework')
        // .where('date', isGreaterThanOrEqualTo: schedule.date)
        .where('date', isLessThan: date)
        .where('curriculum_id', isEqualTo: curriculum.id)
        .where('student_id', isNull: true)
        .orderBy('date', descending: true)
        .limit(1)
        .get();
    return res.docs.isNotEmpty ? HomeworkModel.fromMap(res.docs[0].id, res.docs[0].data()) : null;
  }

  Future<void> updateHomework(HomeworkModel homework, String newText) async {
    var a = _institutionRef.collection('homework').doc(homework.id);
    return a.update({
      'text': newText,
    });
  }

  Future<HomeworkModel?> alreadyHasHomework(DateTime date, CurriculumModel curriculum) async {
    var res = await _institutionRef
        .collection('homework')
        .where('date', isLessThan: date.add(const Duration(hours: 12))) //.subtract(const Duration(hours: 23, minutes: 59))
        .where('date', isGreaterThan: date.subtract(const Duration(hours: 12)))
        .where('curriculum_id', isEqualTo: curriculum.id)
        .where('student_id', isNull: true)
        .orderBy('date', descending: true)
        .limit(1)
        .get();
    return res.docs.isNotEmpty ? HomeworkModel.fromMap(res.docs[0].id, res.docs[0].data()) : null;
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

  Future<void> updateMark(String docId, int newMark) async {
    return await _institutionRef.collection('mark').doc(docId).update({'mark': newMark});
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
        List<ReplacementModel> repsList = [];
        // Map<ClassModel, List<ReplacementModel>> repsList = {};
        repsList = await getAllReplacementsOnDate(
          curriculumIds,
          schedulemodel,
          week.day(schedulemodel.day - 1),
        );
        for (var lesson in schedulesMap[schedulePath]!) {
          var lessonmodel = LessonModel.fromMap(classmodel, schedulemodel, lesson.id, lesson.data());
          LessonModel? nl;
          for (var replace in repsList) {
            if (replace.order == lessonmodel.order) {
              lessonmodel.setReplacedType();
              nl = replace;
              if (curriculumIds.contains((await nl.curriculum)!.id)) {
                lessonsList.add(nl);
              }
            }
          }
          lessonsList.add(lessonmodel);
        }
        schedulemodel.addLessons(lessonsList);
      }
    }
    var res = days.values.toList();
    res.sort((a, b) => a.day.compareTo(b.day));
    return res;
  }

  Future<List<CurriculumModel>> getStudentCurriculums() async {
    List<CurriculumModel> res = [];
    var curs = await getAllCurriculums();
    for (var cur in curs) {
      if (cur.isAvailableForStudent(currentUser!.id!)) {
        res.add(cur);
      }
    }
    return res;
  }

  Future<List<CurriculumModel>> getClassCurriculums(ClassModel clas) async {
    List<CurriculumModel> res = [];
    var curs = await getAllCurriculums();
    for (var cur in curs) {
      if ((await cur.classes()).contains(clas)) {
        res.add(cur);
      }
    }
    return res;
  }

  Future<List<MarkModel>> getCurriculumMarks(CurriculumModel cur) async {
    var marks = await _institutionRef.collection('mark').where('curriculum_id', isEqualTo: cur.id).where('student_id', isEqualTo: currentUser!.id).get();
    return marks.docs
        .map(
          (e) => MarkModel.fromMap(
            e.id,
            e.data(),
          ),
        )
        .toList();
  }

  Future<List<CurriculumModel>> getTeacherCurriculums() async {
    var curriculums = await _institutionRef.collection('curriculum').where('master_id', isEqualTo: currentUser!.id).get();
    return curriculums.docs
        .map(
          (e) => CurriculumModel.fromMap(
            e.id,
            e.data(),
          ),
        )
        .toList();
  }

  // Future<List<StudentModel>> getCurriculumStudents(CurriculumModel cur) {
  //   currentUser!.asTeacher.
  // }

  Future<List<MarkModel>> getStudentsMarks(StudentModel student, CurriculumModel cur) async {
    var marks = await _institutionRef
        .collection('mark')
        .where('student_id', isEqualTo: student.id)
        .where('teacher_id', isEqualTo: currentUser!.id)
        .where('curriculum_id', isEqualTo: cur.id)
        .get();
    return marks.docs
        .map(
          (e) => MarkModel.fromMap(
            e.id,
            e.data(),
          ),
        )
        .toList();
  }

  Future<List<ClassModel>> getCurriculumClasses(CurriculumModel curriculum) async {
    List<ClassModel> res = [];
    var r = await _store.collectionGroup('lesson').where('curriculum_id', isEqualTo: curriculum.id).get();
    for (var les in r.docs) {
      var c = await les.reference.parent.parent!.parent.parent!.get();
      var cl = ClassModel.fromMap(c.id, c.data()!);
      if (!res.contains(cl)) {
        res.add(cl);
      }
    }
    return res;
  }

  Stream<List<ChatModel>> getUserChatRooms() {
    return _institutionRef.collection('chats').where('people_ids', arrayContains: currentUser!.id).snapshots().asyncMap((event) async {
      List<ChatModel> res = [];
      for (var i in event.docs) {
        List<PersonModel> users = [];
        for (var uid in i.data()['people_ids']) {
          var u = await getPerson(uid);
          users.add(u);
        }
        res.add(
          ChatModel.fromMap(i.id, users),
        );
      }
      return res;
    });
  }

  Future<void> createChatRoom(PersonModel other) async {
    await _institutionRef.collection('chats').add({
      'people_ids': [
        other.id,
        currentUser!.id,
      ],
    });
  }

  Future<bool> checkExistance(PersonModel u) async {
    var a = await _institutionRef.collection('chats').where('people_ids', isEqualTo: [u.id, _currentUser!.id]).get();
    return a.docs.isNotEmpty;
  }

  Stream<List<MessageModel>> getChatroomMessages(ChatModel cm) {
    return _institutionRef.collection('chats').doc(cm.id).collection('messages').orderBy('timestamp', descending: true).snapshots().asyncMap((event) async {
      List<MessageModel> messages = [];
      for (var m in event.docs) {
        MessageModel mes = MessageModel.fromMap(m.id, m.data());
        messages.add(mes);
      }
      // messages.sort((m1, m2) {
      //   return m1.timeSent!.compareTo(m2.timeSent!);
      // });
      return messages;
    });
  }

  Future<void> addMessage(ChatModel cm, Map<String, dynamic> mdata) async {
    await _institutionRef.collection('chats').doc(cm.id).collection('messages').add({
      'message': mdata['message'],
      'sent_by': currentUser!.id!,
      'timestamp': DateTime.now(),
    });
  }

  Future<void> createReplacement(ClassModel aclass, Map<String, dynamic> map) async {
    await _institutionRef.collection('class').doc(aclass.id).collection('replace').add({
      'order': map['order'],
      'curriculum_id': map['curriculum_id'],
      'teacher_id': map['teacher_id'],
      'venue_id': map['venue_id'],
      'date': map['date'],
    });
  }

  Future<List<ReplacementModel>> getReplacementsOnDate(ClassModel aclass, DayScheduleModel schedule, DateTime date) async {
    var a = await _institutionRef
        .collection('class')
        .doc(aclass.id)
        .collection('replace')
        .where('date', isGreaterThanOrEqualTo: date)
        .where(
          'date',
          isLessThan: date.add(
            const Duration(hours: 23, minutes: 59),
          ),
        )
        .get();
    List<ReplacementModel> res = [];
    if (a.docs.isNotEmpty) {
      for (var r in a.docs) {
        var repl = ReplacementModel.fromMap(aclass, schedule, r.id, r.data());
        repl.setAsReplacement();
        res.add(repl);
      }
    }
    return res;
  }

  Future<List<ReplacementModel>> getAllReplacementsOnDate(List<String> curriculumIds, DayScheduleModel schedule, DateTime date) async {
    List<ReplacementModel> res = [];
    var a = await _institutionRef.collection('class').get();
    for (var clas in a.docs) {
      ClassModel aclas = ClassModel.fromMap(clas.id, clas.data());
      var reps = await getReplacementsOnDate(aclas, schedule, date);
      res.addAll(reps);
    }
    return res;
  }

  Future<List<PersonModel>> getFreeTeachersOnLesson(DateTime date, int order) async {
    List<PersonModel> res = [];
    var a = await getAllCurriculums();
    for (var cur in a) {
      var mast = await cur.master;
      var weekschedule = await getTeacherWeekSchedule(mast!, Week.fromDate(date));
      var schedules = weekschedule.where((element) => element.day == date.weekday).toList();
      if (schedules.isNotEmpty) {
        var less = await schedules.first.getLessons();
        var d = less.where((element) => element.order == order);
        if (d.isEmpty) {
          res.add(mast);
        }
      }
    }
    return res;
  }

  Future<List<int>> getFreeLessonsOnDay(ClassModel aclass, DateTime date) async {
    List<int> res = [];
    var a = (await getClassDaySchedule(aclass, date.weekday)).where((element) => element.till == null).first;
    var b = await getScheduleLessons(aclass, a);
    for(var l in b) {
      if(l.type == LessonType.empty) {
        res.add(l.order);
      }
    }
    return res;
  }
}
