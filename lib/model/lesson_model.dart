import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/venue_model.dart';

class LessonModel {
  final ClassModel _class;
  final DayScheduleModel _schedule;
  final String id;
  late final int order;
  late final String _curriculumId;
  late final String _venueId;
  final List<HomeworkModel> _homework = [];
  bool _homeworkLoaded = false;
  final List<MarkModel> _marks = [];
  bool _marksLoaded = false;
  CurriculumModel? _curriculum;
  VenueModel? _venue;
  LessontimeModel? _lessontime;

  String get classId => _class.id;
  String get scheduleId => _schedule.id;

  LessonModel.fromMap(this._class, this._schedule, this.id, Map<String, Object?> map) {
    order = map['order'] != null ? map['order'] as int : throw 'need order key in lesson';
    _curriculumId = map['curriculum_id'] != null ? map['curriculum_id'] as String : throw 'need curriculum_id key in lesson';
    _venueId = map['venue_id'] != null ? map['venue_id'] as String : throw 'need venue_id key in lesson';
  }

  Future<CurriculumModel?> get curriculum async {
    return _curriculum ??= await Get.find<FStore>().getCurriculum(_curriculumId);
  }

  Future<VenueModel?> get venue async {
    return _venue ??= await Get.find<FStore>().getVenue(_venueId);
  }

  Future<LessontimeModel> get lessontime async {
    return _lessontime ??= await _class.getLessontime(order);
  }

  Future<List<HomeworkModel>?> get homeworksCurrentStudent async {
    if (!_homeworkLoaded) {
      _homework.addAll(await Get.find<FStore>().getLessonHomeworksForCurrentStudent(_schedule, (await curriculum)!));
      _homeworkLoaded = true;
    }
    return _homework;
  }

  Future<List<HomeworkModel>?> get homeworks async {
    if (!_homeworkLoaded) {
      _homework.addAll(await Get.find<FStore>().getLessonHomeworks(_schedule, (await curriculum)!));
      _homeworkLoaded = true;
    }
    return _homework;
  }

  Future<List<MarkModel>?> get marksCurrentStudent async {
    if (!_marksLoaded) {
      _marks.addAll(await Get.find<FStore>().getLessonMarksForCurrentStudent(_schedule, this));
      _marksLoaded = true;
    }

    return _marks;
  }

  Future<String> get marksCurrentStudentAsString async {
    var ms = await marksCurrentStudent;
    return ms != null ? ms.map((e) => e.mark.toString()).join(', ') : '';
  }
}
