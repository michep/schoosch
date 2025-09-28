import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/homework/domain/models/homework_model.dart';
import 'package:schoosch/features/homework/domain/repository/homework_repository.dart';

final class SaveHomeworkUseCase extends BaseUseCase<String, HomeworkModel> {
  SaveHomeworkUseCase({
    required HomeworkRepository homeworkRepository,
  }) : _homeworkRepository = homeworkRepository;

  final HomeworkRepository _homeworkRepository;

  @override
  Future<String> invoke(params) async {
    return await _homeworkRepository.saveHomework(params);
  }
}
