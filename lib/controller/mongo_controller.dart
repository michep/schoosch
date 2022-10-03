import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart' as isoweek;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/absence_model.dart';
import 'package:schoosch/model/chat_model.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/message_model.dart';
import 'package:schoosch/model/node_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:http/http.dart' as http;

extension EmptyObjectId on ObjectId {
  static const String _emptyHex = 'FFFFFFFFFFFFFFFFFFFFFFFF';

  bool get isEmpty => toHexString() == _emptyHex;
  ObjectId empty() {
    return ObjectId.fromHexString(_emptyHex);
  }
}

class MStore extends GetxController {
  late final Db _db;
  // late final FirebaseStorage _fstorage;
  // late Reference _fstorageRef;
  // late Uint8List? _logoImagData;
  PersonModel? _currentUser;
  InstitutionModel? _institution;

  Db get db => _db;

  MStore() {
    // _db = Db('mongodb://mongo:1qsx!QSX@rc1b-ualxw106ib10l1e0.mdb.yandexcloud.net:27018/schoosch?replicaSet=rs01&authSource=schoosch');
    _db = Db('mongodb://mongo:1qsx!QSX@rc1b-ualxw106ib10l1e0.mdb.yandexcloud.net:27018/schoosch');
  }

  PersonModel? get currentUser => _currentUser;
  InstitutionModel? get currentInstitution => _institution;

  Future<void> init(String userEmail) async {
    if (db.state == State.INIT) await _db.open(secure: true, tlsAllowInvalidCertificates: true);
    // _institution = await _geInstitutionIdByUserEmail(userEmail);
    // _currentUser = await _getUserByEmail(userEmail);
  }

  Future<void> reset() async {
    return init(_currentUser!.email);
  }

  void resetCurrentUser() {
    _currentUser = null;
  }

  // Future<List<LessontimeModel>> getLessontimes(String id) async {
  //   var mid = ObjectId.fromHexString(id);
  //   return _db.collection('time').find(where.eq('lessontime_id', mid)).map((lessontime) => LessontimeModel.fromMap(lessontime['_id'], lessontime)).toList();
  // }

  // Future<String> saveLessontime(DayLessontimeModel daylessontime, LessontimeModel lessontime) async {
  //   var data = lessontime.toMap();
  //   data['institution_id'] = _institution!.id;
  //   data['lessontime_id'] = daylessontime.id!;
  //   var ret = await _db.collection('time').updateOne(where.eq('_id', lessontime.id), data, upsert: true);
  //   return (ret.document!['_id'] as ObjectId).toHexString();
  // }

  // Future<void> deleteLessontime(DayLessontimeModel daylessontime, LessontimeModel lessontime) async {
  //   await _db.collection('lessontime').deleteOne(where.eq('_id', ObjectId.fromHexString(lessontime.id)));
  // }

  // Future<DayLessontimeModel> getDayLessontime(String id) async {
  //   var mid = ObjectId.fromHexString(id);
  //   var data = await _db.collection('lessontime').findOne(where.eq('_id', mid));
  //   return DayLessontimeModel.fromMap((data!['_id'] as ObjectId).toHexString(), data);
  // }

  // Future<List<DayLessontimeModel>> getAllDayLessontime() async {
  //   return _db.collection('lessontime').find().map((data) => DayLessontimeModel.fromMap((data['_id'] as ObjectId).toHexString(), data)).toList();
  // }

  // Future<String> saveDayLessontime(DayLessontimeModel dayLessontime) async {
  //   var data = dayLessontime.toMap();
  //   data['institution_id'] = ObjectId.fromHexString(_institution!.id);
  //   if (dayLessontime.id == null) {
  //     return ((await _db.collection('lessontime').insertOne(data)).id as ObjectId).toHexString();
  //   } else {
  //     data['_id'] = ObjectId.fromHexString(dayLessontime.id!);
  //     await _db.collection('lessontime').replaceOne(where.eq('_id', data['_id']), data);
  //     return dayLessontime.id!;
  //   }
  // }

  // Future<ClassModel> getClass(String id) async {
  //   var mid = ObjectId.fromHexString(id);
  //   var data = await _db.collection('class').findOne(where.eq('_id', mid));
  //   return ClassModel.fromMap((data!['_id'] as ObjectId).toHexString(), data);
  // }

  // Future<List<ClassModel>> getAllClasses() async {
  //   return _db.collection('class').find().map((data) {
  //     return ClassModel.fromMap((data['_id'] as ObjectId).toHexString(), data);
  //   }).toList();
  // }

  // Future<String> saveClass(ClassModel aclass) async {
  //   var data = aclass.toMap();
  //   data['institution_id'] = ObjectId.fromHexString(_institution!.id);
  //   if (aclass.id == null) {
  //     return (await _db.collection('class').insertOne(data)).id;
  //   } else {
  //     data['_id'] = ObjectId.fromHexString(aclass.id!);
  //     await _db.collection('class').replaceOne(where.eq('_id', data['_id']), data);
  //     return aclass.id!;
  //   }
  // }

