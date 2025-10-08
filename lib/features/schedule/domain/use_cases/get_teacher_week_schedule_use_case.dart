import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/schedule/domain/model/params/get_week_schedule_params.dart';
import 'package:schoosch/features/schedule/domain/model/schedule_model.dart';
import 'package:schoosch/features/schedule/domain/repository/schedule_repository.dart';

final class GetTeacherWeekScheduleUseCase extends BaseUseCase<List<TeacherScheduleModel>, GetTeacherWeekScheduleParams> {
  GetTeacherWeekScheduleUseCase({
    required ScheduleRepository scheduleRepository,
  }) : _scheduleRepository = scheduleRepository;

  final ScheduleRepository _scheduleRepository;

  @override
  Future<List<TeacherScheduleModel>> invoke(params) async {
    return await _scheduleRepository.getTeacherWeekSchedule(
      params.teacherId,
      params.week,
    );
  }
}
