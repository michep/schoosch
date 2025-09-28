final class GetHomeworkParams {
  GetHomeworkParams({
    required this.classId,
    required this.curriculumId,
    required this.date,
  });

  final String classId;
  final String curriculumId;
  final DateTime date;
}