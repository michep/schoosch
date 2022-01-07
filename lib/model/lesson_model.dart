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
  final DayScheduleModel schedule;
  String? _id;
  late int order;
  late final String _curriculumId;
  late final String _venueId;
  final List<HomeworkModel> _homework = [];
  bool _homeworkLoaded = false;
  final List<MarkModel> _marks = [];
  bool _marksLoaded = false;
  CurriculumModel? _curriculum;
  VenueModel? _venue;
  LessontimeModel? _lessontime;

  String? get id => _id;

  LessonModel.empty(ClassModel aclass, DayScheduleModel schedule, int order)
      : this.fromMap(aclass, schedule, null, <String, dynamic>{
          'order': order,
          'curriculum_id': '',
          'venue_id': '',
        });

  LessonModel.fromMap(this.aclass, this.schedule, this._id, Map<String, Object?> map) {
    order = map['order'] != null ? map['order'] as int : throw 'need order key in lesson $_id';
    _curriculumId = map['curriculum_id'] != null ? map['curriculum_id'] as String : throw 'need curriculum_id key in lesson $_id';
    _venueId = map['venue_id'] != null ? map['venue_id'] as String : throw 'need venue_id key in lesson $_id';
  }

  Future<CurriculumModel?> get curriculum async {
    if (_curriculumId.isNotEmpty) {
      return _curriculum ??= await Get.find<FStore>().getCurriculum(_curriculumId);
    }
  }

  Future<VenueModel?> get venue async {
    if (_venueId.isNotEmpty) {
      return _venue ??= await Get.find<FStore>().getVenue(_venueId);
    }
  }

  Future<LessontimeModel> get lessontime async {
    return _lessontime ??= await aclass.getLessontime(order);
  }

  Future<List<HomeworkModel>> homeworksForStudent(StudentModel student, DateTime date) async {
    if (!_homeworkLoaded) {
      _homework.addAll(await Get.find<FStore>().getLessonHomeworksForStudent(schedule, (await curriculum)!, student, date));
      _homeworkLoaded = true;
    }
    return _homework;
  }

  //   Future<List<HomeworkModel>> homeworksOnlyForStudent(StudentModel student) async {
  //   if (!_homeworkLoaded) {
  //     _homework.addAll(await Get.find<FStore>().getLessonHomeworksForStudent(_schedule, (await curriculum)!, student));
  //     _homeworkLoaded = true;
  //   }
  //   return _homework;
  // }

  // Future<String> homeworkAsTeacher(StudentModel? student) async {
  //   var a = await Get.find<FStore>().getLessonHomeworkAsLesson(_schedule, (await curriculum)!, student: student);
  //   return a[0].text;
  // }

  Future<List<HomeworkModel>> homeworks(DateTime date) async {
    if (!_homeworkLoaded) {
      _homework.addAll(await Get.find<FStore>().getLessonHomeworks(schedule, (await curriculum)!, date));
      _homeworkLoaded = true;
    }
    return _homework;
  }

  Future<List<MarkModel>> marksForStudent(StudentModel student, DateTime date) async {
    if (!_marksLoaded) {
      _marks.addAll(await Get.find<FStore>().getLessonMarksForStudent(schedule, this, student, date));
      _marksLoaded = true;
    }

    return _marks;
  }

  Future<String> marksForStudentAsString(StudentModel student, DateTime date) async {
    var ms = await marksForStudent(student, date);
    return ms.map((e) => e.mark.toString()).join(', ');
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['order'] = order;
    res['curriculum_id'] = _curriculumId;
    res['venue_id'] = _venueId;
    return res;
  }

  Future<LessonModel> save() async {
    var id = await Get.find<FStore>().saveLesson(this);
    _id ??= id;
    return this;
  }

  Future<void> delete() async {
    return Get.find<FStore>().deleteLesson(this);
  }
}
