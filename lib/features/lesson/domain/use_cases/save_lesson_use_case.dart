import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/lesson/domain/models/lesson_model.dart';
import 'package:schoosch/features/lesson/domain/repository/lesson_repository.dart';

final class SaveLessonUseCase extends BaseUseCase<String, LessonModel> {
  SaveLessonUseCase({
    required LessonRepository lessonRepository,
  }) : _lessonRepository = lessonRepository;

  final LessonRepository _lessonRepository;

  @override
  Future<String> invoke(params) async {
    return await _lessonRepository.saveLesson(params);
  }
}
