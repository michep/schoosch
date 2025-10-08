part of 'homework_screen_controller.dart';

abstract class HomeworkScreenState {}

final class InitializingHomeworkScreenState extends HomeworkScreenState {}

final class LoadingHomeworkScreenState extends HomeworkScreenState {}

final class ErrorInValidationHomeworkScreenState extends HomeworkScreenState {}

final class LoadedHomeworkScreenState extends HomeworkScreenState {}