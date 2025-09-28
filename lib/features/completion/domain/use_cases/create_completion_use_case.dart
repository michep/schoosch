import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/completion/domain/model/params/homewor_completion_params.dart';
import 'package:schoosch/features/completion/domain/repository/completion_repository.dart';

final class CreateCompletionUseCase extends BaseUseCase<void, HomeworCompletionParams> {
  CreateCompletionUseCase({
    required CompletionRepository completionRepository,
  }) : _completionRepository = completionRepository;

  final CompletionRepository _completionRepository;

  @override
  Future<void> invoke(params) async {
    await _completionRepository.createCompletion(
      params.homeworkId,
      params.studentId!,
    );
  }
}
