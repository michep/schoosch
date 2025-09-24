import 'package:get/get.dart';
import 'package:schoosch/features/mark/data/data_source/mark_remote_data_source.dart';
import 'package:schoosch/features/mark/data/repository/mark_repository_impl.dart';
import 'package:schoosch/features/mark/domain/repository/mark_repository.dart';
import 'package:schoosch/features/mark/domain/use_cases/delete_mark_type_use_case.dart';
import 'package:schoosch/features/mark/domain/use_cases/delete_mark_use_case.dart';
import 'package:schoosch/features/mark/domain/use_cases/save_lesson_mark_use_case.dart';
import 'package:schoosch/features/mark/domain/use_cases/save_mark_type_use_case.dart';
import 'package:schoosch/features/mark/domain/use_cases/save_period_mark_use_case.dart';

class LessonBinding implements Bindings {
  @override
  void dependencies() {
    MarkRemoteDataSource markRemoteDataSource = MarkRemoteDataSource();
    MarkRepository markRepository = MarkRepositoryImpl(
      markRemoteDataSource: markRemoteDataSource,
    );

    Get.lazyPut<MarkRemoteDataSource>(() => markRemoteDataSource);

    Get.lazyPut<MarkRepository>(() => markRepository);

    Get.lazyPut<SaveLessonMarkUseCase>(
      () => SaveLessonMarkUseCase(
        markRepository: markRepository,
      ),
    );
    Get.lazyPut<SavePeriodMarkUseCase>(
      () => SavePeriodMarkUseCase(
        markRepository: markRepository,
      ),
    );
    Get.lazyPut<DeleteMarkUseCase>(
      () => DeleteMarkUseCase(
        markRepository: markRepository,
      ),
    );
    Get.lazyPut<SaveMarkTypeUseCase>(
      () => SaveMarkTypeUseCase(
        markRepository: markRepository,
      ),
    );
    Get.lazyPut<DeleteMarkTypeUseCase>(
      () => DeleteMarkTypeUseCase(
        markRepository: markRepository,
      ),
    );

    
  }
}
