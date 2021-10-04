import 'package:schoosch/data/lesson_model.dart';
import 'package:schoosch/data/lessontime_model.dart';
import 'package:schoosch/data/schedule_model.dart';
import 'package:schoosch/data/weekday_model.dart';
import 'package:schoosch/data/class_model.dart';

abstract class SchooschDatasource {
  Future<void> init();
  Future<void> getWeekdayNameModels();
  Future<void> getLessontimeModels();
  Future<WeekdaysModel> getWeekdayNameModel(int order);
  Future<LessontimeModel> getLessontimeModel(int order);
  Future<List<ClassModel>> getClassesModel();
  Future<List<ScheduleModel>> getSchedulesModel(String classId);
  Future<List<ScheduleModel>> getSchedulesWithLessonsModel(String classId);
  // Future<List<LessonModel>> getLessonsModel(String classId, String schedId);
  Future<void> updateLesson(LessonModel lesson);
}
