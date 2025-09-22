import 'package:schoosch/features/periods/data/data_source/periods_remote_data_source.dart';
import 'package:schoosch/features/periods/domain/repository/periods_repository.dart';
import 'package:schoosch/old/model/studyperiod_model.dart';

final class PeriodsRepositoryImpl implements PeriodsRepository {
  PeriodsRepositoryImpl({
    required PeriodsRemoteDataSource periodsRemoteDataSource,
  }) : _periodsRemoteDataSource = periodsRemoteDataSource;

  final PeriodsRemoteDataSource _periodsRemoteDataSource;

  @override
  Future<StudyPeriodModel?> getYearPeriodForDate(DateTime date) async {
    return await _periodsRemoteDataSource.getYearPeriodForDate(date);
  }

  @override
  Future<StudyPeriodModel?> getSemesterPeriodForDate(DateTime date) async {
    return await _periodsRemoteDataSource.getSemesterPeriodForDate(date);
  }

  @override
  Future<StudyPeriodModel?> getStudyPeriodById(String id) async {
    return await _periodsRemoteDataSource.getStudyPeriod(id);
  }

  @override
  Future<List<StudyPeriodModel?>> getSemesterPeriodsForStudyPeriod(StudyPeriodModel period) async {
    return await _periodsRemoteDataSource.getSemesterPeriodsForPeriod(period);
  }

  @override
  Future<List<StudyPeriodModel?>> getAllStudyPeriods() async {
    return await _periodsRemoteDataSource.getAllStudyPeriods();
  }

  @override
  Future<String> saveStudyPeriod(StudyPeriodModel studyPeriod) async {
    return await _periodsRemoteDataSource.saveStudyPeriod(studyPeriod);
  }
}
