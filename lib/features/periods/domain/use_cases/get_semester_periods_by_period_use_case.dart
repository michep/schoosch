import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/periods/domain/repository/periods_repository.dart';
import 'package:schoosch/old/model/studyperiod_model.dart';

final class GetSemesterPeriodsByPeriodUseCase extends BaseUseCase<List<StudyPeriodModel?>, StudyPeriodModel> {
  GetSemesterPeriodsByPeriodUseCase({
    required PeriodsRepository periodsRepository,
  }) : _periodsRepository = periodsRepository;

  final PeriodsRepository _periodsRepository;

  @override
  Future<List<StudyPeriodModel?>> invoke(params) async {
    return await _periodsRepository.getSemesterPeriodsForStudyPeriod(params);
  }
}