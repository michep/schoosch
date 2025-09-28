import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/lesson/domain/models/lesson_model.dart';
import 'package:schoosch/features/lesson/domain/models/params/get_replacement_lessons_params.dart';
import 'package:schoosch/features/lesson/domain/repository/lesson_repository.dart';

final class GetAllReplacementsOnDateUseCase extends BaseUseCase<List<ReplacementLessonModel>, GetReplacementLessonsParams> {
  GetAllReplacementsOnDateUseCase({
    required LessonRepository lessonRepository,
  }) : _lessonRepository = lessonRepository;

  final LessonRepository _lessonRepository;

  @override
  Future<List<ReplacementLessonModel>> invoke(params) async {
    return await _lessonRepository.getAllReplacements(
      params.curriculumId,
      params.date,
    );
  }
}
