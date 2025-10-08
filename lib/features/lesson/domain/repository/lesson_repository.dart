import 'package:schoosch/features/lesson/domain/models/lesson_model.dart';

abstract class LessonRepository {
  Future<String> saveLesson(LessonModel lesson);

  Future<LessonModel> getLessonById(String lessonId);

  Future<void> deleteLesson(String lessonId);

  Future<List<LessonModel>> getScheduleLessons(
    String classId,
    String scheduleId,
  );

  Future<DateTime> getNextLessonDate(
    String classId,
    String curriculumId,
    DateTime date,
  );

  Future<List<ReplacementLessonModel>> getReplacementsOnDate(
    String classId,
    String scheduleId,
    DateTime date,
  );

  Future<List<ReplacementLessonModel>> getAllReplacements(
    String scheduleId,
    DateTime date,
  );

  Future<void> createReplacement(
    String classId,
    String curriculumId,
    String teacherId,
    String venueId,
    int order,
    DateTime date,
  );
}
