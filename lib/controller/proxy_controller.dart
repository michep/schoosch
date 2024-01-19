import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:get/get.dart' as getx;
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/auth_controller.dart';
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
import 'package:schoosch/model/marktype_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/model/venue_model.dart';

class ProxyStore extends getx.GetxController {
  late InstitutionModel institution;
  PersonModel? _currentUser;
  ClassModel? currentObserverClass;
  final Dio dio = Dio();
  Uri Function(String) baseUriFunc;

  ProxyStore(this.baseUriFunc);

  Future<void> init(String userEmail) async {
    if (dio.httpClientAdapter is IOHttpClientAdapter) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        HttpClient client = HttpClient();
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        var currentToken = getx.Get.find<FAuth>().token;
        options.headers.addAll({'Authorization': 'Bearer $currentToken'});
        return handler.next(options);
      },
    ));
    // dio.interceptors.add(InterceptorsWrapper(
    //   onError: (e, handler) {
    //     getx.Get.showSnackbar(getx.GetSnackBar(
    //       title: 'Error',
    //       message: e.message,
    //       duration: const Duration(seconds: 10),
    //     ));
    //     return handler.next(e);
    //   },
    // ));
    institution = await _geInstitutionIdByUserEmail(userEmail);
    await institution.prefetchMarkTypes();
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
    var res = await dio.getUri<Map<String, dynamic>>(baseUriFunc('/institution/email/$email'));
    var js = res.data!;
    return InstitutionModel.fromMap(js['_id'], js);
  }

  Future<PersonModel> _getPersonByEmail(String email) async {
    var res = await dio.getUri<Map<String, dynamic>>(baseUriFunc('/person/email/$email'));
    var js = res.data!;
    return PersonModel.fromMap(js['_id'], js);
  }

  Future<List<ClassModel>> getAllClasses() async {
    var res = await dio.getUri<List>(baseUriFunc('/class'));
    var js = res.data!;
    return js.map((data) => ClassModel.fromMap(data['_id'], data)).toList();
  }

  Future<ClassModel> getClass(String id) async {
    var res = await dio.getUri<Map<String, dynamic>>(baseUriFunc('/class/$id'));
    var js = res.data!;
    return ClassModel.fromMap(js['_id'], js);
  }

  Future<List<ClassModel>> getClassesByIds(List<String> ids) async {
    var res = await dio.postUri<List>(
      baseUriFunc('/class'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: ids,
    );
    var js = res.data!;
    return js.map((data) => ClassModel.fromMap(data['_id'], data)).toList();
  }

  Future<ClassModel?> getClassByStudent(PersonModel student) async {
    var res = await dio.getUri<Map<String, dynamic>>(baseUriFunc('/class/student/${student.id}'));
    var js = res.data!;
    return ClassModel.fromMap(js['_id'], js);
  }

  Future<String> saveClass(ClassModel aclass) async {
    var data = aclass.toMap(withId: true);
    data['institution_id'] = institution.id;
    var res = await dio.putUri<Map<String, dynamic>>(
      baseUriFunc('/class'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<void> deleteClass(ClassModel aclass) async {
    await dio.deleteUri(
      baseUriFunc('/class/${aclass.id}'),
    );
  }

  Future<List<VenueModel>> getAllVenues() async {
    var res = await dio.getUri<List>(baseUriFunc('/venue'));
    var js = res.data!;
    return js.map((data) => VenueModel.fromMap(data['_id'], data)).toList();
  }

  Future<VenueModel> getVenue(String id) async {
    var res = await dio.getUri<Map<String, dynamic>>(baseUriFunc('/venue/$id'));
    var js = res.data!;
    return VenueModel.fromMap(js['_id'], js);
  }

  Future<String> saveVenue(VenueModel venue) async {
    var data = venue.toMap(withId: true);
    data['institution_id'] = institution.id;
    var res = await dio.putUri<Map<String, dynamic>>(
      baseUriFunc('/venue'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<void> deleteVenue(VenueModel venue) async {
    await dio.deleteUri(
      baseUriFunc('/venue/${venue.id}'),
    );
  }

  Future<List<DayLessontimeModel>> getAllDayLessontime() async {
    var res = await dio.getUri<List>(baseUriFunc('/lessontime'));
    var js = res.data!;
    return js.map((data) => DayLessontimeModel.fromMap(data['_id'], data)).toList();
  }

  Future<DayLessontimeModel> getDayLessontime(String id) async {
    var res = await dio.getUri<Map<String, dynamic>>(baseUriFunc('/lessontime/$id'));
    var js = res.data!;
    return DayLessontimeModel.fromMap(js['_id'], js);
  }

  Future<String> saveDayLessontime(DayLessontimeModel dayLessontime) async {
    var data = dayLessontime.toMap(withId: true);
    data['institution_id'] = institution.id;
    var res = await dio.putUri<Map<String, dynamic>>(
      baseUriFunc('/lessontime'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<List<LessontimeModel>> getLessontimes(String id) async {
    var res = await dio.getUri<List>(baseUriFunc('/lessontime/$id/time'));
    var js = res.data!;
    return js.map((data) => LessontimeModel.fromMap(data['_id'], data)).toList();
  }

  Future<String> saveLessontime(DayLessontimeModel daylessontime, LessontimeModel lessontime) async {
    var data = lessontime.toMap(withId: true);
    data['institution_id'] = institution.id;
    data['lessontime_id'] = daylessontime.id!;
    var res = await dio.putUri<Map<String, dynamic>>(
      baseUriFunc('/lessontime/${daylessontime.id!}/time'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<void> deleteLessontime(DayLessontimeModel daylessontime, LessontimeModel lessontime) async {
    await dio.deleteUri(
      baseUriFunc('/time/${lessontime.id}'),
    );
  }

  Future<List<PersonModel>> getAllPeople() async {
    var res = await dio.getUri<List>(baseUriFunc('/person'));
    var js = res.data!;
    return js.map((data) => PersonModel.fromMap(data['_id'], data)).toList();
  }

  Future<PersonModel> getPerson(String id) async {
    var res = await dio.getUri<Map<String, dynamic>>(baseUriFunc('/person/$id'));
    var js = res.data!;
    return PersonModel.fromMap(js['_id'], js);
  }

  Future<List<PersonModel>> getPeopleByIds(List<String> ids) async {
    var res = await dio.postUri<List>(
      baseUriFunc('/person'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: ids,
    );
    var js = res.data!;
    return js.map((data) => PersonModel.fromMap(data['_id'], data)).toList();
  }

  Future<String> savePerson(PersonModel person) async {
    var data = person.toMap(withId: true);
    data['institution_id'] = institution.id;
    var res = await dio.putUri<Map<String, dynamic>>(
      baseUriFunc('/person'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<List<CurriculumModel>> getAllCurriculums() async {
    var res = await dio.getUri<List>(baseUriFunc('/curriculum'));
    var js = res.data!;
    return js.map((data) => CurriculumModel.fromMap(data['_id'], data)).toList();
  }

  Future<CurriculumModel> getCurriculum(String id) async {
    var res = await dio.getUri<Map<String, dynamic>>(baseUriFunc('/curriculum/$id'));
    var js = res.data!;
    return CurriculumModel.fromMap(js['_id'], js);
  }

  Future<String> saveCurriculum(CurriculumModel curriculum) async {
    var data = curriculum.toMap(withId: true);
    data['institution_id'] = institution.id;
    var res = await dio.putUri<Map<String, dynamic>>(
      baseUriFunc('/curriculum'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<List<StudentScheduleModel>> getClassDaySchedule(ClassModel aclass, int day) async {
    var res = await dio.getUri<List>(baseUriFunc('/class/${aclass.id}/schedule/day/$day'));
    var js = res.data!;
    return js.map((data) => StudentScheduleModel.fromMap(aclass, data['_id'], data)).toList();
  }

  Future<String> saveDaySchedule(ClassScheduleModel schedule) async {
    var data = schedule.toMap(withId: true);
    data['institution_id'] = institution.id;
    data['class_id'] = schedule.aclass.id;
    var res = await dio.putUri<Map<String, dynamic>>(
      baseUriFunc('/class/${schedule.aclass.id}/schedule'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<List<LessonModel>> getScheduleLessons(ClassModel aclass, ClassScheduleModel schedule, {DateTime? date, bool needsEmpty = false}) async {
    // await scheduleLessonsMutex.acquire();
    List<LessonModel> result = [];

    var res = await dio.getUri<List>(baseUriFunc('/class/${aclass.id}/schedule/${schedule.id}/lesson'));
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
      if ((cur != null && cur.isAvailableForStudent(student)) || l.type == LessonType.empty) {
        ///TODO: db query?
        res.add(l);
      }
    }
    return res;
  }

  Future<String> saveLesson(LessonModel lesson) async {
    var data = lesson.toMap(withId: true);
    data['institution_id'] = institution.id;
    data['class_id'] = lesson.aclass.id;
    data['schedule_id'] = lesson.schedule.id;
    var res = await dio.putUri<Map<String, dynamic>>(
      baseUriFunc('/class/${lesson.aclass.id!}/schedule/${lesson.schedule.id}/lesson'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<void> deleteLesson(LessonModel lesson) async {
    await dio.deleteUri(
      baseUriFunc('/lesson/${lesson.id}'),
    );
  }

  Future<List<ReplacementModel>> getReplacementsOnDate(ClassModel aclass, ClassScheduleModel schedule, DateTime date) async {
    var res = await dio.getUri<List>(baseUriFunc('/class/${aclass.id}/replace/${date.toIso8601String()}'));
    var js = res.data!;
    return js.map((data) => ReplacementModel.fromMap(aclass, schedule, data['_id'], data)).toList();
  }

  Future<List<ReplacementModel>> getAllReplacementsOnDate(ClassScheduleModel schedule, DateTime date) async {
    List<ReplacementModel> repl = [];
    var res = await dio.getUri<List>(baseUriFunc('/replace/${date.toIso8601String()}'));
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
      baseUriFunc('/class/${aclass.id}/replace'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
  }

  Future<List<HomeworkModel>> getHomeworkThisLesson(ClassModel aclass, CurriculumModel curriculum, DateTime date) async {
    var res = await dio.getUri<List>(
      baseUriFunc('/class/${aclass.id}/curriculum/${curriculum.id}/homework/beforedate/${date.toIso8601String()}'),
    );
    var js = res.data!;
    return js.map((data) => HomeworkModel.fromMap(data['_id'], data)).toList();
  }

  Future<List<HomeworkModel>> getHomeworkNextLesson(ClassModel aclass, CurriculumModel curriculum, DateTime date) async {
    var res = await dio.getUri<List>(
      baseUriFunc('/class/${aclass.id}/curriculum/${curriculum.id}/homework/ondate/${date.toIso8601String()}'),
    );
    var js = res.data!;
    return js.map((data) => HomeworkModel.fromMap(data['_id'], data)).toList();
  }

  Future<String> saveHomework(HomeworkModel homework) async {
    var data = homework.toMap();
    data['institution_id'] = institution.id;
    var res = await dio.putUri<Map<String, dynamic>>(
      baseUriFunc('/homework'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<void> deleteHomework(HomeworkModel homework) async {
    await dio.deleteUri(
      baseUriFunc('/homework/${homework.id}'),
    );
  }

  Future<void> createCompletion(HomeworkModel homework, StudentModel student) async {
    var data = {
      '_id': null,
      'completedby_id': student.id,
      'completed_time': DateTime.now().toIso8601String(),
      'confirmedby_id': null,
      'confirmed_time': null,
      'status': 1,
      'homework_id': homework.id,
      'institution_id': institution.id,
    };
    var res = await dio.putUri<Map<String, dynamic>>(
      baseUriFunc('/completion'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<void> deleteCompletion(CompletionFlagModel completion) async {
    await dio.deleteUri(
      baseUriFunc('/completion/${completion.id}'),
    );
  }

  Future<void> confirmCompletion(CompletionFlagModel completion, PersonModel person) async {
    await dio.putUri<Map<String, dynamic>>(
      baseUriFunc('/completion/${completion.id}'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: {
        'status': 2,
        'confirmedby_id': person.id,
        'confirmed_time': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> unconfirmCompletion(CompletionFlagModel completion, PersonModel person) async {
    await dio.putUri<Map<String, dynamic>>(
      baseUriFunc('/completion/${completion.id}'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: {
        'status': 1,
        'confirmedby_id': person.id,
        'confirmed_time': null,
      },
    );
  }

  Future<CompletionFlagModel?> getStudentHomeworkCompletion(HomeworkModel homework, StudentModel student) async {
    var res = await dio.getUri<Map<String, dynamic>>(baseUriFunc('/homework/${homework.id}/student/${student.id}/completion'));
    var js = res.data!;
    return CompletionFlagModel.fromMap(js['_id'], js);
  }

  Future<List<CompletionFlagModel>> getAllHomeworkCompletions(HomeworkModel homework) async {
    var res = await dio.getUri<List>(baseUriFunc('/homework/${homework.id}/completion'));
    var js = res.data!;
    return js.map((data) => CompletionFlagModel.fromMap(data['_id'], data)).toList();
  }

  Future<void> updateHomeworkText(HomeworkModel homework, String newText) async {
    await dio.putUri<Map<String, dynamic>>(
      baseUriFunc('/homework/${homework.id}'),
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
      var dayles = await day.classLessons();
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
      baseUriFunc('/teacherraiting'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
  }

  Future<double> getAverageTeacherRating(TeacherModel teacher) async {
    var res = await dio.getUri<List>(baseUriFunc('/teacherraiting/${teacher.id}'));
    double sum = 0;
    var js = res.data!;
    for (int i in js) {
      sum += i;
    }
    return sum / js.length;
  }

  Future<bool> hasRatingInMonth(TeacherModel teacher) async {
    var res = await dio.getUri<Map<String, dynamic>>(
      baseUriFunc('/teacherraiting/${teacher.id}/lastdate'),
    );
    var js = res.data!;
    var d = js['lastdate'] as DateTime;
    return (d.year == DateTime.now().year && d.month == DateTime.now().month);
  }

  Future<List<AbsenceModel>> getAllAbsences(LessonModel lesson, DateTime date) async {
    var res = await dio.getUri<List>(baseUriFunc('/class/${lesson.aclass.id}/absence/${date.toIso8601String()}/${lesson.order}'));
    var js = res.data!;
    return js.map((data) => AbsenceModel.fromMap(data['_id'], data)).toList();
  }

  Future<List<AbsenceModel>> getStudentAbsence(LessonModel lesson, String studentId, DateTime date) async {
    var res = await dio.getUri<List>(baseUriFunc('/class/${lesson.aclass.id}/student/$studentId/absence/${date.toIso8601String()}/${lesson.order}'));
    var js = res.data!;
    return js.map((data) => AbsenceModel.fromMap(data['_id'], data)).toList();
  }

  Future<List<AbsenceModel>> getAllPeriodtAbsences(StudyPeriodModel period, List<StudentModel> studs) async {
    var res = await dio.postUri<List>(
      baseUriFunc('/absence/${period.from}/${period.till}'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: studs.map((e) => e.id).toList()
    );
    var js = res.data!;
    return js.map((data) => AbsenceModel.fromMap(data['_id'], data)).toList();
  }

  Future<List<AbsenceModel>> getAbsencesByStudentIds(List<StudentModel> students, StudyPeriodModel period) async {
    var res = await dio.postUri<List>(
      baseUriFunc('/absence/${period.from.toIso8601String()}/${period.till.toIso8601String()}'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: students.map((e) => e.id).toList(),
    );
    var js = res.data!;
    return js.map((e) => AbsenceModel.fromMap(e['_id'], e)).toList();
  }

  Future<void> createAbsence(LessonModel lesson, AbsenceModel absence) async {
    if ((await getStudentAbsence(lesson, absence.personId, absence.date)).isEmpty) {
      var data = absence.toMap();
      data['institution_id'] = institution.id;
      data['class_id'] = lesson.aclass.id;
      await dio.putUri<Map<String, dynamic>>(
        baseUriFunc('/absence'),
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: data,
      );
    }
  }

  Future<void> deleteAbsence(AbsenceModel absence) async {
    await dio.deleteUri(
      baseUriFunc('/absence/${absence.id}'),
    );
  }

  Future<List<MarkType>> getAllMarktypes() async {
    var res = await dio.getUri<List>(baseUriFunc('/marktype'));
    var js = res.data!;
    return js.map((e) => MarkType.fromMap(e['_id'], e)).toList();
  }

  Future<String> saveMarktype(MarkType mt) async {
    var data = mt.toMap();
    data['institution_id'] = institution.id;
    var res = await dio.putUri<Map<String, dynamic>>(
      baseUriFunc('/marktype'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<void> deleteMarktype(MarkType mt) async {
    await dio.deleteUri(
      baseUriFunc('/marktype/${mt.id}'),
    );
  }

  Future<List<LessonMarkModel>> getAllLessonMarks(LessonModel lesson, DateTime date) async {
    var res = await dio.getUri<List>(
      baseUriFunc('/class/${lesson.aclass.id}/curriculum/${lesson.curriculumId}/mark/${date.toIso8601String()}/${lesson.order}'),
    );
    var js = res.data!;
    return js.map((e) => LessonMarkModel.fromMap(e['_id'], e)).toList();
  }

  Future<List<LessonMarkModel>> getStudentLessonMarks(LessonModel lesson, StudentModel student, DateTime date) async {
    var res = await dio.getUri<List>(
      baseUriFunc('/curriculum/${lesson.curriculumId}/student/${student.id}/mark/${date.toIso8601String()}/${lesson.order}'),
    );
    var js = res.data!;
    return js.map((e) => LessonMarkModel.fromMap(e['_id'], e)).toList();
  }

  Future<List<LessonMarkModel>> getStudentLessonMarksByCurriculums(StudentModel student, List<CurriculumModel> curriculums, StudyPeriodModel period) async {
    var res = await dio.postUri<List>(
      baseUriFunc('/student/${student.id}/curriculums/mark/${period.from.toIso8601String()}/${period.till.toIso8601String()}'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: curriculums.map((e) => e.id).toList(),
    );
    var js = res.data!;
    return js.map((e) => LessonMarkModel.fromMap(e['_id'], e)).toList();
  }

  Future<List<LessonMarkModel>> getCurriculumLessonMarksByStudents(CurriculumModel curriculum, List<StudentModel> students, StudyPeriodModel period) async {
    var res = await dio.postUri<List>(
      baseUriFunc('/curriculum/${curriculum.id}/students/mark/${period.from.toIso8601String()}/${period.till.toIso8601String()}'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: students.map((e) => e.id).toList(),
    );
    var js = res.data!;
    return js.map((e) => LessonMarkModel.fromMap(e['_id'], e)).toList();
  }

  Future<List<PeriodMarkModel>> getCurriculumPeriodMarksByStudents(CurriculumModel curriculum, List<StudentModel> students, StudyPeriodModel period) async {
    var res = await dio.postUri<List>(
      baseUriFunc('/curriculum/${curriculum.id}/students/mark/period/${period.id}'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: students.map((e) => e.id).toList(),
    );
    var js = res.data!;
    return js.map((e) => PeriodMarkModel.fromMap(e['_id'], e)).toList();
  }

  // Future<List<PeriodMarkModel>> getStudentPeriodMarksByCurriculums(StudentModel student, List<CurriculumModel> curriculums, StudyPeriodModel period) async {
  //   var res = await dio.postUri<List>(
  //     baseUriFunc('/student/${student.id}/curriculums/mark/period/${period.id}'),
  //     options: Options(headers: {'Content-Type': 'application/json'}),
  //     data: curriculums.map((e) => e.id).toList(),
  //   );
  //   var js = res.data!;
  //   return js.map((e) => PeriodMarkModel.fromMap(e['_id'], e)).toList();
  // }

  Future<List<PeriodMarkModel>> getStudentAllPerioddMarks(StudentModel student, List<CurriculumModel> curriculums) async {
    var periods = await currentInstitution!.currentYearAndSemestersPeriods;
    var res = await dio.postUri<List>(
      baseUriFunc('/student/${student.id}/curriculums/mark/periods'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: {
        'curriculums': curriculums.map((e) => e.id).toList(),
        'periods': periods.map((e) => e.id).toList(),
      },
    );
    var js = res.data!;
    return js.map((e) => PeriodMarkModel.fromMap(e['_id'], e)).toList();
  }

  Future<List<PeriodMarkModel>> getPeriodsMarksByStudents(
    List<StudentModel> students,
    List<StudyPeriodModel> periods,
    CurriculumModel cur,
  ) async {
    var res = await dio.postUri<List>(
      baseUriFunc('/curriculum/${cur.id}/mark/periods'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: {
        'students': students.map((e) => e.id).toList(),
        'periods': periods.map((e) => e.id).toList(),
      },
    );
    var js = res.data!;
    return js.map((e) => PeriodMarkModel.fromMap(e['_id'], e)).toList();
  }

  Future<String> saveLessonMark(LessonMarkModel mark) async {
    var data = mark.toMap(withId: true);
    data['institution_id'] = institution.id;
    var res = await dio.putUri<Map<String, dynamic>>(
      baseUriFunc('/mark'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<String> savePeriodMark(PeriodMarkModel mark) async {
    var data = mark.toMap(withId: true);
    data['institution_id'] = institution.id;
    var res = await dio.putUri<Map<String, dynamic>>(
      baseUriFunc('/mark'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<void> deleteMark(MarkModel mark) async {
    await dio.deleteUri(
      baseUriFunc('/mark/${mark.id}'),
    );
  }

  Future<List<StudyPeriodModel>> getAllStudyPeriods() async {
    var res = await dio.getUri<List>(baseUriFunc('/period'));
    var js = res.data!;
    return js.map((data) => StudyPeriodModel.fromMap(data['_id'], data)).toList();
  }

  Future<StudyPeriodModel?> getYearPeriodForDate(DateTime date) async {
    var res = await dio.getUri<List>(baseUriFunc('/period/year/${date.toIso8601String()}'));
    var js = res.data!;
    if (js.length != 1) return null;
    return StudyPeriodModel.fromMap(js[0]['_id'], js[0]);
  }

  Future<StudyPeriodModel?> getSemesterPeriodForDate(DateTime date) async {
    var res = await dio.getUri<Map<String, dynamic>>(baseUriFunc('/period/semester/${date.toIso8601String()}'));
    var js = res.data!;
    return StudyPeriodModel.fromMap(js['_id'], js);
  }

  Future<List<StudyPeriodModel>> getSemesterPeriodsForPeriod(StudyPeriodModel period) async {
    var res = await dio.getUri<List>(baseUriFunc('/period/semester/${period.from.toIso8601String()}/${period.till.toIso8601String()}'));
    var js = res.data!;
    return js.map((data) => StudyPeriodModel.fromMap(data['_id'], data)).toList();
  }

  Future<StudyPeriodModel> getStudyPeriod(String id) async {
    var res = await dio.getUri<Map<String, dynamic>>(baseUriFunc('/period/$id'));
    var js = res.data!;
    return StudyPeriodModel.fromMap(js['_id'], js);
  }

  Future<String> saveStudyPeriod(StudyPeriodModel period) async {
    var data = period.toMap(withId: true);
    data['institution_id'] = institution.id;
    var res = await dio.putUri<Map<String, dynamic>>(
      baseUriFunc('/period'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
    var js = res.data!;
    return js['id'];
  }

  Future<List<ClassScheduleModel>> getClassWeekSchedule(ClassModel aclass, Week currentWeek) async {
    var res = await dio.getUri<List>(
      baseUriFunc('/class/${aclass.id}/weekschedule/${currentWeek.day(0).toIso8601String()}'),
    );
    return res.data!.map((e) => ClassScheduleModel.fromMap(aclass, e['_id'], e)).toList();
  }

  Future<List<StudentScheduleModel>> getStudentWeekSchedule(ClassModel aclass, Week currentWeek, StudentModel student) async {
    var res = await dio.getUri(baseUriFunc('/class/${aclass.id}/weekschedule/${currentWeek.day(0).toIso8601String()}/student/${student.id}'));
    return (res.data as List<dynamic>).map((e) => StudentScheduleModel.fromMap(aclass, e['_id'], e)).toList();
  }

  Future<List<TeacherScheduleModel>> getTeacherWeekSchedule(TeacherModel teacher, Week currentWeek) async {
    var res = await dio.getUri<List>(baseUriFunc('/person/${teacher.id}/teacher/weekschedule/${currentWeek.day(0).toIso8601String()}'));
    return res.data!.map((e) => TeacherScheduleModel.fromMap(e['schedule_id'], e)).toList();
  }

  Future<List<ClassModel>> getCurriculumClasses(CurriculumModel curriculum) async {
    var res = await dio.getUri<List>(baseUriFunc('/curriculum/${curriculum.id}/class'));
    return res.data!.map((e) => ClassModel.fromMap(e['_id'], e)).toList();
  }

  Future<List<StudentModel>> getCurriculumStudents(CurriculumModel curriculum) async {
    var res = await dio.getUri<List>(baseUriFunc('/curriculum/${curriculum.id}/student'));
    return res.data!.map((e) => StudentModel.fromMap(e['_id'], e)).toList();
  }

  Future<List<CurriculumModel>> getClassCurriculums(ClassModel aclass) async {
    var res = await dio.getUri<List>(baseUriFunc('/class/${aclass.id}/curriculum'));
    return res.data!.map((e) => CurriculumModel.fromMap(e['_id'], e)).toList();
  }

  Future<List<CurriculumModel>> getStudentCurriculums(StudentModel student) async {
    var res = await dio.getUri<List>(baseUriFunc('/person/${student.id}/student/curriculum'));
    return res.data!.map((e) => CurriculumModel.fromMap(e['_id'], e)).toList();
  }

  Future<List<CurriculumModel>> getTeacherCurriculums(TeacherModel teacher) async {
    var res = await dio.getUri<List>(baseUriFunc('/person/${teacher.id}/teacher/curriculum'));
    return res.data!.map((e) => CurriculumModel.fromMap(e['_id'], e)).toList();
  }

  Future<DateTime> getNextLessonDate(ClassModel aclass, CurriculumModel curriculum, DateTime date) async {
    var res = await dio.getUri<Map<String, dynamic>>(baseUriFunc('/class/${aclass.id}/curriculum/${curriculum.id}/nextdate/${date.toIso8601String()}'));
    return DateTime.parse(res.data!['nextdate']);
  }

  Future<Uint8List> getFile(String filename) async {
    var res = await dio.getUri<Uint8List>(baseUriFunc('/files/$filename'), options: Options(responseType: ResponseType.bytes));
    return res.data!;
  }

  Future<void> logEvent(Map<String, dynamic> data) async {
    data['institution_id'] = institution.id;
    data['timestamp'] = DateTime.now().toIso8601String();
    dio.putUri<Map<String, dynamic>>(
      baseUriFunc('/eventlog'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );
  }
}
