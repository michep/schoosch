import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/lesson/domain/models/params/get_next_lesson_date_params.dart';
import 'package:schoosch/features/lesson/domain/repository/lesson_repository.dart';

final class GetScheduleLessonsUseCase extends BaseUseCase<DateTime, GetNextLessonDateParams> {
  GetScheduleLessonsUseCase({
    required LessonRepository lessonRepository,
  }) : _lessonRepository = lessonRepository;

  final LessonRepository _lessonRepository;

  @override
  Future<DateTime> invoke(params) async {
    return await _lessonRepository.getNextLessonDate(
      params.classId,
      params.curriculumId,
      params.date,
    );
  }
}
