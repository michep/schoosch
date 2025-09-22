import 'package:schoosch/old/model/studyperiod_model.dart';

abstract class PeriodsRepository {
  Future<StudyPeriodModel?> getYearPeriodForDate(DateTime date);

  Future<StudyPeriodModel?> getSemesterPeriodForDate(DateTime date);

  Future<StudyPeriodModel?> getStudyPeriodById(String id);

  Future<List<StudyPeriodModel?>> getSemesterPeriodsForStudyPeriod(StudyPeriodModel period);

  Future<List<StudyPeriodModel?>> getAllStudyPeriods();

  Future<String> saveStudyPeriod(StudyPeriodModel studyPeriod);
}