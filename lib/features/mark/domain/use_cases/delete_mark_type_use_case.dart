import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/mark/domain/repository/mark_repository.dart';

final class DeleteMarkTypeUseCase extends BaseUseCase<void, String?> {
  DeleteMarkTypeUseCase({
    required MarkRepository markRepository,
  }) : _markRepository = markRepository;

  final MarkRepository _markRepository;

  @override
  Future<void> invoke(params) async {
    if (params != null) {
      await _markRepository.deleteMarkType(params);
    }
  }
}
