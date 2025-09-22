import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/mark/domain/models/mark_model.dart';
import 'package:schoosch/features/mark/domain/repository/mark_repository.dart';

final class SaveLessonMarkUseCase extends BaseUseCase<void, LessonMarkModel> {
  SaveLessonMarkUseCase({
    required MarkRepository markRepository,
  }) : _markRepository = markRepository;

  final MarkRepository _markRepository;

  @override
  Future<void> invoke(params) async {
    await _markRepository.saveLessonMark(params);
  }
}