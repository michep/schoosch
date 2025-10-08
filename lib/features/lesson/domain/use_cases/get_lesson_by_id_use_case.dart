import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/lesson/domain/models/lesson_model.dart';
import 'package:schoosch/features/lesson/domain/repository/lesson_repository.dart';

final class GetLessonByIdUseCase extends BaseUseCase<LessonModel, String> {
  GetLessonByIdUseCase({
    required LessonRepository lessonRepository,
  }) : _lessonRepository = lessonRepository;

  final LessonRepository _lessonRepository;

  @override
  Future<LessonModel> invoke(params) async {
    return await _lessonRepository.getLessonById(params);
  }
}
