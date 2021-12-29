import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';

class LessonModel {
  final ClassModel aclass;
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

  LessonModel.fromMap(this.aclass, this._schedule, this.id, Map<String, Object?> map) {
    order = map['order'] != null ? map['order'] as int : throw 'need order key in lesson $id';
    _curriculumId = map['curriculum_id'] != null ? map['curriculum_id'] as String : throw 'need curriculum_id key in lesson $id';
    _venueId = map['venue_id'] != null ? map['venue_id'] as String : throw 'need venue_id key in lesson $id';
  }

  Future<CurriculumModel?> get curriculum async {
    return _curriculum ??= await Get.find<FStore>().getCurriculum(_curriculumId);
  }

  Future<VenueModel?> get venue async {
    return _venue ??= await Get.find<FStore>().getVenue(_venueId);
  }

  Future<LessontimeModel> get lessontime async {
    return _lessontime ??= await aclass.getLessontime(order);
  }

  Future<List<HomeworkModel>> homeworksForStudent(StudentModel student) async {
    if (!_homeworkLoaded) {
      _homework.addAll(await Get.find<FStore>().getLessonHomeworksForStudent(_schedule, (await curriculum)!, student));
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

  Future<List<MarkModel>> marksForStudent(StudentModel student) async {
    if (!_marksLoaded) {
      _marks.addAll(await Get.find<FStore>().getLessonMarksForStudent(_schedule, this, student));
      _marksLoaded = true;
    }

    return _marks;
  }

  Future<String> marksForStudentAsString(StudentModel student) async {
    var ms = await marksForStudent(student);
    return ms.map((e) => e.mark.toString()).join(', ');
  }
}
