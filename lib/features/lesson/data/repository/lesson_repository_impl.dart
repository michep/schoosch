import 'package:schoosch/features/lesson/data/data_source/lesson_remote_data_source.dart';
import 'package:schoosch/features/lesson/domain/models/lesson_model.dart';
import 'package:schoosch/features/lesson/domain/repository/lesson_repository.dart';

final class LessonRepositoryImpl implements LessonRepository {
  LessonRepositoryImpl({
    required LessonRemoteDataSource lessonRemoteDataSource,
  }) : _lessonRemoteDataSource = lessonRemoteDataSource;

  final LessonRemoteDataSource _lessonRemoteDataSource;

  @override
  Future<String> saveLesson(LessonModel lesson) async {
    return await _lessonRemoteDataSource.saveLesson(lesson);
  }

  @override
  Future<void> deleteLesson(String lessonId) async {
    await _lessonRemoteDataSource.deleteLesson(lessonId);
  }

  @override
  Future<List<LessonModel>> getScheduleLessons(
    String classId,
    String scheduleId,
  ) async {
    return await _lessonRemoteDataSource.getScheduleLessons(
      classId,
      scheduleId,
    );
  }

  @override
  Future<DateTime> getNextLessonDate(
    String classId,
    String curriculumId,
    DateTime date,
  ) async {
    return await _lessonRemoteDataSource.getNextLessonDate(
      classId,
      curriculumId,
      date.toIso8601String(),
    );
  }

  @override
  Future<List<ReplacementLessonModel>> getReplacementsOnDate(
    String classId,
    String scheduleId,
    DateTime date,
  ) async {
    return await _lessonRemoteDataSource.getReplacementsOnDate(
      classId,
      scheduleId,
      date,
    );
  }

  @override
  Future<List<ReplacementLessonModel>> getAllReplacements(
    String scheduleId,
    DateTime date,
  ) async {
    return await _lessonRemoteDataSource.getAllReplacementsOnDate(
      scheduleId,
      date,
    );
  }

  @override
  Future<void> createReplacement(
    String classId,
    String curriculumId,
    String teacherId,
    String venueId,
    int order,
    DateTime date,
  ) async {
    await _lessonRemoteDataSource.createReplacement(
      classId: classId,
      curriculumId: curriculumId,
      teacherId: teacherId,
      venueId: venueId,
      order: order,
      date: date,
    );
  }
}
