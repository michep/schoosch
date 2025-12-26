import 'package:get/get.dart';
import 'package:schoosch/features/home_schedule/presentation/controller/home_schedule_screen_controller.dart';
import 'package:schoosch/features/homework/domain/use_cases/save_homework_use_case.dart';
import 'package:schoosch/features/lesson/domain/use_cases/get_lesson_by_id_use_case.dart';
import 'package:schoosch/features/lesson/domain/use_cases/get_next_lesson_date_use_case.dart';

class HomeScheduleBinding implements Bindings {
  @override
  void dependencies() {
    // HomeworkRemoteDataSource homeworkRemoteDataSource = HomeworkRemoteDataSource();
    // HomeworkRepository homeworkRepository = HomeworkRepositoryImpl(
    //   homeworkRemoteDataSource: homeworkRemoteDataSource,
    // );

    // Get.lazyPut<HomeworkRemoteDataSource>(() => homeworkRemoteDataSource);

    // Get.lazyPut<HomeworkRepository>(() => homeworkRepository);

    // Get.lazyPut<SaveHomeworkUseCase>(
    //   () => SaveHomeworkUseCase(
    //     homeworkRepository: homeworkRepository,
    //   ),
    // );
    // Get.lazyPut<DeleteHomeworkUseCase>(
    //   () => DeleteHomeworkUseCase(
    //     homeworkRepository: homeworkRepository,
    //   ),
    // );
    // Get.lazyPut<GetAllLessonHomeworkUseCase>(
    //   () => GetAllLessonHomeworkUseCase(
    //     homeworkRepository: homeworkRepository,
    //   ),
    // );
    // Get.lazyPut<GetAllNextLessonHomeworkUseCase>(
    //   () => GetAllNextLessonHomeworkUseCase(
    //     homeworkRepository: homeworkRepository,
    //   ),
    // );
    // Get.lazyPut<GetLessonHomeworkForClassUseCase>(
    //   () => GetLessonHomeworkForClassUseCase(
    //     homeworkRepository: homeworkRepository,
    //   ),
    // );
    // Get.lazyPut<GetNextLessonHomeworkForClassUseCase>(
    //   () => GetNextLessonHomeworkForClassUseCase(
    //     homeworkRepository: homeworkRepository,
    //   ),
    // );
    // Get.lazyPut<GetLessonHomeworkForStudentUseCase>(
    //   () => GetLessonHomeworkForStudentUseCase(
    //     homeworkRepository: homeworkRepository,
    //   ),
    // );
    // Get.lazyPut<GetNextLessonHomeworkForStudentUseCase>(
    //   () => GetNextLessonHomeworkForStudentUseCase(
    //     homeworkRepository: homeworkRepository,
    //   ),
    // );

    Get.lazyPut<HomeScheduleScreenController>(
      () => HomeScheduleScreenController(
        saveHomeworkUseCase: Get.find<SaveHomeworkUseCase>(), 
        getLessonByIdUseCase: Get.find<GetLessonByIdUseCase>(), 
        getNextLessonDateUseCase: Get.find<GetNextLessonDateUseCase>(),
      )
    );
  }
}
