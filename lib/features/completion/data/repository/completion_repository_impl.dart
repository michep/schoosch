import 'package:schoosch/features/completion/data/data_source/completion_remote_data_source.dart';
import 'package:schoosch/features/completion/domain/model/completion_model.dart';
import 'package:schoosch/features/completion/domain/repository/completion_repository.dart';

final class CompletionRepositoryImpl implements CompletionRepository {
  CompletionRepositoryImpl({
    required CompletionRemoteDataSource completionRemoteDataSource,
  }) : _completionRemoteDataSource = completionRemoteDataSource;

  final CompletionRemoteDataSource _completionRemoteDataSource;

  @override
  Future<void> createCompletion(
    String homeworkId,
    String studentId,
  ) async {
    await _completionRemoteDataSource.createCompletion(
      homeworkId,
      studentId,
    );
  }

  @override
  Future<void> deleteCompletion(String completionId) async {
    await _completionRemoteDataSource.deleteCompletion(completionId);
  }

  @override
  Future<CompletionModel?> getStudentHomeworkCompletion(
    String homeworkId,
    String studentId,
  ) async {
    return await _completionRemoteDataSource.getStudentHomeworkCompletion(
      homeworkId,
      studentId,
    );
  }

  @override
  Future<List<CompletionModel>> getAllHomeworkCompletions(
    String homeworkId,
  ) async {
    return await _completionRemoteDataSource.getAllHomeworkCompletions(
      homeworkId,
    );
  }

  @override
  Future<void> confirmCompletion(
    String completionId,
    String personId,
  ) async {
    await _completionRemoteDataSource.confirmCompletion(
      completionId,
      personId,
    );
  }

  @override
  Future<void> unconfirmCompletion(
    String completionId,
    String personId,
  ) async {
    await _completionRemoteDataSource.unconfirmCompletion(
      completionId,
      personId,
    );
  }
}
