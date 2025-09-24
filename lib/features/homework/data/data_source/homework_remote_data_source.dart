import 'package:schoosch/core/providers/base_dio_functions.dart';
import 'package:schoosch/features/homework/domain/models/homework_model.dart';
import 'package:schoosch/old/model/institution_model.dart';

final class HomeworkRemoteDataSource {
  InstitutionModel? _currentInstitution;

  Future<void> init(InstitutionModel institution) async {
    _currentInstitution = institution;
  }

  Future<List<HomeworkModel>> getHomeworkThisLesson(String classId, String curriculumId, String dateIsoString) async {
    var js = await BaseDioFunctions.getList(
      path: '/class/$classId/curriculum/$curriculumId/homework/beforedate/$dateIsoString',
    );
    return js.map((data) => HomeworkModel.fromMap(data['_id'], data)).toList();
  }

  Future<List<HomeworkModel>> getHomeworkNextLesson(String classId, String curriculumId, String dateIsoString) async {
    var js = await BaseDioFunctions.getList(
      path: '/class/$classId/curriculum/$curriculumId/homework/ondate/$dateIsoString',
    );
    return js.map((data) => HomeworkModel.fromMap(data['_id'], data)).toList();
  }

  Future<String> saveHomework(HomeworkModel homework) async {
    var data = homework.toMap();
    data['institution_id'] = _currentInstitution!.id;

    var js = await BaseDioFunctions.putMapData(
      path: '/homework',
      data: data,
    );
    return js['id'];
  }

  Future<void> deleteHomework(String homeworkId) async {
    await BaseDioFunctions.delete(
      path: '/homework/$homeworkId',
    );
  }
}
