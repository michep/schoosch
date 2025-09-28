import 'package:schoosch/core/providers/base_dio_functions.dart';
import 'package:schoosch/features/completion/domain/model/completion_model.dart';
import 'package:schoosch/old/model/institution_model.dart';

final class CompletionRemoteDataSource {
  InstitutionModel? _currentInstitution;

  Future<void> init(InstitutionModel institution) async {
    _currentInstitution = institution;
  }

  Future<void> createCompletion(String homeworkId, String studentId) async {
    var data = {
      '_id': null,
      'completedby_id': studentId,
      'completed_time': DateTime.now().toIso8601String(),
      'confirmedby_id': null,
      'confirmed_time': null,
      'status': 1,
      'homework_id': homeworkId,
      'institution_id': _currentInstitution!.id,
    };

    var js = await BaseDioFunctions.putMapData(
      path: '/completion',
      data: data,
    );

    return js['id'];
  }

  Future<void> deleteCompletion(String completionId) async {
    await BaseDioFunctions.delete(
      path: '/completion/$completionId',
    );
  }

  Future<void> confirmCompletion(String completionId, String personId) async {
    var data = {
      'status': 2,
      'confirmedby_id': personId,
      'confirmed_time': DateTime.now().toIso8601String(),
    };

    await BaseDioFunctions.putMapData(
      path: '/completion/$completionId',
      data: data,
    );
  }

  Future<void> unconfirmCompletion(String completionId, String personId) async {
    var data = {
      'status': 1,
      'confirmedby_id': personId,
      'confirmed_time': null,
    };

    await BaseDioFunctions.putMapData(
      path: '/completion/$completionId',
      data: data,
    );
  }

  Future<CompletionModel?> getStudentHomeworkCompletion(String homeworkId, String studentId) async {
    var js = await BaseDioFunctions.getMapData(
      path: '/homework/$homeworkId/student/$studentId/completion',
    );
    return CompletionModel.fromMap(js['_id'], js);
  }

  Future<List<CompletionModel>> getAllHomeworkCompletions(String homeworkId) async {
    var js = await BaseDioFunctions.getList(
      path: '/homework/$homeworkId/completion',
    );
    return js.map((data) => CompletionModel.fromMap(data['_id'], data)).toList();
  }
}
