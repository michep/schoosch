import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/homework/domain/models/homework_model.dart';
import 'package:schoosch/features/homework/domain/models/params/get_homework_combined_params.dart';
import 'package:schoosch/features/homework/domain/repository/homework_repository.dart';

final class GetAllNextLessonHomeworkUseCase extends BaseUseCase<Map<String, List<HomeworkModel>>, GetHomeworkCombinedParams> {
  GetAllNextLessonHomeworkUseCase({
    required HomeworkRepository homeworkRepository,
  }) : _homeworkRepository = homeworkRepository;

  final HomeworkRepository _homeworkRepository;

  @override
  Future<Map<String, List<HomeworkModel>>> invoke(params) async {
    return await _homeworkRepository.getAllHomeworkNextLesson(
      params.classId,
      params.studentIds,
      params.curriculumId,
      params.date,
    );
  }
}
