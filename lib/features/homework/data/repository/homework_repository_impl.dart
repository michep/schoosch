import 'package:schoosch/features/homework/data/data_source/homework_remote_data_source.dart';
import 'package:schoosch/features/homework/domain/models/homework_model.dart';
import 'package:schoosch/features/homework/domain/repository/homework_repository.dart';

final class HomeworkRepositoryImpl implements HomeworkRepository {
  HomeworkRepositoryImpl({
    required HomeworkRemoteDataSource homeworkRemoteDataSource,
  }) : _homeworkRemoteDataSource = homeworkRemoteDataSource;

  final HomeworkRemoteDataSource _homeworkRemoteDataSource;

  @override
  Future<String> saveHomework(HomeworkModel homework) async {
    return await _homeworkRemoteDataSource.saveHomework(homework);
  }

  @override
  Future<void> deleteHomework(String homeworkId) async {
    await _homeworkRemoteDataSource.deleteHomework(homeworkId);
  }

  @override
  Future<List<HomeworkModel>> getHomeworkNextLesson(
    String classId,
    String curriculumId,
    DateTime date,
  ) async {
    return await _homeworkRemoteDataSource.getHomeworkNextLesson(
      classId,
      curriculumId,
      date.toIso8601String(),
    );
  }

  @override
  Future<List<HomeworkModel>> getHomeworkThisLesson(
    String classId,
    String curriculumId,
    DateTime date,
  ) async {
    return await _homeworkRemoteDataSource.getHomeworkThisLesson(
      classId,
      curriculumId,
      date.toIso8601String(),
    );
  }
}
