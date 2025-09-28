import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/lesson/domain/models/lesson_model.dart';
import 'package:schoosch/features/lesson/domain/models/params/get_replacement_lessons_params.dart';
import 'package:schoosch/features/lesson/domain/repository/lesson_repository.dart';

final class GetClassReplacementsOnDateUseCase extends BaseUseCase<List<ReplacementLessonModel>, GetReplacementLessonsParams> {
  GetClassReplacementsOnDateUseCase({
    required LessonRepository lessonRepository,
  }) : _lessonRepository = lessonRepository;

  final LessonRepository _lessonRepository;

  @override
  Future<List<ReplacementLessonModel>> invoke(params) async {
    return await _lessonRepository.getReplacementsOnDate(
      params.classId!,
      params.curriculumId,
      params.date,
    );
  }
}
