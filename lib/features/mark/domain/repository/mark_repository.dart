import 'package:schoosch/features/mark/domain/models/mark_model.dart';
import 'package:schoosch/features/mark/domain/models/marktype_model.dart';

abstract class MarkRepository {
  Future<void> deleteMark(String markId);

  Future<void> saveLessonMark(LessonMarkModel lessonMark);

  Future<void> savePeriodMark(PeriodMarkModel periodMark);

  Future<String> saveMarkType(MarkType markType);

  Future<void> deleteMarkType(String markTypeId);

  Future<List<LessonMarkModel>> getLessonMarksForStudent(
    String studentId,
    String curriculumId,
    int lessonOrder,
    DateTime date,
  );

  Future<Map<String, List<LessonMarkModel>>> getAllLessonMarks(
    String classId,
    String curriculumId,
    int lessonOrder,
    DateTime date,
  );
}