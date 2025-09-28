final class GetHomeworkForStudentParams {
  GetHomeworkForStudentParams({
    required this.classId,
    required this.studentId,
    required this.curriculumId,
    required this.date,
  });

  final String classId;
  final String studentId;
  final String curriculumId;
  final DateTime date;
}