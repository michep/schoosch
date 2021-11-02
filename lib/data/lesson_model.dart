import 'package:get/get.dart';
import 'package:schoosch/data/curriculum_model.dart';
import 'package:schoosch/data/fire_store.dart';
import 'package:schoosch/data/lessontime_model.dart';
import 'package:schoosch/data/venue_model.dart';

class LessonModel {
  final String _classId;
  final String _scheduleId;
  final String _id;
  final int _order;
  CurriculumModel? _curriculum;
  String? _curriculumId;
  VenueModel? _venue;
  String? _venueId;
  LessontimeModel? _lessontime;
  bool ready;

  String get id => _id;
  int get order => _order;

  LessonModel(
    this._classId,
    this._scheduleId,
    this._id,
    this._order,
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
      _lessontime = await data.getLessontimeModel(_order);
    }
    return _lessontime!;
  }

  Map<String, dynamic> toMap() {
    return {
      'ready': ready,
    };
  }
}
