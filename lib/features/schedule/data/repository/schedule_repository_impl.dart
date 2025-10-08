import 'package:isoweek/isoweek.dart';
import 'package:schoosch/features/class/domain/model/class_model.dart';
import 'package:schoosch/features/schedule/data/data_source/schedule_remote_data_source.dart';
import 'package:schoosch/features/schedule/domain/model/schedule_model.dart';
import 'package:schoosch/features/schedule/domain/repository/schedule_repository.dart';

final class ScheduleRepositoryImpl implements ScheduleRepository{
  ScheduleRepositoryImpl({
    required ScheduleRemoteDataSource scheduleRemoteDataSource,
  }) : _scheduleRemoteDataSource = scheduleRemoteDataSource;

  final ScheduleRemoteDataSource _scheduleRemoteDataSource;
  
  @override
  Future<List<StudentScheduleModel>> getStudentWeekSchedule(ClassModel classModel, String studentId, Week currentWeek,) async {
    return await _scheduleRemoteDataSource.getStudentWeekSchedule(classModel, studentId, currentWeek);
  }

  @override
  Future<List<ClassScheduleModel>> getClassWeekSchedule(ClassModel classModel, Week currentWeek,) async {
    return await _scheduleRemoteDataSource.getClassWeekSchedule(classModel, currentWeek);
  }

  @override
  Future<List<TeacherScheduleModel>> getTeacherWeekSchedule(String teacherId, Week currentWeek,) async {
    return await _scheduleRemoteDataSource.getTeacherWeekSchedule(teacherId, currentWeek);
  }
}