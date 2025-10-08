import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/lesson/domain/models/params/create_relpacement_params.dart';
import 'package:schoosch/features/lesson/domain/repository/lesson_repository.dart';

final class CreateReplacementUseCase extends BaseUseCase<void, CreateReplacementParams> {
  CreateReplacementUseCase({
    required LessonRepository lessonRepository,
  }) : _lessonRepository = lessonRepository;

  final LessonRepository _lessonRepository;

  @override
  Future<void> invoke(params) async {
    return await _lessonRepository.createReplacement(
      params.classId,
      params.curriculumId,
      params.teacherId,
      params.venueId,
      params.order,
      params.date,
    );
  }
}