  // Future<List<StudentScheduleModel>> getClassWeekSchedule(ClassModel aclass, isoweek.Week currentWeek) async {
  //   return _db
  //       .collection('schedule')
  //       .find(where.eq('class_id', aclass.id!).sortBy('day'))
  //       .map((data) => StudentScheduleModel.fromMap(aclass, (data['_id'] as ObjectId).toHexString(), data))
  //       .where((data) => data.from!.isBefore(currentWeek.day(5)) && (data.till == null || data.till!.isAfter(currentWeek.day(4))))
  //       .toList();
  // }

  // Future<List<StudentScheduleModel>> getClassDaySchedule(ClassModel aclass, int day) async {
  //   return _db
  //       .collection('schedule')
  //       .find(where.eq('class_id', aclass.id))
  //       .map((data) => StudentScheduleModel.fromMap(
  //             aclass,
  //             (data['_id'] as ObjectId).toHexString(),
  //             data,
  //           ))
  //       .where((data) => data.day == day)
  //       .toList();
  // }

  // Future<String> saveDaySchedule(DayScheduleModel schedule) async {
  //   var data = schedule.toMap();
  //   data['institution_id'] = ObjectId.fromHexString(_institution!.id);
  //   data['class_id'] = ObjectId.fromHexString(schedule.aclass.id!);
  //   if (schedule.id == null) {
  //     return ((await _db.collection('schedule').insertOne(data)).id as ObjectId).toHexString();
  //   } else {
  //     data['_id'] = ObjectId.fromHexString(schedule.id!);
  //     await _db.collection('schedule').replaceOne(where.eq('_id', data['_id']), data);
  //     return schedule.id!;
  //   }
  // }

  // Future<List<LessonModel>> getScheduleLessons(ClassModel aclass, DayScheduleModel schedule, {DateTime? date, bool needsEmpty = false}) async {
  //   List<LessonModel> res = [];
  //   var less = await _db
  //       .collection('lesson')
  //       .find(where.eq('class_id', aclass.id).eq('schedule_id', schedule.id))
  //       .map((data) => LessonModel.fromMap(aclass, schedule, (data['_id'] as ObjectId).toHexString(), data))
  //       .toList();

  //   List<ReplacementModel> reps = [];
  //   if (date != null) {
  //     reps.addAll((await getReplacementsOnDate(aclass, schedule, date)).toList());
  //   }

  //   if (needsEmpty) {
  //     int maxOrder = 1;
  //     for (var l in less) {
  //       if (l.order > maxOrder) {
  //         maxOrder = l.order;
  //       }
  //     }

  //     List<int> empt = List.generate(maxOrder, (index) => index + 1);
  //     empt.removeWhere((element) {
  //       for (var l in less) {
  //         if (l.order == element) {
  //           return true;
  //         }
  //       }
  //       return false;
  //     });

  //     for (var i in empt) {
  //       var nl = EmptyLesson.fromMap(aclass, schedule, null, i);
  //       nl.setAsEmpty();
  //       less.add(nl);
  //     }
  //   }

  //   for (var l in less) {
  //     LessonModel? nl;
  //     for (var r in reps) {
  //       if (l.order == r.order) {
  //         l.setReplacedType();
  //         nl = r;
  //       }
  //     }
  //     res.add(nl ?? l);
  //   }
  //   res.sort(
  //     (a, b) => a.order.compareTo(b.order),
  //   );
  //   return res;
  // }

  // Future<List<LessonModel>> getScheduleLessonsForStudent(ClassModel aclass, StudentScheduleModel schedule, StudentModel student, DateTime? date) async {
  //   List<LessonModel> res = [];
  //   var less = await getScheduleLessons(aclass, schedule, date: date, needsEmpty: true);

  //   for (var l in less) {
  //     var cur = l.type == LessonType.empty ? null : await l.curriculum;
  //     if ((cur != null && await cur.isAvailableForStudent(student)) || l.type == LessonType.empty) {
  //       res.add(l);
  //     }
  //   }
  //   return res;
  // }

  // Future<String> saveLesson(LessonModel lesson) async {
  //   var data = lesson.toMap();
  //   data['institution_id'] = ObjectId.fromHexString(_institution!.id);
  //   data['class_id'] = ObjectId.fromHexString(lesson.aclass.id!);
  //   data['schedule_id'] = ObjectId.fromHexString(lesson.schedule.id!);
  //   if (lesson.id == null) {
  //     return ((await _db.collection('lesson').insertOne(data)).id as ObjectId).toHexString();
  //   } else {
  //     data['_id'] = ObjectId.fromHexString(lesson.id!);
  //     await _db.collection('lesson').replaceOne(where.eq('_id', data['_id']), data);
  //     return lesson.id!;
  //   }
  // }

  // Future<void> deleteLesson(LessonModel lesson) async {
  //   if (lesson.id != null) {
  //     _db.collection('lesson').deleteOne(where.eq('_id', lesson.id!));
  //   }
  // }

  // Future<PersonModel> getPerson(String id) async {
  //   var mid = ObjectId.fromHexString(id);
  //   var res = await _db.collection('people').findOne(where.eq('_id', mid));
  //   return PersonModel.fromMap((res!['_id'] as ObjectId).toHexString(), res);
  // }

