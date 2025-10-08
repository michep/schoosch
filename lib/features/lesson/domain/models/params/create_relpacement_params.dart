final class CreateReplacementParams {
  CreateReplacementParams({
    required this.classId,
    required this.curriculumId,
    required this.teacherId,
    required this.venueId,
    required this.order,
    required this.date,
  });

  final String classId;
  final String curriculumId;
  final int order;
  final String teacherId;
  final String venueId;
  final DateTime date;
}