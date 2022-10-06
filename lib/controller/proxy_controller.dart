import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:isoweek/isoweek.dart';
import 'package:mutex/mutex.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/absence_model.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/daylessontime_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';

class ProxyStore extends getx.GetxController {
  final String host;
  late InstitutionModel institution;
  PersonModel? _currentUser;
  late Dio dio = Dio();
  final Mutex scheduleLessonsMutex = Mutex();

  ProxyStore(this.host);

  Future<void> init(String userEmail) async {
    // dio.interceptors.add(InterceptorsWrapper(onResponse: fixdate));
    institution = await _geInstitutionIdByUserEmail(userEmail);
    _currentUser = await _getPersonByEmail(userEmail);
  }

  void fixdate(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  Future<void> reset() async {
    return init(_currentUser!.email);
  }

  void resetCurrentUser() {
    _currentUser = null;
  }

  PersonModel? get currentUser => _currentUser;
  InstitutionModel? get currentInstitution => institution;

  Future<InstitutionModel> _geInstitutionIdByUserEmail(String email) async {
    var res = await dio.getUri<Map<String, dynamic>>(Uri.http(host, '/institution/email/$email'));
    var js = res.data!;
    return InstitutionModel.fromMap(js['_id'], js);
  }

  Future<PersonModel> _getPersonByEmail(String email) async {
    var res = await dio.getUri<Map<String, dynamic>>(Uri.http(host, '/person/email/$email'));
    var js = res.data!;
    return PersonModel.fromMap(js['_id'], js);
  }

  Future<List<ClassModel>> getAllClasses() async {
    var res = await dio.getUri<List>(Uri.http(host, '/class'));
    var js = res.data!;
    return js.map((data) => ClassModel.fromMap(data['_id'], data)).toList();
  }

  Future<ClassModel> getClass(String id) async {
    var res = await dio.getUri<Map<String, dynamic>>(Uri.http(host, '/class/$id'));
    var js = res.data!;
    return ClassModel.fromMap(js['_id'], js);
  }

  Future<ClassModel?> getClassByStudent(PersonModel student) async {
    var res = await dio.getUri<Map<String, dynamic>>(Uri.http(host, '/class/student/${student.id}'));
    var js = res.data!;
    return ClassModel.fromMap(js['_id'], js);
  }

  Future<String> saveClass(ClassModel aclass) async {
    var data = aclass.toMap(withId: true);
    data['institution_id'] = institution.id;
    var res = await dio.putUri<Map<String, dynamic>>(
      Uri.http(host, '/class'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<void> deleteClass(ClassModel aclass) async {
    var data = aclass.toMap(withId: true);
    await dio.deleteUri(
      Uri.http(host, '/class/${aclass.id}'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
  }

  Future<List<VenueModel>> getAllVenues() async {
    var res = await dio.getUri<List>(Uri.http(host, '/venue'));
    var js = res.data!;
    return js.map((data) => VenueModel.fromMap(data['_id'], data)).toList();
  }

  Future<VenueModel> getVenue(String id) async {
    var res = await dio.getUri<Map<String, dynamic>>(Uri.http(host, '/venue/$id'));
    var js = res.data!;
    return VenueModel.fromMap(js['_id'], js);
  }

  Future<String> saveVenue(VenueModel venue) async {
    var data = venue.toMap(withId: true);
    data['institution_id'] = institution.id;
    var res = await dio.putUri<Map<String, dynamic>>(
      Uri.http(host, '/venue'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<void> deleteVenue(VenueModel venue) async {
    var data = venue.toMap(withId: true);
    await dio.deleteUri(
      Uri.http(host, '/venue/${venue.id}'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
  }

  Future<List<DayLessontimeModel>> getAllDayLessontime() async {
    var res = await dio.getUri<List>(Uri.http(host, '/lessontime'));
    var js = res.data!;
    return js.map((data) => DayLessontimeModel.fromMap(data['_id'], data)).toList();
  }

  Future<DayLessontimeModel> getDayLessontime(String id) async {
    var res = await dio.getUri<Map<String, dynamic>>(Uri.http(host, '/lessontime/$id'));
    var js = res.data!;
    return DayLessontimeModel.fromMap(js['_id'], js);
  }

  Future<String> saveDayLessontime(DayLessontimeModel dayLessontime) async {
    var data = dayLessontime.toMap(withId: true);
    data['institution_id'] = institution.id;
    var res = await dio.putUri<Map<String, dynamic>>(
      Uri.http(host, '/lessontime'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<List<LessontimeModel>> getLessontimes(String id) async {
    var res = await dio.getUri<List>(Uri.http(host, '/lessontime/$id/time'));
    var js = res.data!;
    return js.map((data) => LessontimeModel.fromMap(data['_id'], data)).toList();
  }

  Future<String> saveLessontime(DayLessontimeModel daylessontime, LessontimeModel lessontime) async {
    var data = lessontime.toMap(withId: true);
    data['institution_id'] = institution.id;
    data['lessontime_id'] = daylessontime.id!;
    var res = await dio.putUri<Map<String, dynamic>>(
      Uri.http(host, '/lessontime/${daylessontime.id!}/time'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<void> deleteLessontime(DayLessontimeModel daylessontime, LessontimeModel lessontime) async {
    var data = lessontime.toMap(withId: true);
    await dio.deleteUri(
      Uri.http(host, '//lessontime/${daylessontime.id!}/time/${lessontime.id}'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
  }

  Future<List<PersonModel>> getAllPeople() async {
    var res = await dio.getUri<List>(Uri.http(host, '/person'));
    var js = res.data!;
    return js.map((data) => PersonModel.fromMap(data['_id'], data)).toList();
  }

  Future<PersonModel> getPerson(String id) async {
    var res = await dio.getUri<Map<String, dynamic>>(Uri.http(host, '/person/$id'));
    var js = res.data!;
    return PersonModel.fromMap(js['_id'], js);
  }

  Future<List<PersonModel>> getPeopleByIds(List<String> ids) async {
    var res = await dio.postUri<List>(Uri.http(host, '/person'), options: Options(headers: {'Content-Type': 'application/json'}), data: ids);
    var js = res.data!;
    return js.map((data) => PersonModel.fromMap(data['_id'], data)).toList();
  }

  Future<String> savePerson(PersonModel person) async {
    var data = person.toMap(withId: true);
    data['institution_id'] = institution.id;
    var res = await dio.putUri<Map<String, dynamic>>(
      Uri.http(host, '/person'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<List<CurriculumModel>> getAllCurriculums() async {
    var res = await dio.getUri<List>(Uri.http(host, '/curriculum'));
    var js = res.data!;
    return js.map((data) => CurriculumModel.fromMap(data['_id'], data)).toList();
  }

  Future<CurriculumModel> getCurriculum(String id) async {
    var res = await dio.getUri<Map<String, dynamic>>(Uri.http(host, '/curriculum/$id'));
    var js = res.data!;
    return CurriculumModel.fromMap(js['_id'], js);
  }

  Future<String> saveCurriculum(CurriculumModel curriculum) async {
    var data = curriculum.toMap(withId: true);
    data['institution_id'] = institution.id;
    var res = await dio.putUri<Map<String, dynamic>>(
      Uri.http(host, '/curriculum'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  // Future<List<StudentScheduleModel>> getClassWeekSchedule(ClassModel aclass, Week currentWeek) async {
  //   var res = await dio.getUri<List>(Uri.http(host, '/class/${aclass.id}/schedule/${currentWeek.days[0]}'));
  //   var js = res.data!;
  //   return js
  //       .map((data) => StudentScheduleModel.fromMap(aclass, data['_id'], data))
  //       // .where((data) => data.from!.isBefore(currentWeek.day(5)) && (data.till == null || data.till!.isAfter(currentWeek.day(4))))
  //       .toList();
  // }

  Future<List<StudentScheduleModel>> getClassDaySchedule(ClassModel aclass, int day) async {
    var res = await dio.getUri<List>(Uri.http(host, '/class/${aclass.id}/schedule/day/$day'));
    var js = res.data!;
    return js.map((data) => StudentScheduleModel.fromMap(aclass, data['_id'], data)).toList();
  }

  Future<String> saveDaySchedule(ClassScheduleModel schedule) async {
    var data = schedule.toMap();
    data['institution_id'] = institution.id;
    data['class_id'] = schedule.aclass.id;
    var res = await dio.putUri<Map<String, dynamic>>(
      Uri.http(host, '/class/${schedule.aclass.id}/schedule'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<List<LessonModel>> getScheduleLessons(ClassModel aclass, ClassScheduleModel schedule, {DateTime? date, bool needsEmpty = false}) async {
    // await scheduleLessonsMutex.acquire();
    List<LessonModel> result = [];
    var res = await dio.getUri<List>(Uri.http(host, '/class/${aclass.id}/schedule/${schedule.id}/lesson'));
    var js = res.data!;
    var less = js.map((data) => LessonModel.fromMap(aclass, schedule, data['_id'], data)).toList();

    List<ReplacementModel> reps = [];
    if (date != null) {
      reps.addAll((await getReplacementsOnDate(aclass, schedule, date)).toList());
    }

    if (needsEmpty) {
      int maxOrder = 1;
      for (var l in less) {
        if (l.order > maxOrder) {
          maxOrder = l.order;
        }
      }

      List<int> empt = List.generate(maxOrder, (index) => index + 1);
      empt.removeWhere((element) {
        for (var l in less) {
          if (l.order == element) {
            return true;
          }
        }
        return false;
      });

      for (var i in empt) {
        var nl = EmptyLesson.fromMap(aclass, schedule, null, i);
        nl.setAsEmpty();
        less.add(nl);
      }
    }

    for (var l in less) {
      LessonModel? nl;
      for (var r in reps) {
        if (l.order == r.order) {
          l.setReplacedType();
          nl = r;
        }
      }
      result.add(nl ?? l);
    }
    result.sort(
      (a, b) => a.order.compareTo(b.order),
    );
    // scheduleLessonsMutex.release();
    return result;
  }

  Future<List<LessonModel>> getScheduleLessonsForStudent(ClassModel aclass, StudentScheduleModel schedule, StudentModel student, DateTime? date) async {
    List<LessonModel> res = [];
    var less = await getScheduleLessons(aclass, schedule, date: date, needsEmpty: true);

    for (var l in less) {
      var cur = l.type == LessonType.empty ? null : await l.curriculum;
      if ((cur != null && await cur.isAvailableForStudent(student)) || l.type == LessonType.empty) {
        res.add(l);
      }
    }
    return res;
  }

  Future<String> saveLesson(LessonModel lesson) async {
    var data = lesson.toMap();
    data['institution_id'] = institution.id;
    data['class_id'] = lesson.aclass.id;
    data['schedule_id'] = lesson.schedule.id;
    var res = await dio.putUri<Map<String, dynamic>>(
      Uri.http(host, '/class/${lesson.aclass.id!}/schedule/${lesson.schedule.id}/lesson'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<void> deleteLesson(LessonModel lesson) async {
    var data = lesson.toMap(withId: true);
    await dio.deleteUri(
      Uri.http(host, '/class/${lesson.aclass.id!}/schedule/${lesson.schedule.id}/lesson/${lesson.id}'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
  }

  Future<List<ReplacementModel>> getReplacementsOnDate(ClassModel aclass, ClassScheduleModel schedule, DateTime date) async {
    var res = await dio.getUri<List>(
      Uri.http(host, '/class/${aclass.id}/replace/${date.toIso8601String()}'),
    );
    var js = res.data!;
    return js.map((data) => ReplacementModel.fromMap(aclass, schedule, data['_id'], data)).toList();
  }

  Future<List<ReplacementModel>> getAllReplacementsOnDate(ClassScheduleModel schedule, DateTime date) async {
    List<ReplacementModel> repl = [];
    var res = await dio.getUri<List>(
      Uri.http(host, '/replace/${date.toIso8601String()}'),
    );
    var js = res.data!;
    for (var i in js) {
      var aclass = await getClass(i['class_id']);
      repl.add(ReplacementModel.fromMap(aclass, schedule, i['_id'], i));
    }
    return repl;
  }

  Future<void> createReplacement(ClassModel aclass, Map<String, dynamic> map) async {
    var data = {
      'institution_id': institution.id,
      'class_id': aclass.id,
      'order': map['order'],
      'curriculum_id': map['curriculum_id'],
      'teacher_id': map['teacher_id'],
      'venue_id': map['venue_id'],
      'date': map['date'],
    };
    await dio.putUri<Map<String, dynamic>>(
      Uri.http(host, '/class/${aclass.id}/replace'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
  }

  Future<HomeworkModel?> getHomeworkForStudentBeforeDate(ClassModel aclass, CurriculumModel curriculum, StudentModel student, DateTime date) async {
    var res = await dio.postUri<Map<String, dynamic>>(
      Uri.http(host, '/class/${aclass.id}/curriculum/${curriculum.id}/student/${student.id}/homework/beforedate'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: {'date': date.toIso8601String()},
    );
    var js = res.data!;
    return HomeworkModel.fromMap(js['_id'], js);
  }

  Future<HomeworkModel?> getHomeworkForClassBeforeDate(ClassModel aclass, CurriculumModel curriculum, DateTime date) async {
    var res = await dio.postUri<Map<String, dynamic>>(
      Uri.http(host, '/class/${aclass.id}/curriculum/${curriculum.id}/homework/beforedate'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: {'date': date.toIso8601String()},
    );
    var js = res.data!;
    return HomeworkModel.fromMap(js['_id'], js);
  }

  Future<HomeworkModel?> getHomeworkForStudentOnDate(ClassModel aclass, CurriculumModel curriculum, StudentModel student, DateTime date) async {
    var res = await dio.postUri<Map<String, dynamic>>(
      Uri.http(host, '/class/${aclass.id}/curriculum/${curriculum.id}/student/${student.id}/homework/ondate'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: {'date': date.toIso8601String()},
    );
    var js = res.data!;
    return HomeworkModel.fromMap(js['_id'], js);
  }

  Future<HomeworkModel?> getHomeworkForClassOnDate(ClassModel aclass, CurriculumModel curriculum, DateTime date) async {
    var res = await dio.postUri<Map<String, dynamic>>(
      Uri.http(host, '/class/${aclass.id}/curriculum/${curriculum.id}/homework/ondate'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: {'date': date.toIso8601String()},
    );
    var js = res.data!;
    return HomeworkModel.fromMap(js['_id'], js);
  }

  Future<String> saveHomework(HomeworkModel homework) async {
    var data = homework.toMap();
    data['institution_id'] = institution.id;
    var res = await dio.putUri<Map<String, dynamic>>(
      Uri.http(host, '/homework'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<void> createCompletion(HomeworkModel homework, StudentModel student) async {
    var data = {
      'completedby_id': student.id,
      'completed_time': DateTime.now(),
      'confirmedby_id': null,
      'confirmed_time': null,
      'status': 1,
      'homework_id': homework.id,
      'institution_id': institution.id,
    };
    // await _db.collection('completion').insertOne(data);
  }

  Future<void> deleteCompletion(HomeworkModel homework, CompletionFlagModel completion, StudentModel student) async {
    var data = completion.toMap(withId: true);
    await dio.deleteUri(
      Uri.http(host, '/homework/${homework.id}/student/${student.id}/competion/${completion.id}'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
  }

  Future<void> confirmCompletion(HomeworkModel homework, CompletionFlagModel completion, PersonModel person) async {
    await dio.putUri<Map<String, dynamic>>(Uri.http(host, '/homework/${homework.id}/competion/${completion.id}'),
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          'status': 2,
          'confirmedby_id': person.id,
          'confirmed_time': DateTime.now().toIso8601String(),
        });
  }

  Future<void> unconfirmCompletion(HomeworkModel homework, CompletionFlagModel completion, PersonModel person) async {
    await dio.putUri<Map<String, dynamic>>(Uri.http(host, '/homework/${homework.id}/competion/${completion.id}'),
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          'status': 1,
          'confirmedby_id': person.id,
          'confirmed_time': null,
        });
  }

  Future<CompletionFlagModel?> getHomeworkCompletion(HomeworkModel homework, StudentModel student) async {
    var res = await dio.getUri<Map<String, dynamic>>(Uri.http(host, '/homework/${homework.id}/student/${student.id}/competion'));
    var js = res.data!;
    return CompletionFlagModel.fromMap(js['_id'], js);
  }

  Future<List<CompletionFlagModel>> getAllHomeworkCompletions(HomeworkModel homework) async {
    var res = await dio.getUri<List>(Uri.http(host, '/homework/${homework.id}/completion'));
    var js = res.data!;
    return js.map((data) => CompletionFlagModel.fromMap(data['_id'], data)).toList();
  }

  Future<void> updateHomeworkText(HomeworkModel homework, String newText) async {
    await dio.putUri<Map<String, dynamic>>(
      Uri.http(host, '/homework/${homework.id}'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: {'text': newText},
    );
  }

  Future<Map<TeacherModel, List<String>>> getClassTeachers(ClassModel aclass) async {
    var teachers = <TeacherModel, List<String>>{};
    var mast = await aclass.master;
    if (mast != null) {
      teachers[mast] = [
        'Классный руководитель',
      ];
    }
    var cw = getx.Get.find<CurrentWeek>().currentWeek; //TODO: currentWeek should be parameter
    var days = await aclass.getClassSchedulesWeek(cw);
    for (var day in days) {
      var dayles = await day.lessons();
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
    data['ratedate'] = date;
    data['rater_id'] = user.id;
    data['rating'] = rating;
    data['teacher_id'] = teacher.id;
    data['commentary'] = comment;
    await dio.putUri<Map<String, dynamic>>(
      Uri.http(host, '/teacherraiting'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
  }

  Future<double> getAverageTeacherRating(TeacherModel teacher) async {
    var res = await dio.getUri<List>(Uri.http(host, '/teacherraiting/${teacher.id}'));
    double sum = 0;
    var js = res.data!;
    for (int i in js) {
      sum += i;
    }
    return sum / js.length;
  }

  Future<bool> hasRatingInMonth(TeacherModel teacher) async {
    var res = await dio.getUri<Map<String, dynamic>>(
      Uri.http(host, '/teacherraiting/${teacher.id}/lastdate'),
    );
    var js = res.data!;
    var d = js['lastdate'] as DateTime;
    return (d.year == DateTime.now().year && d.month == DateTime.now().month);
  }

  Future<List<AbsenceModel>> getAllAbsences(LessonModel lesson, DateTime date) async {
    var res = await dio.postUri<List>(
      Uri.http(host, '/class/${lesson.aclass.id}/absence'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: {'date': date.toIso8601String()},
    );
    var js = res.data!;
    return js.map((data) => AbsenceModel.fromMap(data['_id'], data)).toList();
  }

  Future<AbsenceModel?> getAbsence(LessonModel lesson, String studentId, DateTime date) async {
    var res = await dio.postUri<Map<String, dynamic>>(
      Uri.http(host, '/class/${lesson.aclass.id}/'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: {'date': date.toIso8601String()},
    );

    return res.data == null ? null : AbsenceModel.fromMap((res.data!['_id']), res.data!);
  }

  Future<void> createAbsence(LessonModel lesson, AbsenceModel absence) async {
    if (await getAbsence(lesson, absence.personId, absence.date) == null) {
      var data = absence.toMap();
      data['institution_id'] = institution.id;
      data['class_id'] = lesson.aclass.id;
      await dio.putUri<Map<String, dynamic>>(
        Uri.http(host, '/teacherraiting'),
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: data,
      );
      //   _db.collection('absence').insertOne(data);
    }
  }

  Future<void> deleteAbsence(LessonModel lesson, AbsenceModel absence) async {
    var data = absence.toMap(withId: true);
    await dio.deleteUri(
      Uri.http(host, '/class/${lesson.aclass.id}/absence/${absence.id}'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
  }

  Future<List<MarkModel>> getAllLessonMarks(LessonModel lesson, DateTime date) async {
    var res = await dio.postUri<List>(
      Uri.http(host, '/class/${lesson.aclass.id}/curriculum/${lesson.curriculumId}/mark'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: {'date': date.toIso8601String()},
    );
    var js = res.data!;
    return js.map((e) => MarkModel.fromMap(e['_id'], e)).toList();
  }

  Future<List<MarkModel>> getStudentLessonMarks(LessonModel lesson, StudentModel student, DateTime date) async {
    var res = await dio.getUri<List>(
      Uri.http(host, '/curriculum/${lesson.curriculumId}/student/${student.id}/mark/${date.toIso8601String()}/${lesson.order}'),
    );
    var js = res.data!;
    return js.map((e) => MarkModel.fromMap(e['_id'], e)).toList();
  }

  Future<List<MarkModel>> getStudentCurriculumMarks(StudentModel student, CurriculumModel curriculum) async {
    var res = await dio.getUri<List>(
      Uri.http(host, '/curriculum/${curriculum.id}/student/${student.id}/mark'),
    );
    var js = res.data!;
    return js.map((e) => MarkModel.fromMap(e['_id'], e)).toList();
  }

  Future<List<MarkModel>> getStudentCurriculumTeacherMarks(StudentModel student, CurriculumModel curriculum, TeacherModel teacher) async {
    var res = await dio.getUri<List>(
      Uri.http(host, '/curriculum/${curriculum.id}/student/${student.id}/teacher/${teacher.id}/mark'),
    );
    var js = res.data!;
    return js.map((e) => MarkModel.fromMap(e['_id'], e)).toList();
  }

  Future<void> updateMark(String docId, int newMark) async {
    await dio.putUri<Map<String, dynamic>>(
      Uri.http(host, '/mark/$docId'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: {'mark': newMark},
    );
  }

  Future<String> saveMark(MarkModel mark) async {
    var data = mark.toMap(withId: true);
    data['institution_id'] = institution.id;
    var res = await dio.putUri<Map<String, dynamic>>(
      Uri.http(host, '/mark'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<void> deleteMark(MarkModel mark) async {
    if (mark.id != null) {
      var data = mark.toMap(withId: true);
      await dio.deleteUri(
        Uri.http(host, '/mark/${mark.id}'),
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: data,
      );
    }
  }

  Future<List<ClassScheduleModel>> getClassWeekSchedule(ClassModel aclass, Week currentWeek) async {
    var res = await dio.getUri<List>(
      Uri.http(host, '/class/${aclass.id}/weekschedule/${currentWeek.day(0).toIso8601String()}'),
    );
    return res.data!.map((e) => ClassScheduleModel.fromMap(aclass, e['_id'], e)).toList();
  }

  Future<List<StudentScheduleModel>> getClassStudentWeekSchedule(ClassModel aclass, Week currentWeek, StudentModel student) async {
    var res = await dio.getUri<List>(
      Uri.http(host, '/class/${aclass.id}/weekschedule/${currentWeek.day(0).toIso8601String()}/student/${student.id}'),
    );
    return res.data!.map((e) => StudentScheduleModel.fromMap(aclass, e['_id'], e)).toList();
  }

  Future<List<TeacherScheduleModel>> getTeacherWeekSchedule(TeacherModel teacher, Week currentWeek) async {
    var res = await dio.getUri<List>(
      Uri.http(host, '/person/${teacher.id}/teacher/weekschedule/${currentWeek.day(0).toIso8601String()}'),
    );
    return res.data!.map((e) => TeacherScheduleModel.fromMap(e['schedule_id'], e)).toList();
  }

  Future<List<ClassModel>> getCurriculumClasses(CurriculumModel curriculum) async {
    var res = await dio.getUri<List>(
      Uri.http(host, '/curriculum/${curriculum.id}/class'),
    );
    return res.data!.map((e) => ClassModel.fromMap(e['_id'], e)).toList();
  }

  Future<List<CurriculumModel>> getClassCurriculums(ClassModel aclass) async {
    var res = await dio.getUri<List>(
      Uri.http(host, '/class/${aclass.id}/curriculum'),
    );
    return res.data!.map((e) => CurriculumModel.fromMap(e['_id'], e)).toList();
  }

  Future<List<CurriculumModel>> getStudentCurriculums(StudentModel student) async {
    var res = await dio.getUri<List>(
      Uri.http(host, '/person/${student.id}/student/curriculum'),
    );
    return res.data!.map((e) => CurriculumModel.fromMap(e['_id'], e)).toList();
  }

  Future<List<CurriculumModel>> getTeacherCurriculums(TeacherModel teacher) async {
    var res = await dio.getUri<List>(
      Uri.http(host, '/person/${teacher.id}/teacher/curriculum'),
    );
    return res.data!.map((e) => CurriculumModel.fromMap(e['_id'], e)).toList();
  }
}
