import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/homework/domain/models/homework_model.dart';
import 'package:schoosch/features/homework/domain/models/params/get_homework_on_date_params.dart';
import 'package:schoosch/features/homework/domain/repository/homework_repository.dart';

final class GetHomeworkNextLesson extends BaseUseCase<List<HomeworkModel>, GetHomeworkOnDateParams> {
  GetHomeworkNextLesson({
    required HomeworkRepository homeworkRepository,
  }) : _homeworkRepository = homeworkRepository;

  final HomeworkRepository _homeworkRepository;

  @override
  Future<List<HomeworkModel>> invoke(params) async {
    return await _homeworkRepository.getHomeworkNextLesson(
      params.classId,
      params.curriculumId,
      params.date,
    );
  }
}
