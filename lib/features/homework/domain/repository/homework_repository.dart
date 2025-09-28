import 'package:schoosch/features/homework/domain/models/homework_model.dart';

abstract class HomeworkRepository {
  Future<String> saveHomework(HomeworkModel lesson);

  Future<void> deleteHomework(String lessonId);

  Future<Map<String, List<HomeworkModel>>> getSplittedHomeworkThisLesson(
    String classId,
    String curriculumId,
    DateTime date,
  );

  Future<Map<String, List<HomeworkModel>>> getSplittedHomeworkNextLesson(
    String classId,
    String curriculumId,
    DateTime date,
  );

  Future<List<HomeworkModel>> getHomeworkThisLessonForStudent(
    String classId,
    String studentId,
    String curriculumId,
    DateTime date,
  );

  Future<List<HomeworkModel>> getHomeworkNextLessonForStudent(
    String classId,
    String studentId,
    String curriculumId,
    DateTime date,
  );

  Future<List<HomeworkModel>> getHomeworkThisLessonForClass(
    String classId,
    String curriculumId,
    DateTime date,
  );

  Future<List<HomeworkModel>> getHomeworkNextLessonForClass(
    String classId,
    String curriculumId,
    DateTime date,
  );

  Future<Map<String, List<HomeworkModel>>> getAllHomeworkThisLesson(
    String classId,
    List<String>? studentIds,
    String curriculumId,
    DateTime date,
  );

  Future<Map<String, List<HomeworkModel>>> getAllHomeworkNextLesson(
    String classId,
    List<String>? studentIds,
    String curriculumId,
    DateTime date,
  );
}
