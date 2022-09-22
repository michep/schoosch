import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/daylessontime_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';

class ProxyStore extends getx.GetxController {
  final String host;
  late final InstitutionModel institution;
  PersonModel? _currentUser;
  late Dio dio = Dio();

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
      Uri.http(host, '/class'),
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
      Uri.http(host, '/venue'),
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
      Uri.http(host, '//lessontime/${daylessontime.id!}/time'),
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

  Future<List<StudentScheduleModel>> getClassWeekSchedule(ClassModel aclass, Week currentWeek) async {
    var res = await dio.getUri<List>(Uri.http(host, '/class/${aclass.id}/schedule'));
    var js = res.data!;
    return js
        .map((data) => StudentScheduleModel.fromMap(aclass, data['_id'], data))
        .where((data) => data.from!.isBefore(currentWeek.day(5)) && (data.till == null || data.till!.isAfter(currentWeek.day(4))))
        .toList();
  }

  Future<List<StudentScheduleModel>> getClassDaySchedule(ClassModel aclass, int day) async {
    var res = await dio.getUri<List>(Uri.http(host, '/class/${aclass.id}/schedule/day/$day'));
    var js = res.data!;
    return js.map((data) => StudentScheduleModel.fromMap(aclass, data['_id'], data)).toList();
  }

  Future<String> saveDaySchedule(DayScheduleModel schedule) async {
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

  Future<List<LessonModel>> getScheduleLessons(ClassModel aclass, DayScheduleModel schedule, {DateTime? date, bool needsEmpty = false}) async {
    List<LessonModel> less = [];
    var res = await dio.getUri<List>(Uri.http(host, '/class/${aclass.id}/schedule/${schedule.id}/lesson'));
    var js = res.data!;
    less = js.map((data) => LessonModel.fromMap(aclass, schedule, data['_id'], data)).toList();

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
      less.add(nl ?? l);
    }
    less.sort(
      (a, b) => a.order.compareTo(b.order),
    );
    return less;
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

    // if (lesson.id == null) {
    //   return ((await _db.collection('lesson').insertOne(data)).id as ObjectId).toHexString();
    // } else {
    //   data['_id'] = ObjectId.fromHexString(lesson.id!);
    //   await _db.collection('lesson').replaceOne(where.eq('_id', data['_id']), data);
    //   return lesson.id!;
    // }
  }

  Future<void> deleteLesson(LessonModel lesson) async {
    var data = lesson.toMap(withId: true);
    await dio.deleteUri(
      Uri.http(host, '/class/${lesson.aclass.id!}/schedule/${lesson.schedule.id}/lesson/${lesson.id}'),
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: data,
    );

    // if (lesson.id != null) {
    //   _db.collection('lesson').deleteOne(where.eq('_id', lesson.id!));
    // }
  }

  Future<List<ReplacementModel>> getReplacementsOnDate(ClassModel aclass, DayScheduleModel schedule, DateTime date) async {
    var res = await dio.postUri<List>(Uri.http(host, '/class/${aclass.id}/replace'),
        options: Options(headers: {'Content-Type': 'application/json'}), data: {'date': date.toIso8601String()});
    var js = res.data!;
    return js.map((data) => ReplacementModel.fromMap(aclass, schedule, data['_id'], data)).toList();
  }
}
