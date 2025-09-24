import 'package:schoosch/features/mark/domain/models/mark_model.dart';
import 'package:schoosch/features/mark/domain/models/marktype_model.dart';

abstract class MarkRepository {
  Future<void> deleteMark(MarkModel mark);

  Future<void> saveLessonMark(LessonMarkModel lessonMark);

  Future<void> savePeriodMark(PeriodMarkModel periodMark);

  Future<String> saveMarkType(MarkType markType);

  Future<void> deleteMarkType(MarkType markType);
}