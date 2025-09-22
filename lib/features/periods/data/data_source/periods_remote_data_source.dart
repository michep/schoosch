import 'package:schoosch/core/providers/base_dio_functions.dart';
import 'package:schoosch/old/model/institution_model.dart';
import 'package:schoosch/old/model/studyperiod_model.dart';

final class PeriodsRemoteDataSource {
  InstitutionModel? _currentInstitution;

  Future<void> init(InstitutionModel institution) async {
    _currentInstitution = institution;
  }

  Future<List<StudyPeriodModel>> getAllStudyPeriods() async {
    var js = await BaseDioFunctions.getList(path: '/period');
    return js.map((data) => StudyPeriodModel.fromMap(data['_id'], data)).toList();
  }

  Future<StudyPeriodModel?> getYearPeriodForDate(DateTime date) async {
    var js = await BaseDioFunctions.getList(
      path: '/period/year/${date.toIso8601String()}',
    );
    if (js.length != 1) return null;
    return StudyPeriodModel.fromMap(js[0]['_id'], js[0]);
  }

  Future<StudyPeriodModel?> getSemesterPeriodForDate(DateTime date) async {
    var js = await BaseDioFunctions.getMapData(
      path: '/period/semester/${date.toIso8601String()}',
    );
    return StudyPeriodModel.fromMap(js['_id'], js);
  }

  Future<List<StudyPeriodModel>> getSemesterPeriodsForPeriod(StudyPeriodModel period) async {
    var js = await BaseDioFunctions.getList(
      path: '/period/semester/${period.from.toIso8601String()}/${period.till.toIso8601String()}',
    );
    return js.map((data) => StudyPeriodModel.fromMap(data['_id'], data)).toList();
  }

  Future<StudyPeriodModel> getStudyPeriod(String id) async {
    var js = await BaseDioFunctions.getMapData(
      path: '/period/$id',
    );
    return StudyPeriodModel.fromMap(js['_id'], js);
  }

  Future<String> saveStudyPeriod(StudyPeriodModel period) async {
    var data = period.toMap(withId: true);
    data['institution_id'] = _currentInstitution!.id;

    var js = await BaseDioFunctions.putMapData(
      path: '/period',
      data: data,
    );
    return js['id'];
  }
}
