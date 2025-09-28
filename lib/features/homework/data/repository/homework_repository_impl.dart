import 'package:schoosch/core/utils/utils.dart';
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
  Future<Map<String, List<HomeworkModel>>> getSplittedHomeworkNextLesson(
    String classId,
    String curriculumId,
    DateTime date,
  ) async {
    final allHomework = await _homeworkRemoteDataSource.getHomeworkNextLesson(
      classId,
      curriculumId,
      date.toIso8601String(),
    );

    final splittedHomework = Utils.splitHomeworksByStudent(allHomework);

    return splittedHomework;
  }

  @override
  Future<Map<String, List<HomeworkModel>>> getSplittedHomeworkThisLesson(
    String classId,
    String curriculumId,
    DateTime date,
  ) async {
    final allHomework = await _homeworkRemoteDataSource.getHomeworkThisLesson(
      classId,
      curriculumId,
      date.toIso8601String(),
    );

    final splittedHomework = Utils.splitHomeworksByStudent(allHomework);

    return splittedHomework;
  }

  @override
  Future<List<HomeworkModel>> getHomeworkThisLessonForStudent(
    String classId,
    String studentId,
    String curriculumId,
    DateTime date,
  ) async {
    final splittedHomework = await getSplittedHomeworkThisLesson(classId, curriculumId, date);

    return splittedHomework[studentId] ?? [];
  }

  Future<List<HomeworkModel>> getHomeworkNextLessonForStudent(
    String classId,
    String studentId,
    String curriculumId,
    DateTime date,
  ) async {
    final splittedHomework = await getSplittedHomeworkNextLesson(classId, curriculumId, date);

    return splittedHomework[studentId] ?? [];
  }

  @override
  Future<List<HomeworkModel>> getHomeworkThisLessonForClass(
    String classId,
    String curriculumId,
    DateTime date,
  ) async {
    final splittedHomework = await getSplittedHomeworkThisLesson(classId, curriculumId, date);

    return splittedHomework['class'] ?? [];
  }

  @override
  Future<List<HomeworkModel>> getHomeworkNextLessonForClass(
    String classId,
    String curriculumId,
    DateTime date,
  ) async {
    final splittedHomework = await getSplittedHomeworkNextLesson(classId, curriculumId, date);

    return splittedHomework['class'] ?? [];
  }

  Future<Map<String, List<HomeworkModel>>> getAllHomeworkThisLesson(
    String classId,
    List<String>? studentIds,
    String curriculumId,
    DateTime date,
  ) async {
    final splittedHomework = await getSplittedHomeworkThisLesson(classId, curriculumId, date);
    Map<String, List<HomeworkModel>> res = {'class': splittedHomework['class'] ?? []};
    if (studentIds != null && studentIds.isNotEmpty) {
      for (String studentId in studentIds) {
        res.putIfAbsent(
          studentId,
          () => (splittedHomework[studentId] ?? []),
        );
      }
    }
    return res;
  }

  @override
  Future<Map<String, List<HomeworkModel>>> getAllHomeworkNextLesson(
    String classId,
    List<String>? studentIds,
    String curriculumId,
    DateTime date,
  ) async {
    final splittedHomework = await getSplittedHomeworkNextLesson(classId, curriculumId, date);
    Map<String, List<HomeworkModel>> res = {'class': splittedHomework['class'] ?? []};
    if (studentIds != null && studentIds.isNotEmpty) {
      for (String studentId in studentIds) {
        res.putIfAbsent(
          studentId,
          () => (splittedHomework[studentId] ?? []),
        );
      }
    }
    return res;
  }
}
