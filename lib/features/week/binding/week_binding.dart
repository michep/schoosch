import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/features/week/presentation/controller/week_controller.dart';

class WeekBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<MarkRemoteDataSource>(() => markRemoteDataSource);

    // Get.lazyPut<MarkRepository>(() => markRepository);

    // Get.lazyPut<DeleteMarkTypeUseCase>(
    //   () => DeleteMarkTypeUseCase(
    //     markRepository: markRepository,
    //   ),
    // );

    Get.lazyPut<WeekController>(
      () => WeekController(
        week: Week.current(),
      ),
    );
  }
}
