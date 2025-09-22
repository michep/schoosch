import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/core/use_case/empty_use_case_param.dart';
import 'package:schoosch/features/periods/domain/repository/periods_repository.dart';
import 'package:schoosch/old/model/studyperiod_model.dart';

final class GetAllStudyPeriodsUseCase extends BaseUseCase<List<StudyPeriodModel?>, EmptyUseCaseParam> {
  GetAllStudyPeriodsUseCase({
    required PeriodsRepository periodsRepository,
  }) : _periodsRepository = periodsRepository;

  final PeriodsRepository _periodsRepository;

  @override
  Future<List<StudyPeriodModel?>> invoke(params) async {
    return await _periodsRepository.getAllStudyPeriods();
  }
}