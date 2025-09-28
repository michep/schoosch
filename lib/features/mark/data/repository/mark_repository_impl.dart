import 'package:schoosch/core/utils/utils.dart';
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
  Future<void> deleteMark(String markId) async {
    await _markRemoteDataSource.deleteMark(markId);
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
  Future<void> deleteMarkType(String markId) async {
    await _markRemoteDataSource.deleteMarkType(markId);
  }

  @override
  Future<String> saveMarkType(MarkType markType) async {
    return await _markRemoteDataSource.saveMarkType(markType);
  }

  @override
  Future<List<LessonMarkModel>> getLessonMarksForStudent(
    String studentId,
    String curriculumId,
    int lessonOrder,
    DateTime date,
  ) async {
    return await _markRemoteDataSource.getStudentLessonMarks(curriculumId, lessonOrder, studentId, date);
  }

  @override
  Future<Map<String, List<LessonMarkModel>>> getAllLessonMarks(
    String classId,
    String curriculumId,
    int lessonOrder,
    DateTime date,
  ) async {
    final allLessonMarks = await _markRemoteDataSource.getAllLessonMarks(classId, curriculumId, lessonOrder, date);

    final splittedMarks = Utils.splitLessonMarksByStudent(allLessonMarks);

    return splittedMarks;
  }
}
