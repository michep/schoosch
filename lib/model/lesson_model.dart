import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/venue_model.dart';

class LessonModel {
  final String classId;
  final String scheduleId;
  final String id;
  final int order;
  CurriculumModel? _curriculum;
  String? _curriculumId;
  VenueModel? _venue;
  String? _venueId;
  LessontimeModel? _lessontime;
  bool ready;

  LessonModel(
    this.classId,
    this.scheduleId,
    this.id,
    this.order,
    this._curriculumId,
    this._venueId,
    this.ready,
  );

  LessonModel.fromMap(String classId, String scheduleId, String id, Map<String, Object?> map)
      : this(
          classId,
          scheduleId,
          id,
          map['order'] != null ? map['order'] as int : -1,
          map['curriculum_id'] != null ? map['curriculum_id'] as String : '',
          map['venue_id'] != null ? map['venue_id'] as String : '',
          map['ready'] != null ? map['ready'] as bool : false,
        );

  Future<CurriculumModel> get curriculum async {
    if (_curriculum == null && _curriculumId != null) {
      var data = Get.find<FStore>();
      _curriculum = await data.getCurriculumModel(_curriculumId!);
    }
    return _curriculum!;
  }

  Future<VenueModel> get venue async {
    if (_venue == null && _venueId != null) {
      var data = Get.find<FStore>();
      _venue = await data.getVenueModel(_venueId!);
    }
    return _venue!;
  }

  Future<LessontimeModel> get lessontime async {
    if (_lessontime == null) {
      var data = Get.find<FStore>();
      _lessontime = await data.getLessontimeModel(order);
    }
    return _lessontime!;
  }

  Map<String, dynamic> toMap() {
    return {
      'ready': ready,
    };
  }
}