  // Future<List<PersonModel>> getAllPeople() async {
  //   return _db.collection('people').find().map((data) => PersonModel.fromMap((data['_id'] as ObjectId).toHexString(), data)).toList();
  // }

  // Future<List<PersonModel>> getPeopleByIds(List<String> ids) async {
  //   List<PersonModel> res = [];
  //   for (var id in ids) {
  //     var p = await getPerson(id);
  //     res.add(p);
  //   }
  //   return res;
  // }

  // Future<String> savePerson(PersonModel person) async {
  //   var data = person.toMap();
  //   if (person.asParent != null) data.addAll(person.asParent!.toMap());
  //   if (person.asObserver != null) data.addAll(person.asObserver!.toMap());
  //   data['institution_id'] = ObjectId.fromHexString(_institution!.id);
  //   if (person.id == null) {
  //     return ((await _db.collection('people').insertOne(data)).id as ObjectId).toHexString();
  //   } else {
  //     data['_id'] = ObjectId.fromHexString(person.id!);
  //     await _db.collection('people').replaceOne(where.eq('_id', data['_id']), data);
  //     return person.id!;
  //   }
  // }

  // Future<List<CurriculumModel>> getAllCurriculums() async {
  //   return _db.collection('curriculum').find().map((curriculum) => CurriculumModel.fromMap((curriculum['_id'] as ObjectId).toHexString(), curriculum)).toList();
  // }

  // Future<CurriculumModel> getCurriculum(String id) async {
  //   var mid = ObjectId.fromHexString(id);
  //   var data = await _db.collection('curriculum').findOne(where.eq('_id', mid));
  //   return CurriculumModel.fromMap((data!['_id'] as ObjectId).toHexString(), data);
  // }

  // Future<String> saveCurriculum(CurriculumModel curriculum) async {
  //   var data = curriculum.toMap();
  //   data['institution_id'] = ObjectId.fromHexString(_institution!.id);
  //   if (curriculum.id == null) {
  //     return ((await _db.collection('curriculum').insertOne(data)).id as ObjectId).toHexString();
  //   } else {
  //     data['_id'] = ObjectId.fromHexString(curriculum.id!);
  //     await _db.collection('curriculum').replaceOne(where.eq('_id', data['_id']), data);
  //     return curriculum.id!;
  //   }
  // }

  // Future<List<VenueModel>> getAllVenues() async {
  //   return _db.collection('venue').find().map((venue) => VenueModel.fromMap((venue['_id'] as ObjectId).toHexString(), venue)).toList();
  // }

  Future<List<NodeModel>> getAllNodes() async {
    return _db.collection('node').find().map((data) => NodeModel.fromMap((data['_id'] as ObjectId).toHexString(), data)).toList();
  }

  Future<Map<String, List<String>>> getAllNodeConnections() async {
    Map<String, List<String>> res = {};
    var docs = await _db.collection('connection').find().toList();
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
    var lilst = await Get.find<ProxyStore>().getAllVenues();
    for (var i in lilst) {
      if (!res.contains(i.floor) && i.floor != 0) {
        res.add(i.floor!);
      }
    }
    res.sort();
    return res;
  }

  // Future<String> saveVenue(VenueModel venue) async {
  //   var data = venue.toMap();
  //   data['institution_id'] = ObjectId.fromHexString(_institution!.id);
  //   if (venue.id == null) {
  //     return ((await _db.collection('venue').insertOne(data)).id as ObjectId).toHexString();
  //   } else {
  //     data['_id'] = ObjectId.fromHexString(venue.id!);
  //     await _db.collection('venue').replaceOne(where.eq('_id', data['_id']), data);
  //     return venue.id!;
  //   }
  // }

  // Future<VenueModel> getVenue(String id) async {
  //   var mid = ObjectId.fromHexString(id);
  //   var res = await _db.collection('venue').findOne(where.eq('_id', mid));
  //   return VenueModel.fromMap((res!['_id'] as ObjectId).toHexString(), res);
  // }

  // Future<void> deleteVenue(VenueModel venue) async {
  //   if (venue.id != null) {
  //     await _db.collection('venue').deleteOne(where.eq('_id', venue.id));
  //   }
  // }

  // Future<InstitutionModel> _geInstitutionIdByUserEmail(String email) async {
  //   var res = await _db.collection('people').findOne(where.eq('email', email));
  //   if (res == null) {
  //     throw 'User with provided email was not found in any Institution';
  //   }
  //   res = await _db.collection('institution').findOne(where.eq('_id', res['institution_id']));
  //   if (res == null) {
  //     throw 'Institution was not found';
  //   }
  //   return InstitutionModel.fromMap((res['_id'] as ObjectId).toHexString(), res);
  // }

  // Future<PersonModel> _getUserByEmail(String email) async {
  //   var res = await _db.collection('people').findOne(where.eq('email', email));
  //   if (res == null) {
  //     throw 'User with provided email was not found in current Institution';
  //   }
  //   return PersonModel.fromMap((res['_id'] as ObjectId).toHexString(), res);
  // }

