import 'package:schoosch/core/providers/base_dio_functions.dart';
import 'package:schoosch/features/absence/domain/model/absence_model.dart';
import 'package:schoosch/old/model/institution_model.dart';
import 'package:schoosch/old/model/studyperiod_model.dart';

final class LessonRemoteDataSource {
  InstitutionModel? _currentInstitution;

  Future<void> init(InstitutionModel institution) async {
    _currentInstitution = institution;
  }

  Future<List<AbsenceModel>> getAllAbsences(String classId, int lessonOrder, DateTime date) async {
    var js = await BaseDioFunctions.getList(
      path: '/class/$classId/absence/${date.toIso8601String()}/$lessonOrder',
    );
    return js.map((data) => AbsenceModel.fromMap(data['_id'], data)).toList();
  }

  Future<List<AbsenceModel>> getStudentAbsence(String classId, int lessonOrder, String studentId, DateTime date) async {
    var js = await BaseDioFunctions.getList(
      path: '/class/$classId/student/$studentId/absence/${date.toIso8601String()}/$lessonOrder',
    );
    return js.map((data) => AbsenceModel.fromMap(data['_id'], data)).toList();
  }

  Future<List<AbsenceModel>> getAllPeriodtAbsences(List<String> studentIds, StudyPeriodModel period) async {
    var js = await BaseDioFunctions.postList(
      path: '/absence/${period.from}/${period.till}',
      data: studentIds,
    );
    return js.map((data) => AbsenceModel.fromMap(data['_id'], data)).toList();
  }

  Future<List<AbsenceModel>> getAbsencesByStudentIds(List<String> studentIds, StudyPeriodModel period) async {
    var js = await BaseDioFunctions.postList(
      path: '/absence/${period.from.toIso8601String()}/${period.till.toIso8601String()}',
      data: studentIds,
    );
    return js.map((e) => AbsenceModel.fromMap(e['_id'], e)).toList();
  }

  Future<void> createAbsence(String classId, int lessonOrder, AbsenceModel absence) async {
    if ((await getStudentAbsence(classId, lessonOrder, absence.personId, absence.date)).isEmpty) {
      var data = absence.toMap();
      data['institution_id'] = _currentInstitution!.id;
      data['class_id'] = classId;

      await BaseDioFunctions.putMapData(
        path: '/absence',
        data: data,
      );
    }
  }

  Future<void> deleteAbsence(String absenceId) async {
    await BaseDioFunctions.delete(
      path: '/absence/$absenceId',
    );
  }
}
