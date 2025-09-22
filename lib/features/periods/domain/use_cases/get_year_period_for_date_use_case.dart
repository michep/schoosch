import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/periods/domain/repository/periods_repository.dart';
import 'package:schoosch/old/model/studyperiod_model.dart';

final class GetYearPeriodForDateUseCase extends BaseUseCase<StudyPeriodModel?, DateTime> {
  GetYearPeriodForDateUseCase({
    required PeriodsRepository periodsRepository,
  }) : _periodsRepository = periodsRepository;

  final PeriodsRepository _periodsRepository;

  @override
  Future<StudyPeriodModel?> invoke(params) async {
    return await _periodsRepository.getYearPeriodForDate(params);
  }
}