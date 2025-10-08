import 'package:isoweek/isoweek.dart';
import 'package:schoosch/features/class/domain/model/class_model.dart';
import 'package:schoosch/features/schedule/domain/model/schedule_model.dart';

abstract class ScheduleRepository {
  Future<List<StudentScheduleModel>> getStudentWeekSchedule(
    ClassModel classModel,
    String ctudentId,
    Week currentWeek,
  );

  Future<List<ClassScheduleModel>> getClassWeekSchedule(
    ClassModel classModel,
    Week currentWeek,
  );

  Future<List<TeacherScheduleModel>> getTeacherWeekSchedule(
    String teacherId,
    Week currentWeek,
  );
}
