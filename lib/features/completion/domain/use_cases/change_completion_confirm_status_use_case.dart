import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/completion/domain/model/params/change_completion_confirm_status_params.dart';
import 'package:schoosch/features/completion/domain/repository/completion_repository.dart';

final class ChangeCompletionConfirmStatusUseCase extends BaseUseCase<void, ChangeCompletionConfirmStatusParams> {
  ChangeCompletionConfirmStatusUseCase({
    required CompletionRepository completionRepository,
  }) : _completionRepository = completionRepository;

  final CompletionRepository _completionRepository;

  @override
  Future<void> invoke(params) async {
    if (params.confirm) {
      await _completionRepository.confirmCompletion(
        params.completionId,
        params.personId,
      );
    } else {
      await _completionRepository.unconfirmCompletion(
        params.completionId,
        params.personId,
      );
    }
  }
}
