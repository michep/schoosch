part of 'homework_screen_controller.dart';

abstract class HomeworkScreenEvent {}

final class InitializeHomeworkScreenEvent extends HomeworkScreenEvent {
  InitializeHomeworkScreenEvent({
    required this.previousHomework,
    required this.teacherId,
    required this.curriculumId,
    required this.lessonId,
    required this.classId,
  });

  final HomeworkModel? previousHomework;
  final String teacherId;
  final String curriculumId;
  final String lessonId;
  final String classId;
}

final class SaveHomeworkHomeworkScreenEvent extends HomeworkScreenEvent {
  SaveHomeworkHomeworkScreenEvent({
    required this.homeworkText,
    required this.studentId,
    required this.tillDate,
    required this.fromDate,
  });

  final String? homeworkText;
  final String? studentId;
  final DateTime tillDate;
  final DateTime fromDate;
}

final class ErrorHomeworkScreenEvent extends HomeworkScreenEvent {
  ErrorHomeworkScreenEvent({
    required this.error,
  });

  final String error;
}