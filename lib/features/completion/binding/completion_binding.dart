import 'package:get/get.dart';
import 'package:schoosch/features/completion/data/data_source/completion_remote_data_source.dart';
import 'package:schoosch/features/completion/data/repository/completion_repository_impl.dart';
import 'package:schoosch/features/completion/domain/repository/completion_repository.dart';
import 'package:schoosch/features/completion/domain/use_cases/change_completion_confirm_status_use_case.dart';
import 'package:schoosch/features/completion/domain/use_cases/create_completion_use_case.dart';
import 'package:schoosch/features/completion/domain/use_cases/delete_completion_use_case.dart';
import 'package:schoosch/features/completion/domain/use_cases/get_all_homework_completions_use_case.dart';
import 'package:schoosch/features/completion/domain/use_cases/get_student_homework_completion_use_case.dart';

class HomeworkBinding implements Bindings {
  @override
  void dependencies() {
    CompletionRemoteDataSource completionRemoteDataSource = CompletionRemoteDataSource();
    CompletionRepository completionRepository = CompletionRepositoryImpl(
      completionRemoteDataSource: completionRemoteDataSource,
    );

    Get.lazyPut<CompletionRemoteDataSource>(() => completionRemoteDataSource);

    Get.lazyPut<CompletionRepository>(() => completionRepository);

    Get.lazyPut<CreateCompletionUseCase>(
      () => CreateCompletionUseCase(
        completionRepository: completionRepository,
      ),
    );
    Get.lazyPut<DeleteCompletionUseCase>(
      () => DeleteCompletionUseCase(
        completionRepository: completionRepository,
      ),
    );
    Get.lazyPut<GetAllHomeworkCompletionsUseCase>(
      () => GetAllHomeworkCompletionsUseCase(
        completionRepository: completionRepository,
      ),
    );
    Get.lazyPut<GetStudentHomeworkCompletionUseCase>(
      () => GetStudentHomeworkCompletionUseCase(
        completionRepository: completionRepository,
      ),
    );
    Get.lazyPut<ChangeCompletionConfirmStatusUseCase>(
      () => ChangeCompletionConfirmStatusUseCase(
        completionRepository: completionRepository,
      ),
    );
  }
}
