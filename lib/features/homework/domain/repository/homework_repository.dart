import 'package:schoosch/features/homework/domain/models/homework_model.dart';

abstract class HomeworkRepository {
  Future<String> saveHomework(HomeworkModel lesson);

  Future<void> deleteHomework(String lessonId);

  Future<List<HomeworkModel>> getHomeworkThisLesson(
    String classId,
    String curriculumId,
    DateTime date,
  );

  Future<List<HomeworkModel>> getHomeworkNextLesson(
    String classId,
    String curriculumId,
    DateTime date,
  );
}
