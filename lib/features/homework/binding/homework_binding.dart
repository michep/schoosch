import 'package:get/get.dart';
import 'package:schoosch/features/homework/data/data_source/homework_remote_data_source.dart';
import 'package:schoosch/features/homework/data/repository/homework_repository_impl.dart';
import 'package:schoosch/features/homework/domain/repository/homework_repository.dart';
import 'package:schoosch/features/homework/domain/use_cases/delete_homework_use_case.dart';
import 'package:schoosch/features/homework/domain/use_cases/get_all_lesson_homework_use_case.dart';
import 'package:schoosch/features/homework/domain/use_cases/get_all_next_lesson_homework_use_case.dart';
import 'package:schoosch/features/homework/domain/use_cases/get_lesson_homework_for_class_use_case.dart';
import 'package:schoosch/features/homework/domain/use_cases/get_lesson_homework_for_student_use_case.dart';
import 'package:schoosch/features/homework/domain/use_cases/get_next_lesson_homework_for_class_use_case.dart';
import 'package:schoosch/features/homework/domain/use_cases/get_next_lesson_homework_for_student_use_case.dart';
import 'package:schoosch/features/homework/domain/use_cases/save_homework_use_case.dart';

class HomeworkBinding implements Bindings {
  @override
  void dependencies() {
    HomeworkRemoteDataSource homeworkRemoteDataSource = HomeworkRemoteDataSource();
    HomeworkRepository homeworkRepository = HomeworkRepositoryImpl(
      homeworkRemoteDataSource: homeworkRemoteDataSource,
    );

    Get.lazyPut<HomeworkRemoteDataSource>(() => homeworkRemoteDataSource);

    Get.lazyPut<HomeworkRepository>(() => homeworkRepository);

    Get.lazyPut<SaveHomeworkUseCase>(
      () => SaveHomeworkUseCase(
        homeworkRepository: homeworkRepository,
      ),
    );
    Get.lazyPut<DeleteHomeworkUseCase>(
      () => DeleteHomeworkUseCase(
        homeworkRepository: homeworkRepository,
      ),
    );
    Get.lazyPut<GetAllLessonHomeworkUseCase>(
      () => GetAllLessonHomeworkUseCase(
        homeworkRepository: homeworkRepository,
      ),
    );
    Get.lazyPut<GetAllNextLessonHomeworkUseCase>(
      () => GetAllNextLessonHomeworkUseCase(
        homeworkRepository: homeworkRepository,
      ),
    );
    Get.lazyPut<GetLessonHomeworkForClassUseCase>(
      () => GetLessonHomeworkForClassUseCase(
        homeworkRepository: homeworkRepository,
      ),
    );
    Get.lazyPut<GetNextLessonHomeworkForClassUseCase>(
      () => GetNextLessonHomeworkForClassUseCase(
        homeworkRepository: homeworkRepository,
      ),
    );
    Get.lazyPut<GetLessonHomeworkForStudentUseCase>(
      () => GetLessonHomeworkForStudentUseCase(
        homeworkRepository: homeworkRepository,
      ),
    );
    Get.lazyPut<GetNextLessonHomeworkForStudentUseCase>(
      () => GetNextLessonHomeworkForStudentUseCase(
        homeworkRepository: homeworkRepository,
      ),
    );
  }
}
