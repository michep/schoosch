import 'dart:async';

import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/core/providers/base_controller.dart';
import 'package:schoosch/features/homework/domain/models/homework_model.dart';
import 'package:schoosch/features/homework/domain/use_cases/save_homework_use_case.dart';
import 'package:schoosch/features/lesson/domain/models/lesson_model.dart';
import 'package:schoosch/features/lesson/domain/use_cases/get_lesson_by_id_use_case.dart';
import 'package:schoosch/features/lesson/domain/use_cases/get_next_lesson_date_use_case.dart';
import 'package:schoosch/features/person/domain/model/person_model.dart';
import 'package:schoosch/features/week/presentation/controller/week_controller.dart';

part 'home_schedule_screen_event.dart';
part 'home_schedule_screen_state.dart';

enum HomeScheduleType {
  student,
  teacher,
  observer,
  other
}

class HomeScheduleScreenController extends GetxController implements BaseController<HomeScheduleScreenEvent, HomeScheduleScreenState> {
  late Rx<HomeScheduleScreenState> _state;
  late StreamSubscription<Week> week;

  HomeScheduleScreenController({
    required SaveHomeworkUseCase saveHomeworkUseCase,
    required GetLessonByIdUseCase getLessonByIdUseCase,
    required GetNextLessonDateUseCase getNextLessonDateUseCase,
  }) {
    week = Get.find<WeekController>().weekStream.listen((v) {
      addEvent(ChangeWeekHomeScheduleScreenEvent());
    });
    _state = InitializingHomeScheduleScreenState().obs;
  }

  HomeScheduleType? screenType;

  HomeworkModel? previousHomework;
  LessonModel? currentLesson;
  StudentPersonModel? chosenStudent;
  DateTime? completeDate;
  String curriculumId = '';
  String teacherId = '';
  String classId = '';

  HomeScheduleScreenState currentState() {
    return _state.value;
  }

  @override
  void addEvent(HomeScheduleScreenEvent event) {
    switch (event) {
      case InitializeHomeScheduleScreenEvent():
        _onInitializeHomeScheduleScreenEvent(event: event);
      case ChangeWeekHomeScheduleScreenEvent():
        _onChangedWeekHomeScheduleScreenEvent(event: event);
      case ErrorHomeScheduleScreenEvent():
        _onErrorHomeScheduleScreenEvent(event: event);
      default:
        return;
    }
  }

  @override
  void addState(HomeScheduleScreenState state) {
    _state.value = state;
  }

  FutureOr<void> _onInitializeHomeScheduleScreenEvent({
    required InitializeHomeScheduleScreenEvent event,
  }) async {
    screenType = event.screenType;
  }

  FutureOr<void> _onChangedWeekHomeScheduleScreenEvent({
    required ChangeWeekHomeScheduleScreenEvent event,
  }) async {}

  FutureOr<void> _onErrorHomeScheduleScreenEvent({
    required ErrorHomeScheduleScreenEvent event,
  }) async {}
}
