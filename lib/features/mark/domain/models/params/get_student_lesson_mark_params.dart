final class GetStudentLessonMarkParams {
  GetStudentLessonMarkParams({
    required this.studentId,
    required this.curriculumId,
    required this.lessonOrder,
    required this.date,
  });

  final String studentId;
  final String curriculumId;
  final int lessonOrder;
  final DateTime date;
}