import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/completion/domain/repository/completion_repository.dart';

final class DeleteCompletionUseCase extends BaseUseCase<void, String> {
  DeleteCompletionUseCase({
    required CompletionRepository completionRepository,
  }) : _completionRepository = completionRepository;

  final CompletionRepository _completionRepository;

  @override
  Future<void> invoke(params) async {
    await _completionRepository.deleteCompletion(params);
  }
}
