final class GetHomeworkCombinedParams {
  GetHomeworkCombinedParams({
    required this.classId,
    required this.curriculumId,
    required this.date,
    this.studentIds,
  });

  final String classId;
  final List<String>? studentIds;
  final String curriculumId;
  final DateTime date;
}