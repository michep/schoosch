import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/completion/domain/model/completion_model.dart';
import 'package:schoosch/features/completion/domain/model/params/homewor_completion_params.dart';
import 'package:schoosch/features/completion/domain/repository/completion_repository.dart';

final class GetAllHomeworkCompletionsUseCase extends BaseUseCase<List<CompletionModel>, HomeworCompletionParams> {
  GetAllHomeworkCompletionsUseCase({
    required CompletionRepository completionRepository,
  }) : _completionRepository = completionRepository;

  final CompletionRepository _completionRepository;

  @override
  Future<List<CompletionModel>> invoke(params) async {
    return await _completionRepository.getAllHomeworkCompletions(
      params.homeworkId,
    );
  }
}
