import 'package:get/get.dart';
import 'package:schoosch/features/periods/data/data_source/periods_remote_data_source.dart';
import 'package:schoosch/features/periods/data/repository/periods_repository_impl.dart';
import 'package:schoosch/features/periods/domain/repository/periods_repository.dart';
import 'package:schoosch/features/periods/domain/use_cases/get_all_study_periods_use_case.dart';
import 'package:schoosch/features/periods/domain/use_cases/get_semester_period_for_date_use_case.dart';
import 'package:schoosch/features/periods/domain/use_cases/get_study_period_use_case.dart';
import 'package:schoosch/features/periods/domain/use_cases/get_year_period_for_date_use_case.dart';
import 'package:schoosch/features/periods/domain/use_cases/save_study_period_use_case.dart';

class PeriodsBindings implements Bindings {
  @override
  void dependencies() {
    PeriodsRemoteDataSource periodsRemoteDataSource = PeriodsRemoteDataSource();
    PeriodsRepository periodsRepository = PeriodsRepositoryImpl(
      periodsRemoteDataSource: periodsRemoteDataSource,
    );

    Get.lazyPut<PeriodsRemoteDataSource>(() => periodsRemoteDataSource);

    Get.lazyPut<PeriodsRepository>(() => periodsRepository);

    Get.lazyPut<SaveStudyPeriodUseCase>(
      () => SaveStudyPeriodUseCase(
        periodsRepository: periodsRepository,
      ),
    );
    Get.lazyPut<GetYearPeriodForDateUseCase>(
      () => GetYearPeriodForDateUseCase(
        periodsRepository: periodsRepository,
      ),
    );
    Get.lazyPut<GetSemesterPeriodForDateUseCase>(
      () => GetSemesterPeriodForDateUseCase(
        periodsRepository: periodsRepository,
      ),
    );
    Get.lazyPut<GetSemesterPeriodForDateUseCase>(
      () => GetSemesterPeriodForDateUseCase(
        periodsRepository: periodsRepository,
      ),
    );
    Get.lazyPut<GetAllStudyPeriodsUseCase>(
      () => GetAllStudyPeriodsUseCase(
        periodsRepository: periodsRepository,
      ),
    );
    Get.lazyPut<GetStudyPeriodUseCase>(
      () => GetStudyPeriodUseCase(
        periodsRepository: periodsRepository,
      ),
    );
  }
}
