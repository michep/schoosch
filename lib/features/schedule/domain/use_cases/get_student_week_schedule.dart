import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/schedule/domain/model/params/get_week_schedule_params.dart';
import 'package:schoosch/features/schedule/domain/model/schedule_model.dart';
import 'package:schoosch/features/schedule/domain/repository/schedule_repository.dart';

final class GetStudentWeekSchedule extends BaseUseCase<List<StudentScheduleModel>, GetStudentWeekScheduleParams> {
  GetStudentWeekSchedule({
    required ScheduleRepository scheduleRepository,
  }) : _scheduleRepository = scheduleRepository;

  final ScheduleRepository _scheduleRepository;

  @override
  Future<List<StudentScheduleModel>> invoke(params) async {
    return await _scheduleRepository.getStudentWeekSchedule(
      params.classModel,
      params.studentId,
      params.week,
    );
  }
}
