import 'package:schoosch/core/providers/base_dio_functions.dart';
import 'package:schoosch/features/lesson/domain/models/lesson_model.dart';
import 'package:schoosch/old/model/institution_model.dart';

final class LessonRemoteDataSource {
  InstitutionModel? _currentInstitution;

  Future<void> init(InstitutionModel institution) async {
    _currentInstitution = institution;
  }

  Future<String> saveLesson(LessonModel lesson) async {
    var data = lesson.toMap(withId: true);
    data['institution_id'] = _currentInstitution!.id;
    data['class_id'] = lesson.aclassId;
    data['schedule_id'] = lesson.scheduleId;

    var js = await BaseDioFunctions.putMapData(
      path: '/class/${lesson.aclassId}/schedule/${lesson.scheduleId}/lesson',
      data: data,
    );

    return js['id'];
  }

  Future<LessonModel> getLessonById(String lessonId) async {
    var js = await BaseDioFunctions.get(path: '/lesson/$lessonId');
    return LessonModel.fromMap('', '', js['_id'], js);
  }

  Future<void> deleteLesson(String lessonId) async {
    await BaseDioFunctions.delete(
      path: '/lesson/$lessonId',
    );
  }

  Future<List<LessonModel>> getScheduleLessons(String classId, String scheduleId) async {
    var js = await BaseDioFunctions.getList(
      path: '/class/$classId/schedule/$scheduleId/lesson',
    );
    var res = js.map((data) => LessonModel.fromMap(classId, scheduleId, data['_id'], data)).toList();
    return res;
  }

  Future<DateTime> getNextLessonDate(String classId, String curriculumId, String dateIsoString) async {
    var js = await BaseDioFunctions.getMapData(
      path: '/class/$classId/curriculum/$curriculumId/nextdate/$dateIsoString',
    );
    return DateTime.parse(js['nextdate']);
  }

  Future<List<ReplacementLessonModel>> getReplacementsOnDate(String classId, String scheduleId, DateTime date) async {
    var js = await BaseDioFunctions.getList(
      path: '/class/$classId/replace/${date.toIso8601String()}',
    );
    return js.map((data) => ReplacementLessonModel.fromMap(classId, scheduleId, data['_id'], data)).toList();
  }

  Future<List<ReplacementLessonModel>> getAllReplacementsOnDate(String scheduleId, DateTime date) async {
    List<ReplacementLessonModel> repl = [];
    var js = await BaseDioFunctions.getList(
      path: '/replace/${date.toIso8601String()}',
    );

    for (var i in js) {
      repl.add(ReplacementLessonModel.fromMap(i['class_id'], scheduleId, i['_id'], i));
    }
    
    return repl;
  }

  Future<void> createReplacement({
    required String classId,
    required String curriculumId,
    required String teacherId,
    required String venueId,
    required int order,
    required DateTime date,
  }) async {
    var data = {
      'institution_id': _currentInstitution!.id,
      'class_id': classId,
      'order': order.toString(),
      'curriculum_id': curriculumId,
      'teacher_id': teacherId,
      'venue_id': venueId,
      'date': date.toIso8601String(),
    };

    await BaseDioFunctions.putMapData(
      path: '/class/$classId/replace',
      data: data,
    );
  }
}
