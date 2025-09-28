import 'package:schoosch/core/use_case/base_use_case.dart';
import 'package:schoosch/features/lesson/domain/models/lesson_model.dart';
import 'package:schoosch/features/lesson/domain/models/params/get_schedule_lessons_params.dart';
import 'package:schoosch/features/lesson/domain/repository/lesson_repository.dart';

final class GetScheduleLessonsUseCase extends BaseUseCase<List<LessonModel>, GetScheduleLessonsParams> {
  GetScheduleLessonsUseCase({
    required LessonRepository lessonRepository,
  }) : _lessonRepository = lessonRepository;

  final LessonRepository _lessonRepository;

  @override
  Future<List<LessonModel>> invoke(params) async {
    List<LessonModel> lessonsData = await _lessonRepository.getScheduleLessons(
      params.classId,
      params.scheduleId,
    );

    List<LessonModel> result = [];
    List<ReplacementLessonModel> reps = [];
    if (params.date != null) {
      reps.addAll(
        (await _lessonRepository.getReplacementsOnDate(
          params.classId,
          params.scheduleId,
          params.date!,
        )).toList(),
      );
    }

    if (params.needsEmpty) {
      int maxOrder = 1;
      for (var l in lessonsData) {
        if (l.order > maxOrder) {
          maxOrder = l.order;
        }
      }

      List<int> empt = List.generate(maxOrder, (index) => index + 1);
      empt.removeWhere((element) {
        for (var l in lessonsData) {
          if (l.order == element) {
            return true;
          }
        }
        return false;
      });

      for (var i in empt) {
        var nl = EmptyLessonModel.fromMap(
          params.classId,
          params.scheduleId,
          null,
          i,
        );
        nl.setAsEmpty();
        lessonsData.add(nl);
      }
    }

    for (var l in lessonsData) {
      LessonModel? nl;
      for (var r in reps) {
        if (l.order == r.order) {
          l.setReplacedType();
          nl = r;
        }
      }
      result.add(nl ?? l);
    }
    result.sort(
      (a, b) => a.order.compareTo(b.order),
    );
    // scheduleLessonsMutex.release();
    return result;
  }
}
