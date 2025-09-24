final class GetScheduleLessonsParams {
  GetScheduleLessonsParams({
    required this.classId,
    required this.scheduleId,
    required this.date,
    this.needsEmpty = false,
  });

  final String classId;
  final String scheduleId;
  final DateTime? date;
  final bool needsEmpty;
}