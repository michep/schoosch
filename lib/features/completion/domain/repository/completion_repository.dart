import 'package:schoosch/features/completion/domain/model/completion_model.dart';

abstract class CompletionRepository {
  Future<void> createCompletion(
    String homeworkId,
    String studentId,
  );

  Future<void> deleteCompletion(String completionId);

  Future<CompletionModel?> getStudentHomeworkCompletion(
    String homeworkId,
    String studentId,
  );

  Future<List<CompletionModel>> getAllHomeworkCompletions(
    String homeworkId,
  );

  Future<void> confirmCompletion(
    String completionId,
    String personId,
  );

  Future<void> unconfirmCompletion(
    String completionId,
    String personId,
  );
}
