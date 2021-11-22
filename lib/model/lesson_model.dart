import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/venue_model.dart';

class LessonModel {
  final ClassModel _class;
  final DayScheduleModel _schedule;
  final String id;
  late final int order;
  late final String _curriculumId;
  late final String _venueId;
  CurriculumModel? _curriculum;
  VenueModel? _venue;
  LessontimeModel? _lessontime;
  List<HomeworkModel>? _homework;

  String get classId => _class.id;
  String get scheduleId => _schedule.id;

  LessonModel.fromMap(this._class, this._schedule, this.id, Map<String, Object?> map) {
    order = map['order'] != null ? map['order'] as int : -1;
    _curriculumId = map['curriculum_id'] != null ? map['curriculum_id'] as String : '';
    _venueId = map['venue_id'] != null ? map['venue_id'] as String : '';
  }

  Future<CurriculumModel?> get curriculum async {
    return _curriculum ??= await Get.find<FStore>().getCurriculumModel(_curriculumId);
  }

  Future<VenueModel?> get venue async {
    return _venue ??= await Get.find<FStore>().getVenueModel(_venueId);
  }

  Future<LessontimeModel?> get lessontime async {
    return _lessontime ??= await Get.find<FStore>().getLessontimeModel(order);
  }

  Future<List<HomeworkModel>?> get homework async {
    return _homework ??= await Get.find<FStore>().getLessonHomework(_schedule, _curriculumId);
  }
}
