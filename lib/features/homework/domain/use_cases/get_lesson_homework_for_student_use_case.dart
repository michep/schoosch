import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/homework/domain/models/homework_model.dart';
import 'package:schoosch/features/homework/domain/models/params/get_homework_for_student_params.dart';
import 'package:schoosch/features/homework/domain/repository/homework_repository.dart';

final class GetLessonHomeworkForStudentUseCase extends BaseUseCase<List<HomeworkModel>, GetHomeworkForStudentParams> {
  GetLessonHomeworkForStudentUseCase({
    required HomeworkRepository homeworkRepository,
  }) : _homeworkRepository = homeworkRepository;

  final HomeworkRepository _homeworkRepository;

  @override
  Future<List<HomeworkModel>> invoke(params) async {
    return await _homeworkRepository.getHomeworkThisLessonForStudent(
      params.classId,
      params.studentId,
      params.curriculumId,
      params.date,
    );
  }
}
