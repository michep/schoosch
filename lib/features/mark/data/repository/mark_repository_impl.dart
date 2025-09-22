import 'package:schoosch/features/mark/data/data_source/mark_remote_data_source.dart';
import 'package:schoosch/features/mark/domain/models/mark_model.dart';
import 'package:schoosch/features/mark/domain/models/marktype_model.dart';
import 'package:schoosch/features/mark/domain/repository/mark_repository.dart';

final class MarkRepositoryImpl implements MarkRepository {
  MarkRepositoryImpl({
    required MarkRemoteDataSource markRemoteDataSource,
  }) : _markRemoteDataSource = markRemoteDataSource;

  final MarkRemoteDataSource _markRemoteDataSource;

  @override
  Future<void> deleteMark(MarkModel mark) async {
    await _markRemoteDataSource.deleteMark(mark);
  }

  @override
  Future<void> saveLessonMark(LessonMarkModel lessonMark) async {
    await _markRemoteDataSource.saveLessonMark(lessonMark);
  }

  @override
  Future<void> savePeriodMark(PeriodMarkModel periodMark) async {
    await _markRemoteDataSource.savePeriodMark(periodMark);
  }

  @override
  Future<void> deleteMarkType(MarkType mark) async {
    await _markRemoteDataSource.deleteMarkType(mark);
  }

  @override
  Future<String> saveMarkType(MarkType markType) async {
    return await _markRemoteDataSource.saveMarkType(markType);
  }
}