  // Future<ClassModel?> getClassForStudent(PersonModel student) async {
  //   var res = await _db.collection('class').findOne(where.eq('student_ids', ObjectId.fromHexString(student.id!)));
  //   return res == null ? null : ClassModel.fromMap((res['_id'] as ObjectId).toHexString(), res);
  // }

  // Future<Map<TeacherModel, List<String>>> getClassTeachers(ClassModel aclass) async {
  //   var teachers = <TeacherModel, List<String>>{};
  //   var mast = await aclass.master;
  //   if (mast != null) {
  //     teachers[mast] = [
  //       'Классный руководитель',
  //     ];
  //   }
  //   var cw = Get.find<CurrentWeek>().currentWeek; //TODO: currentWeek should be parameter
  //   var days = await aclass.getSchedulesWeek(cw);
  //   for (var day in days) {
  //     var dayles = await day.lessonsForStudent(PersonModel.currentStudent!);
  //     for (var les in dayles) {
  //       var cur = await les.curriculum;
  //       var teach = await cur!.master;
  //       if (teach != null) {
  //         if (teachers[teach] == null) {
  //           teachers[teach] = [cur.aliasOrName];
  //         } else if (!teachers[teach]!.contains(cur.aliasOrName)) {
  //           teachers[teach]!.add(cur.aliasOrName);
  //         }
  //       }
  //     }
  //   }
  //   return teachers;
  // }

  // Future<void> saveTeacherRating(TeacherModel teacher, PersonModel user, DateTime date, int rating, String comment) async {
  //   Map<String, dynamic> data = {};
  //   data['ratedate'] = date;
  //   data['rater_id'] = user.id;
  //   data['rating'] = rating;
  //   data['teacher_id'] = teacher.id;
  //   data['commentary'] = comment;
  //   await _db.collection('teachersrates').insert(data);
  // }

  // Future<String> saveHomework(HomeworkModel homework) async {
  //   var data = homework.toMap();
  //   data['institution_id'] = ObjectId.fromHexString(_institution!.id);
  //   if (homework.id == null) {
  //     return ((await _db.collection('homework').insertOne(data)).id as ObjectId).toHexString();
  //   } else {
  //     data['_id'] = ObjectId.fromHexString(homework.id!);
  //     await _db.collection('venue').replaceOne(where.eq('_id', data['_id']), data);
  //     return homework.id!;
  //   }
  // }

  // Future<void> createCompletion(HomeworkModel homework, StudentModel student) async {
  //   var data = {
  //     'completedby_id': student.id,
  //     'completed_time': DateTime.now(),
  //     'confirmedby_id': null,
  //     'confirmed_time': null,
  //     'status': 1,
  //     'homework_id': homework.id,
  //     'institution_id': _institution!.id,
  //   };
  //   await _db.collection('completion').insertOne(data);
  // }

  // Future<void> deleteCompletion(HomeworkModel homework, StudentModel student) async {
  //   await _db.collection('completion').deleteOne(where.eq('homework_id', homework.id).eq('completedby_id', student.id));
  // }

  // Future<void> confirmCompletion(HomeworkModel homework, CompletionFlagModel completion, PersonModel person) async {
  //   var data = await _db.collection('completion').findOne(where.eq('_id', completion.id));
  //   data!['status'] = 2;
  //   data['confirmedby_id'] = person.id;
  //   data['confirmed_time'] = DateTime.now();
  //   await _db.collection('completion').replaceOne(where.eq('_id', completion.id), data);
  //   return;
  // }

  // Future<void> unconfirmCompletion(HomeworkModel homework, CompletionFlagModel completion, PersonModel person) async {
  //   var data = await _db.collection('completion').findOne(where.eq('_id', completion.id));
  //   data!['status'] = 1;
  //   data['confirmedby_id'] = person.id;
  //   data['confirmed_time'] = null;
  //   await _db.collection('completion').replaceOne(where.eq('_id', completion.id), data);
  //   return;
  // }

  // Future<CompletionFlagModel?> getHomeworkCompletion(HomeworkModel homework, StudentModel student) async {
  //   var data = await _db.collection('completion').findOne(where.eq('homework_id', homework.id).eq('completedby_id', student.id));
  //   return data == null ? null : CompletionFlagModel.fromMap((data['_id'] as ObjectId).toHexString(), data);
  // }

  // Future<List<CompletionFlagModel>> getAllHomeworkCompletions(HomeworkModel homework) async {
  //   return _db
  //       .collection('completion')
  //       .find(where.eq('homework_id', homework.id))
  //       .map((data) => CompletionFlagModel.fromMap((data['_id'] as ObjectId).toHexString(), data))
  //       .toList();
  // }

  // Future<double> getAverageTeacherRating(TeacherModel teacher) async {
  //   double sum = 0;
  //   var ratings = await _db.collection('teachersrates').find().toList();
  //   for (var i in ratings) {
  //     sum += i['rating'];
  //   }
  //   return sum / ratings.length;
  // }

