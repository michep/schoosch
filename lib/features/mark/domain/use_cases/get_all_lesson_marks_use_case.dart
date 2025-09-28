import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/mark/domain/models/mark_model.dart';
import 'package:schoosch/features/mark/domain/models/params/get_all_lesson_mark_params.dart';
import 'package:schoosch/features/mark/domain/repository/mark_repository.dart';

final class SaveLessonMarkUseCase extends BaseUseCase<Map<String, List<LessonMarkModel>>, GetAllLessonMarkParams> {
  SaveLessonMarkUseCase({
    required MarkRepository markRepository,
  }) : _markRepository = markRepository;

  final MarkRepository _markRepository;

  @override
  Future<Map<String, List<LessonMarkModel>>> invoke(params) async {
    return await _markRepository.getAllLessonMarks(
      params.classId,
      params.curriculumId,
      params.lessonOrder,
      params.date,
    );
  }
}
