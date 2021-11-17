import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/venue_model.dart';

class LessonModel {
  final String classId;
  final String scheduleId;
  final String id;
  late final int order;
  late final String _curriculumId;
  late final String _venueId;
  late bool ready;
  CurriculumModel? _curriculum;
  VenueModel? _venue;
  LessontimeModel? _lessontime;

  LessonModel.fromMap(this.classId, this.scheduleId, this.id, Map<String, Object?> map) {
    order = map['order'] != null ? map['order'] as int : -1;
    _curriculumId = map['curriculum_id'] != null ? map['curriculum_id'] as String : '';
    _venueId = map['venue_id'] != null ? map['venue_id'] as String : '';
    ready = map['ready'] != null ? map['ready'] as bool : false;
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

  Map<String, dynamic> toMap() {
    return {
      'ready': ready,
    };
  }
}
