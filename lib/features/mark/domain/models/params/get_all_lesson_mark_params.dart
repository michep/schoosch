final class GetAllLessonMarkParams {
  GetAllLessonMarkParams({
    required this.classId,
    required this.curriculumId,
    required this.lessonOrder,
    required this.date,
  });

  final String classId;
  final String curriculumId;
  final int lessonOrder;
  final DateTime date;
}