  // Future<bool> hasRatingInMonth(TeacherModel teacher) async {
  //   var data = await _db.collection('teacherrates').findOne(where.eq('teacher_id', teacher.id).lt('ratedate', DateTime.now()));
  //   if (data == null) return true;
  //   var d = data['ratedate'] as DateTime;
  //   return (d.year == DateTime.now().year && d.month == DateTime.now().month);
  // }

  // Future<HomeworkModel?> getHomeworkForStudentBeforeDate(ClassModel aclass, CurriculumModel curriculum, StudentModel student, DateTime date) async {
  //   var data = await _db
  //       .collection('homework')
  //       .findOne(where.eq('curriculum_id', curriculum.id).eq('class_id', aclass.id).eq('student_id', student.id).lt('date', date).sortBy('date'));
  //   return data == null ? null : HomeworkModel.fromMap((data['_id'] as ObjectId).toHexString(), data);
  // }

  // Future<HomeworkModel?> getHomeworkForClassBeforeDate(ClassModel aclass, CurriculumModel curriculum, DateTime date) async {
  //   var data = await _db
  //       .collection('homework')
  //       .findOne(where.eq('curriculum_id', curriculum.id).eq('class_id', aclass.id).eq('student_id', null).lt('date', date).sortBy('date'));
  //   return data == null ? null : HomeworkModel.fromMap((data['_id'] as ObjectId).toHexString(), data);
  // }

  // Future<HomeworkModel?> getHomeworkForStudentOnDate(ClassModel aclass, CurriculumModel curriculum, StudentModel student, DateTime date) async {
  //   var data = await _db.collection('homework').findOne(where
  //       .eq('curriculum_id', curriculum.id)
  //       .eq('class)id', aclass.id)
  //       .eq('student_id', student.id)
  //       .gte('date', date)
  //       .lt('date', date.add(const Duration(hours: 24)))
  //       .sortBy('date'));
  //   return data == null ? null : HomeworkModel.fromMap((data['_id'] as ObjectId).toHexString(), data);
  // }

  // Future<HomeworkModel?> getHomeworkForClassOnDate(ClassModel aclass, CurriculumModel curriculum, DateTime date) async {
  //   var data = await _db.collection('homework').findOne(where
  //       .eq('curriculum_id', curriculum.id)
  //       .eq('class)id', aclass.id)
  //       .eq('student_id', null)
  //       .gte('date', date)
  //       .lt('date', date.add(const Duration(hours: 24)))
  //       .sortBy('date'));
  //   return data == null ? null : HomeworkModel.fromMap((data['_id'] as ObjectId).toHexString(), data);
  // }

  // Future<void> updateHomework(HomeworkModel homework, String newText) async {
  //   await _db.collection('homework').updateOne(where.eq('_id', homework.id), modify.set('text', newText));
  // }

