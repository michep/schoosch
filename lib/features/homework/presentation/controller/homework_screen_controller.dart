import 'dart:async';

import 'package:get/get.dart';
import 'package:schoosch/core/providers/base_controller.dart';
import 'package:schoosch/features/homework/domain/models/homework_model.dart';
import 'package:schoosch/features/homework/domain/use_cases/save_homework_use_case.dart';
import 'package:schoosch/features/lesson/domain/models/lesson_model.dart';
import 'package:schoosch/features/lesson/domain/models/params/get_next_lesson_date_params.dart';
import 'package:schoosch/features/lesson/domain/use_cases/get_lesson_by_id_use_case.dart';
import 'package:schoosch/features/lesson/domain/use_cases/get_next_lesson_date_use_case.dart';
import 'package:schoosch/features/person/domain/model/person_model.dart';
import 'package:schoosch/features/week/presentation/controller/week_controller.dart';

part 'homework_screen_state.dart';
part 'homework_screen_event.dart';

class HomeworkScreenController extends GetxController implements BaseController<HomeworkScreenEvent, HomeworkScreenState> {
  late Rx<HomeworkScreenState> _state;

  HomeworkScreenController({
    required SaveHomeworkUseCase saveHomeworkUseCase,
    required GetLessonByIdUseCase getLessonByIdUseCase,
    required GetNextLessonDateUseCase getNextLessonDateUseCase,
  }) : _saveHomeworkUseCase = saveHomeworkUseCase,
       _getLessonByIdUseCase = getLessonByIdUseCase,
       _getNextLessonDateUseCase = getNextLessonDateUseCase {
    // _currentWeek.value = week;
    // _pageController = PageController(initialPage: currentWeek.year * 100 + currentWeek.weekNumber);

    _state = InitializingHomeworkScreenState().obs;
  }

  HomeworkModel? previousHomework;
  LessonModel? currentLesson;
  StudentPersonModel? chosenStudent;
  DateTime? completeDate;
  String curriculumId = '';
  String teacherId = '';
  String classId = '';

  final SaveHomeworkUseCase _saveHomeworkUseCase;
  final GetLessonByIdUseCase _getLessonByIdUseCase;
  // final GetClassStudentsUseCase _getClassStudentsUseCase;
  final GetNextLessonDateUseCase _getNextLessonDateUseCase;
  // final SaveFileUseCase _saveFileUseCase;

  HomeworkScreenState currentState() {
    return _state.value;
  }

  @override
  void addEvent(HomeworkScreenEvent event) {
    switch (event) {
      case InitializeHomeworkScreenEvent():
        _onInitializeHomeworkScreenEvent(event: event);
      case ErrorHomeworkScreenEvent():
        _onErrorHomeworkScreenEvent(event: event);
      case SaveHomeworkHomeworkScreenEvent():
        _onSaveHomeworkHomeworkScreenEvent(event: event);
      default:
        return;
    }
  }

  @override
  void addState(HomeworkScreenState state) {
    _state.value = state;
  }

  FutureOr<void> _onInitializeHomeworkScreenEvent({
    required InitializeHomeworkScreenEvent event,
  }) async {
    previousHomework = event.previousHomework;

    if (previousHomework != null && previousHomework!.studentId != null) {
      // chosenStudent = await _getPersonByIdUseCase.invoke(previousHomework!.studentId!);
    }

    currentLesson = await _getLessonByIdUseCase.invoke(event.lessonId);
    // final teacherSchedule = await ;
    completeDate = await _getNextLessonDateUseCase.invoke(
      GetNextLessonDateParams(
        classId: classId,
        curriculumId: curriculumId,
        date: Get.find<WeekController>().currentWeek.day(),
      ),
    );
    curriculumId = currentLesson?.curriculumId ?? '';
    classId = currentLesson?.aclassId ?? '';
  }

  bool validate() {
    return completeDate != null;
  }

  FutureOr<void> _onSaveHomeworkHomeworkScreenEvent({
    required SaveHomeworkHomeworkScreenEvent event,
  }) async {
    late final HomeworkModel nhw;

    if (!validate()) {
      addState(ErrorInValidationHomeworkScreenState());
    }

    if (previousHomework != null) {
      nhw = HomeworkModel.fromMap(
        previousHomework?.id,
        {
          'date': event.fromDate.toIso8601String(),
          'todate': event.tillDate.toIso8601String(),
          'text': event.homeworkText,
          'class_id': previousHomework!.classId,
          'student_id': event.studentId,
          'teacher_id': previousHomework!.teacherId,
          'curriculum_id': previousHomework!.curriculumId,
        },
      );
    } else {
      nhw = HomeworkModel.fromMap(
        null,
        {
          'date': event.fromDate.toIso8601String(),
          'todate': completeDate!.toIso8601String(),
          'text': event.homeworkText,
          'class_id': classId,
          'student_id': event.studentId,
          'teacher_id': teacherId,
          'curriculum_id': curriculumId,
        },
      );
    }

    String saveResult = await _saveHomeworkUseCase.invoke(nhw);

    Get.back(result: saveResult != '');
  }

  FutureOr<void> _onErrorHomeworkScreenEvent({
    required ErrorHomeworkScreenEvent event,
  }) async {}
}
