import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/homework/domain/models/homework_model.dart';
import 'package:schoosch/features/homework/domain/models/params/get_homework_on_date_params.dart';
import 'package:schoosch/features/homework/domain/repository/homework_repository.dart';

final class GetLessonHomeworkForClassUseCase extends BaseUseCase<List<HomeworkModel>, GetHomeworkParams> {
  GetLessonHomeworkForClassUseCase({
    required HomeworkRepository homeworkRepository,
  }) : _homeworkRepository = homeworkRepository;

  final HomeworkRepository _homeworkRepository;

  @override
  Future<List<HomeworkModel>> invoke(params) async {
    return await _homeworkRepository.getHomeworkThisLessonForClass(
      params.classId,
      params.curriculumId,
      params.date,
    );
  }
}
