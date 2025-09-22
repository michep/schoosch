import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/mark/domain/repository/mark_repository.dart';
import 'package:schoosch/features/mark/domain/models/mark_model.dart';

final class DeleteMarkUseCase extends BaseUseCase<void, MarkModel> {
  DeleteMarkUseCase({
    required MarkRepository markRepository,
  }) : _markRepository = markRepository;

  final MarkRepository _markRepository;

  @override
  Future<void> invoke(params) async {
    await _markRepository.deleteMark(params);
  }
}