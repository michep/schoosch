import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/mark/domain/repository/mark_repository.dart';
import 'package:schoosch/features/mark/domain/models/marktype_model.dart';

final class DeleteMarkTypeUseCase extends BaseUseCase<void, MarkType> {
  DeleteMarkTypeUseCase({
    required MarkRepository markRepository,
  }) : _markRepository = markRepository;

  final MarkRepository _markRepository;

  @override
  Future<void> invoke(params) async {
    if (params.id != null) {
      await _markRepository.deleteMarkType(params);
    }
  }
}
