import 'package:schoosch/core/providers/base_dio_functions.dart';
import 'package:schoosch/features/mark/domain/models/mark_model.dart';
import 'package:schoosch/features/mark/domain/models/marktype_model.dart';
import 'package:schoosch/old/model/curriculum_model.dart';
import 'package:schoosch/old/model/institution_model.dart';
import 'package:schoosch/old/model/person_model.dart';
import 'package:schoosch/old/model/studyperiod_model.dart';

final class MarkRemoteDataSource {
  InstitutionModel? _currentInstitution;

  Future<void> init(InstitutionModel institution) async {
    _currentInstitution = institution;
  }

  Future<List<LessonMarkModel>> getAllLessonMarks(
    String classId,
    String curriculumId,
    int lessonOrder,
    DateTime date,
  ) async {
    var js = await BaseDioFunctions.getList(
      path: '/class/$classId/curriculum/$curriculumId/mark/${date.toIso8601String()}/$lessonOrder',
    );
    return js.map((e) => LessonMarkModel.fromMap(e['_id'], e)).toList();
  }

  Future<List<LessonMarkModel>> getStudentLessonMarks(
    String curriculumId,
    int lessonOrder,
    String studentId,
    DateTime date,
  ) async {
    var js = await BaseDioFunctions.getList(
      path: '/curriculum/$curriculumId/student/$studentId/mark/${date.toIso8601String()}/$lessonOrder',
    );
    return js.map((e) => LessonMarkModel.fromMap(e['_id'], e)).toList();
  }

  Future<List<LessonMarkModel>> getStudentLessonMarksByCurriculums(
    StudentModel student,
    List<CurriculumModel> curriculums,
    StudyPeriodModel period,
  ) async {
    var js = await BaseDioFunctions.postList(
      path: '/student/${student.id}/curriculums/mark/${period.from.toIso8601String()}/${period.till.toIso8601String()}',
      data: curriculums.map((e) => e.id).toList(),
    );
    return js.map((e) => LessonMarkModel.fromMap(e['_id'], e)).toList();
  }

  Future<List<LessonMarkModel>> getCurriculumLessonMarksByStudents(
    CurriculumModel curriculum,
    List<StudentModel> students,
    StudyPeriodModel period,
  ) async {
    var js = await BaseDioFunctions.postList(
      path: '/curriculum/${curriculum.id}/students/mark/${period.from.toIso8601String()}/${period.till.toIso8601String()}',
      data: students.map((e) => e.id).toList(),
    );
    return js.map((e) => LessonMarkModel.fromMap(e['_id'], e)).toList();
  }

  Future<List<PeriodMarkModel>> getCurriculumPeriodMarksByStudents(
    CurriculumModel curriculum,
    List<StudentModel> students,
    StudyPeriodModel period,
  ) async {
    var js = await BaseDioFunctions.postList(
      path: '/curriculum/${curriculum.id}/students/mark/period/${period.id}',
      data: students.map((e) => e.id).toList(),
    );
    return js.map((e) => PeriodMarkModel.fromMap(e['_id'], e)).toList();
  }

  Future<List<PeriodMarkModel>> getStudentAllPerioddMarks(
    StudentModel student,
    List<CurriculumModel> curriculums,
  ) async {
    var periods = await _currentInstitution!.currentYearAndSemestersPeriods;
    var js = await BaseDioFunctions.postList(
      path: '/student/${student.id}/curriculums/mark/periods',
      data: {
        'curriculums': curriculums.map((e) => e.id).toList(),
        'periods': periods.map((e) => e.id).toList(),
      },
    );
    return js.map((e) => PeriodMarkModel.fromMap(e['_id'], e)).toList();
  }

  Future<List<PeriodMarkModel>> getPeriodsMarksByStudents(
    List<StudentModel> students,
    List<StudyPeriodModel> periods,
    CurriculumModel cur,
  ) async {
    var js = await BaseDioFunctions.postList(
      path: '/curriculum/${cur.id}/mark/periods',
      data: {
        'curriculums': students.map((e) => e.id).toList(),
        'periods': periods.map((e) => e.id).toList(),
      },
    );
    return js.map((e) => PeriodMarkModel.fromMap(e['_id'], e)).toList();
  }

  Future<String> saveLessonMark(
    LessonMarkModel mark,
  ) async {
    var data = mark.toMap(withId: true);
    var js = await BaseDioFunctions.putMapData(
      path: '/mark',
      data: data,
    );
    return js['id'];
  }

  Future<String> savePeriodMark(
    PeriodMarkModel mark,
  ) async {
    var data = mark.toMap(withId: true);
    data['institution_id'] = _currentInstitution!.id;
    var js = await BaseDioFunctions.putMapData(
      path: '/mark',
      data: data,
    );
    return js['id'];
  }

  Future<void> deleteMark(
    String markId,
  ) async {
    await BaseDioFunctions.delete(
      path: '/mark/$markId',
    );
  }

  Future<List<MarkType>> getAllMarktypes() async {
    var js = await BaseDioFunctions.getList(path: '/marktype');
    return js.map((e) => MarkType.fromMap(e['_id'], e)).toList();
  }

  Future<String> saveMarkType(MarkType mt) async {
    var data = mt.toMap();
    data['institution_id'] = _currentInstitution!.id;
    var js = await BaseDioFunctions.putMapData(path: '/marktype', data: data);
    return js['id'];
  }

  Future<void> deleteMarkType(String mtId) async {
    await BaseDioFunctions.delete(
      path: '/marktype/$mtId',
    );
  }
}