  Future<List<TeacherScheduleModel>> getTeacherWeekSchedule(TeacherModel teacher, isoweek.Week week) async {
    var aggr = AggregationPipelineBuilder()
        .addStage(Match(where.eq('master_id', teacher.id).map['\$query']))
        .addStage(Lookup(from: 'lesson', localField: '_id', foreignField: 'curriculum_id', as: 'lesson'))
        .addStage(Unwind(const Field('lesson')))
        .addStage(Lookup(from: 'schedule', localField: 'lesson.schedule_id', foreignField: '_id', as: 'schedule'))
        .addStage(
            Match(where.lt('schedule.from', DateTime.now()).and(where.eq('schedule.till', null).or(where.gte('schedule.till', DateTime.now()))).map['\$query']))
        .addStage(Unwind(const Field('schedule')))
        .addStage(Group(id: {
          'day': const Field('schedule.day'),
        }, fields: {
          'schedule': AddToSet(const Field('schedule')),
          'class_id': AddToSet(const Field('schedule.class_id')),
          'institution_id': First(const Field('institution_id')),
          'lesson': AddToSet(const Field('lesson')),
        }))
        .build();

    var rawData = await _db.collection('curriculum').aggregateToStream(aggr).toList();

    List<String> curriculumIds = (await _db
            .collection('curriculum')
            .find(
              where.eq(
                'master_id',
                teacher.id,
              ),
            )
            .toList())
        .map(
          (e) => (e['_id'] as ObjectId).toHexString(),
        )
        .toList();
    var res = <TeacherScheduleModel>[];
    for (var data in rawData) {
      var schedule = TeacherScheduleModel.fromMap(
        await Get.find<ProxyStore>().getClass((data['class_id'][0] as ObjectId).toHexString()),
        (data['schedule'][0]['_id'] as ObjectId).toHexString(),
        data['schedule'][0],
      );
      List<LessonModel> lessonsList = [];
      List<ReplacementModel> repsList = [];
      repsList = await Get.find<ProxyStore>().getAllReplacementsOnDate(
        schedule,
        week.day(schedule.day - 1),
      );
      for (var lesson in data['lesson']) {
        var lessonmodel = LessonModel.fromMap(
          await Get.find<ProxyStore>().getClass((lesson['class_id'] as ObjectId).toHexString()),
          schedule,
          lesson['_id'],
          lesson,
        );
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
      schedule.addLessons(lessonsList);
      res.add(schedule);
    }
    res.sort((a, b) => a.day.compareTo(b.day));

    return res;
  }

  Future<List<CurriculumModel>> getStudentCurriculums(StudentModel student) async {
    var aggr = AggregationPipelineBuilder()
        .addStage(Lookup(from: 'lesson', localField: '_id', foreignField: 'curriculum_id', as: 'lesson'))
        .addStage(Unwind(const Field('lesson')))
        .addStage(Lookup(from: 'schedule', localField: 'lesson.schedule_id', foreignField: '_id', as: 'schedule'))
        .addStage(Unwind(const Field('schedule')))
        .addStage(
            Match(where.lt('schedule.from', DateTime.now()).and(where.eq('schedule.till', null).or(where.gte('schedule.till', DateTime.now()))).map['\$query']))
        .addStage(Lookup(from: 'class', localField: 'lesson.class_id', foreignField: '_id', as: 'class'))
        .addStage(Unwind(const Field('class')))
        .addStage(Match(where.eq('class.student_ids', student.id).map['\$query']))
        .addStage(Group(id: {
          'curriculum_id': const Field('_id'),
          'alias': const Field('alias'),
          'master_id': const Field('master_id'),
          'lessontime_id': const Field('lessontime_id'),
          'name': const Field('name'),
          'institution_id': const Field('institution_id'),
        }))
        .addStage(Sort({'_id.name': 1}))
        .build();
    return _db
        .collection('curriculum')
        .aggregateToStream(aggr)
        .map((data) => CurriculumModel.fromMap((data['_id']['curriculum_id'] as ObjectId).toHexString(), data['_id']))
        .toList();
  }

  Future<List<CurriculumModel>> getClassCurriculums(ClassModel aclass) async {
    var aggr = AggregationPipelineBuilder()
        .addStage(Lookup(from: 'lesson', localField: '_id', foreignField: 'curriculum_id', as: 'lesson'))
        .addStage(Unwind(const Field('lesson')))
        .addStage(Lookup(from: 'schedule', localField: 'lesson.schedule_id', foreignField: '_id', as: 'schedule'))
        .addStage(Unwind(const Field('schedule')))
        .addStage(
            Match(where.lt('schedule.from', DateTime.now()).and(where.eq('schedule.till', null).or(where.gte('schedule.till', DateTime.now()))).map['\$query']))
        .addStage(Lookup(from: 'class', localField: 'lesson.class_id', foreignField: '_id', as: 'class'))
        .addStage(Match(where.eq('class._id', aclass.id).map['\$query']))
        .addStage(Group(id: {
          'curriculum_id': const Field('_id'),
          'alias': const Field('alias'),
          'master_id': const Field('master_id'),
          'lessontime_id': const Field('lessontime_id'),
          'name': const Field('name'),
          'institution_id': const Field('institution_id'),
        }))
        .addStage(Sort({'_id.name': 1}))
        .build();
    return _db.collection('curriculum').aggregateToStream(aggr).map((data) => CurriculumModel.fromMap(data['_id']['curriculum_id'], data['_id'])).toList();
  }

  Future<List<CurriculumModel>> getTeacherCurriculums(TeacherModel teacher) async {
    return _db
        .collection('curriculum')
        .find(where.eq('master_id', teacher.id))
        .map((data) => CurriculumModel.fromMap((data['_id'] as ObjectId).toHexString(), data))
        .toList();
  }

  // Future<List<MarkModel>> getAllLessonMarks(LessonModel lesson, DateTime date) async {
  //   return _db
  //       .collection('mark')
  //       .find(where
  //           .eq('curriculum_id', (await lesson.curriculum)!.id)
  //           .eq('lesson_order', lesson.order)
  //           .gte('date', date)
  //           .lt('date', date.add(const Duration(hours: 24))))
  //       .map((data) => MarkModel.fromMap((data['_id'] as ObjectId).toHexString(), data))
  //       .toList();
  // }

  // Future<List<MarkModel>> getStudentLessonMarks(LessonModel lesson, StudentModel student, DateTime date) async {
  //   return _db
  //       .collection('mark')
  //       .find(where
  //           .eq('curriculum_id', (await lesson.curriculum)!.id)
  //           .eq('lesson_order', lesson.order)
  //           .eq('student_id', student.id)
  //           .gte('date', date)
  //           .lt('date', date.add(const Duration(hours: 24))))
  //       .map((data) => MarkModel.fromMap((data['_id'] as ObjectId).toHexString(), data))
  //       .toList();
  // }

  // Future<List<MarkModel>> getStudentCurriculumMarks(StudentModel student, CurriculumModel curriculum) async {
  //   return _db
  //       .collection('mark')
  //       .find(where.eq('curriculum_id', curriculum.id).eq('student_id', student.id))
  //       .map((data) => MarkModel.fromMap((data['_id'] as ObjectId).toHexString(), data))
  //       .toList();
  // }

  // Future<List<MarkModel>> getStudentCurriculumTeacherMarks(StudentModel student, CurriculumModel curriculum, TeacherModel teacher) async {
  //   return _db
  //       .collection('mark')
  //       .find(where.eq('curriculum_id', curriculum.id).eq('student_id', student.id).eq('teacher_id', teacher.id))
  //       .map((data) => MarkModel.fromMap((data['_id'] as ObjectId).toHexString(), data))
  //       .toList();
  // }

  // Future<void> updateMark(String docId, int newMark) async {
  //   await _db.collection('mark').updateOne(where.eq('_id', ObjectId.fromHexString(docId)), modify.set('mark', newMark));
  // }

  // Future<String> saveMark(MarkModel mark) async {
  //   var data = mark.toMap();
  //   data['institution_id'] = ObjectId.fromHexString(_institution!.id);
  //   if (mark.id == null) {
  //     return ((await _db.collection('mark').insertOne(data)).id as ObjectId).toHexString();
  //   } else {
  //     data['_id'] = ObjectId.fromHexString(mark.id!);
  //     await _db.collection('mark').replaceOne(where.eq('_id', data['_id']), data);
  //     return mark.id!;
  //   }
  // }

  // Future<void> deleteMark(MarkModel mark) async {
  //   if (mark.id != null) {
  //     await _db.collection('mark').deleteOne(where.eq('_id', mark.id));
  //   }
  // }

  Future<List<ClassModel>> getCurriculumClasses(CurriculumModel curriculum) async {
    var aggr = AggregationPipelineBuilder()
        .addStage(Match(where.eq('_id', curriculum.id).map['\$query']))
        .addStage(Lookup(from: 'lesson', localField: '_id', foreignField: 'curriculum_id', as: 'lesson'))
        .addStage(Unwind(const Field('lesson')))
        .addStage(Lookup(from: 'schedule', localField: 'lesson.schedule_id', foreignField: '_id', as: 'schedule'))
        .addStage(Unwind(const Field('schedule')))
        .addStage(
            Match(where.lt('schedule.from', DateTime.now()).and(where.eq('schedule.till', null).or(where.gte('schedule.till', DateTime.now()))).map['\$query']))
        .addStage(Lookup(from: 'class', localField: 'lesson.class_id', foreignField: '_id', as: 'class'))
        .addStage(Unwind(const Field('class')))
        .addStage(Project({
          'class_id': const Field('class._id'),
          'name': const Field('class.name'),
          'grade': const Field('class.grade'),
          'lessontime_id': const Field('class.lessontime_id'),
          'master_id': const Field('class.master_id'),
          'institution_id': const Field('class.institution_id'),
          'student_ids': const Field('class.student_ids'),
        }))
        .addStage(Group(id: {
          'class_id': const Field('class_id'),
          'name': const Field('name'),
          'grade': const Field('grade'),
          'lessontime_id': const Field('lessontime_id'),
          'master_id': const Field('master_id'),
          'institution_id': const Field('institution_id'),
          'student_ids': const Field('student_ids'),
        }))
        .addStage(Sort({'_id.order': 1}))
        .build();
    return _db.collection('curriculum').aggregateToStream(aggr).map((data) => ClassModel.fromMap(data['_id']['class_id'], data['_id'])).toList();
  }

  Future<List<ChatModel>> getUserChatRooms() {
    return _db.collection('chats').find(where.eq('people_ids', currentUser!.id)).asyncMap((data) async {
      List<PersonModel> users = [];
      for (var pid in data['people_ids'] as List) {
        var p = await Get.find<ProxyStore>().getPerson((pid as ObjectId).toHexString());
        users.add(p);
      }
      return ChatModel.fromMap((data['_id'] as ObjectId).toHexString(), users);
    }).toList();
  }

  Future<void> createChatRoom(PersonModel other) async {
    await _db.collection('chats').insertOne({
      'institution_id': _institution!.id,
      'people_ids': [
        other.id,
        currentUser!.id,
      ],
    });
  }

  Future<bool> checkChatExistence(PersonModel u) async {
    var a = await _db.collection('chats').find(where.all('people_ids', [u.id, _currentUser!.id])).toList();
    return a.isNotEmpty;
  }

  Future<List<MessageModel>> getChatroomMessages(ChatModel cm) async {
    var a = await _db
        .collection('messages')
        .find(where.eq('chats_id', cm.id))
        .map((data) => MessageModel.fromMap((data['_id'] as ObjectId).toHexString(), data))
        .toList();
    a.sort((m1, m2) => m1.timeSent!.compareTo(m2.timeSent!));
    return a;
  }

  Future<void> addMessage(ChatModel cm, Map<String, dynamic> mdata) async {
    await _db.collection('messages').insertOne({
      'institution_id': _institution!.id,
      'chats_id': cm.id,
      'message': mdata['message'],
      'sent_by': currentUser!.id!,
      'timestamp': DateTime.now(),
    });
  }

  // Future<void> createReplacement(ClassModel aclass, Map<String, dynamic> map) async {
  //   await _db.collection('replace').insertOne({
  //     'institution_id': _institution!.id,
  //     'class_id': aclass.id,
  //     'order': map['order'],
  //     'curriculum_id': map['curriculum_id'],
  //     'teacher_id': map['teacher_id'],
  //     'venue_id': map['venue_id'],
  //     'date': map['date'],
  //   });
  // }

  // Future<List<ReplacementModel>> getReplacementsOnDate(ClassModel aclass, DayScheduleModel schedule, DateTime date) async {
  //   return _db
  //       .collection('replace')
  //       .find(where.eq('class_id', aclass.id).gte('date', date).lt('date', date.add(const Duration(hours: 24))))
  //       .map((data) => ReplacementModel.fromMap(aclass, schedule, (data['_id'] as ObjectId).toHexString(), data))
  //       .toList();
  // }

  // Future<List<ReplacementModel>> getAllReplacementsOnDate(DayScheduleModel schedule, DateTime date) async {
  //   return _db.collection('replace').find(where.gte('date', date).lt('date', date.add(const Duration(hours: 24)))).asyncMap((data) async {
  //     var aclass = await Get.find<ProxyStore>().getClass((data['class_id'] as ObjectId).toHexString());
  //     return ReplacementModel.fromMap(aclass, schedule, (data['_id'] as ObjectId).toHexString(), data);
  //   }).toList();
  // }

  Future<List<PersonModel>> getFreeTeachersOnLesson(DateTime date, int order) async {
    List<PersonModel> res = [];
    var a = await Get.find<ProxyStore>().getAllCurriculums();
    // var a = await aclass.getCurriculums();
    for (var cur in a) {
      var mast = await cur.master;
      var weekschedule = await getTeacherWeekSchedule(mast!, isoweek.Week.fromDate(date));
      var schedules = weekschedule.where((element) => element.day == date.weekday).toList();
      if (schedules.isNotEmpty) {
        var less = await schedules.first.getLessons();
        var d = less.where((element) => element.order == order);
        if (d.isEmpty) {
          if (res.where((element) => element.id == mast.id).isEmpty) {
            res.add(mast);
          }
        }
      } else {
        if (res.where((element) => element.id == mast.id).isEmpty) {
          res.add(mast);
        }
      }
    }
    return res;
  }

  Future<List<int>> getFreeLessonsOnDay(ClassModel aclass, DateTime date) async {
    List<int> res = [];
    var a = (await Get.find<ProxyStore>().getClassDaySchedule(aclass, date.weekday)).where((element) => element.till == null).first;
    var b = await Get.find<ProxyStore>().getScheduleLessons(aclass, a, needsEmpty: true, date: date);
    for (var l in b) {
      if (l.type == LessonType.empty) {
        res.add(l.order);
      }
    }
    return res;
  }

  // Future<List<AbsenceModel>> getAllAbsences(LessonModel lesson, DateTime date) async {
  //   return _db
  //       .collection('absence')
  //       .find(where
  //           .eq('class_id', lesson.aclass.id)
  //           .eq('lesson_order', lesson.order)
  //           .gte('date', date)
  //           .lt('date', date.add(const Duration(hours: 23, minutes: 59))))
  //       .map((data) => AbsenceModel.fromMap((data['_id'] as ObjectId).toHexString(), data))
  //       .toList();
  // }

  // Future<AbsenceModel?> getAbsence(LessonModel lesson, String studentId, DateTime date) async {
  //   var res = await _db.collection('absence').findOne(
  //         where
  //             .eq('class_id', ObjectId.fromHexString(lesson.aclass.id!))
  //             .eq('lesson_order', lesson.order)
  //             .eq('person_id', ObjectId.fromHexString(studentId))
  //             .gte('date', date)
  //             .lt('date', date.add(const Duration(hours: 23, minutes: 59))),
  //       );
  //   return res == null ? null : AbsenceModel.fromMap((res['_id'] as ObjectId).toHexString(), res);
  // }

  // Future<void> createAbsence(LessonModel lesson, AbsenceModel absence) async {
  //   if (await getAbsence(lesson, absence.personId, absence.date) == null) {
  //     var data = absence.toMap();
  //     data['institution_id'] = ObjectId.fromHexString(_institution!.id);
  //     data['class_id'] = ObjectId.fromHexString(lesson.aclass.id!);
  //     _db.collection('absence').insertOne(data);
  //   }
  // }

  // Future<void> deleteAbsence(LessonModel lesson, AbsenceModel absence) async {
  //   if (absence.id != null) {
  //     await _db.collection('absence').deleteOne(where.eq('_id', ObjectId.fromHexString(absence.id!)));
  //   }
  // }

  // Future<void> sendNotif(List<PersonModel> targets) async {
  //   await http.post(
  //     Uri.parse("https://onesignal.com/api/v1/notifications"),
  //     headers: {
  //       'Accept': 'application/json',
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Basic NDQ4M2EyODUtZmRiNS00OGE0LWE1ZDEtYmZjOTI3ZTVlZTUz',
  //     },
  //     body: json.encode(
  //       {
  //         "app_id": "0725282a-b87a-4ea8-97ab-165108deee94",
  //         "include_external_user_ids": targets.map((e) => e.id).toList(),
  //         "channel_for_external_user_ids": "push",
  //         "data": {"foo": "bar"},
  //         "contents": {"en": 'рабочее уведомление'}
  //       },
  //     ),
  //   );
  // }
}
