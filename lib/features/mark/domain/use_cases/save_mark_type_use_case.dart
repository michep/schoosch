import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/mark/domain/models/marktype_model.dart';
import 'package:schoosch/features/mark/domain/repository/mark_repository.dart';

final class SaveMarkTypeUseCase extends BaseUseCase<String, MarkType> {
  SaveMarkTypeUseCase({
    required MarkRepository markRepository,
  }) : _markRepository = markRepository;

  final MarkRepository _markRepository;

  @override
  Future<String> invoke(params) async {
    return await _markRepository.saveMarkType(params);
  }
}