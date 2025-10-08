part of 'home_schedule_screen_controller.dart';

abstract class HomeScheduleScreenEvent {}

class InitializeHomeScheduleScreenEvent extends HomeScheduleScreenEvent {
  InitializeHomeScheduleScreenEvent({required this.screenType});

  final HomeScheduleType screenType;
}

class ChangeWeekHomeScheduleScreenEvent extends HomeScheduleScreenEvent {}

class ErrorHomeScheduleScreenEvent extends HomeScheduleScreenEvent {}