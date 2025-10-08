import 'package:isoweek/isoweek.dart';
import 'package:schoosch/features/class/domain/model/class_model.dart';

class GetWeekScheduleParams {
  GetWeekScheduleParams({required this.week});
  final Week week;
}

final class GetTeacherWeekScheduleParams extends GetWeekScheduleParams {
  GetTeacherWeekScheduleParams({
    required this.teacherId,
    required super.week,
  });

  final String teacherId;
}

final class GetClassWeekScheduleParams extends GetWeekScheduleParams {
  GetClassWeekScheduleParams({
    required this.classModel,
    required super.week,
  });

  final ClassModel classModel;
}

final class GetStudentWeekScheduleParams extends GetWeekScheduleParams {
  GetStudentWeekScheduleParams({
    required this.classModel,
    required this.studentId,
    required super.week,
  });

  final ClassModel classModel;
  final String studentId;
}
