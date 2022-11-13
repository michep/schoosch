// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/model/absence_model.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/utils.dart';

enum LessonType {
  normal,
  replaced,
  replacment,
  empty,
}

extension LessonTypeExt on LessonType {
  static LessonType getType(int? i) {
    switch (i) {
      case 0:
        return LessonType.normal;
      case 1:
        return LessonType.replaced;
      case 2:
        return LessonType.replacment;
      case 3:
        return LessonType.empty;
      default:
        return LessonType.normal;
    }
  }
}

class LessonModel {
  final ClassModel aclass;
  final DayScheduleModel schedule;
  String? _id;
  late int order;
  late final String? curriculumId;
  late final String? venueId;
  final Map<String, List<HomeworkModel>> _homeworksThisLesson = {};
  bool _homeworksThisLessonLoaded = false;
  final Map<String, List<HomeworkModel>> _homeworksNextLesson = {};
  bool _homeworksNextLessonLoaded = false;
  final Map<String, List<MarkModel>> _marks = {};
  bool _marksLoaded = false;
  CurriculumModel? _curriculum;
  bool _curriculumLoaded = false;
  VenueModel? _venue;
  bool _venueLoaded = false;
  LessontimeModel? _lessontime;
  bool _lessontimeLoaded = false;
  final List<AbsenceModel> _absence = [];
  bool _absenceLoaded = false;

  LessonModel? replaceLesson;
  LessonType? type;
  String? get id => _id;

  LessonModel.empty(ClassModel aclass, ClassScheduleModel schedule, int order)
      : this.fromMap(aclass, schedule, null, <String, dynamic>{
          'order': order,
          'curriculum_id': '',
          'venue_id': '',
        });

  LessonModel.fromMap(this.aclass, this.schedule, this._id, Map<String, Object?> map) {
    type = map['type'] != null ? LessonTypeExt.getType((map['type'] as int)) : LessonType.normal;
    order = map['order'] != null ? map['order'] as int : throw 'need order key in lesson $_id';
    curriculumId = map['curriculum_id'] != null
        ? map['curriculum_id'] as String
        : type == LessonType.empty
            ? null
            : throw 'need curriculum_id key in lesson $_id';
    venueId = map['venue_id'] != null
        ? map['venue_id'] as String
        : type == LessonType.empty
            ? null
            : throw 'need venue_id key in lesson $_id';
    if (map.containsKey('curriculum') && map['curriculum'] is Map) {
      _curriculum = CurriculumModel.fromMap((map['curriculum'] as Map<String, dynamic>)['_id'] as String, map['curriculum'] as Map<String, dynamic>);
      _curriculumLoaded = true;
    }
    if (map.containsKey('venue') && map['venue'] is Map) {
      _venue = VenueModel.fromMap((map['venue'] as Map<String, dynamic>)['_id'] as String, map['venue'] as Map<String, dynamic>);
      _venueLoaded = true;
    }
    if (map.containsKey('time') && map['time'] is Map) {
      _lessontime = LessontimeModel.fromMap((map['time'] as Map<String, dynamic>)['_id'] as String, map['time'] as Map<String, dynamic>);
      _lessontimeLoaded = true;
    }
    if (map.containsKey('mark') && map['mark'] is List) {
      var m = (map['mark'] as List).map<MarkModel>((e) {
        var data = e as Map<String, dynamic>;
        return MarkModel.fromMap(data['_id'], data);
      }).toList();
      _marks.addAll(Utils.splitMarksByStudent(m));
      _marksLoaded = true;
    }

    if (map.containsKey('thishomework') && map['thishomework'] is List) {
      var hw = (map['thishomework'] as List).map<HomeworkModel>((e) {
        var data = e as Map<String, dynamic>;
        return HomeworkModel.fromMap(data['_id'], data);
      }).toList();
      _homeworksThisLesson.addAll(_splitHomeworksByStudent(hw));
      _homeworksThisLessonLoaded = true;
    }

    if (map.containsKey('nexthomework') && map['nexthomework'] is List) {
      var hw = (map['nexthomework'] as List).map<HomeworkModel>((e) {
        var data = e as Map<String, dynamic>;
        return HomeworkModel.fromMap(data['_id'], data);
      }).toList();
      _homeworksNextLesson.addAll(_splitHomeworksByStudent(hw));
      _homeworksNextLessonLoaded = true;
    }
  }

  void setReplacedType() {
    type = LessonType.replaced;
  }

  Future<CurriculumModel?> get curriculum async {
    if (!_curriculumLoaded && curriculumId != '') {
      _curriculum = await Get.find<ProxyStore>().getCurriculum(curriculumId!);
      _curriculumLoaded = true;
    }
    return _curriculum;
  }

  Future<VenueModel?> get venue async {
    if (!_venueLoaded && venueId != '') {
      _venue = await Get.find<ProxyStore>().getVenue(venueId!);
      _venueLoaded = true;
    }
    return _venue;
  }

  Future<LessontimeModel?> get lessontime async {
    if (!_lessontimeLoaded) {
      _lessontime = await aclass.getLessontime(order);
      _lessontimeLoaded = true;
    }
    return _lessontime;
  }

  Future<Map<String, List<HomeworkModel>>> _getAllHomeworkThisLesson(ClassModel aclass, CurriculumModel curriculum, DateTime date) async {
    var hw = await Get.find<ProxyStore>().getHomeworkThisLesson(aclass, curriculum, date);
    return _splitHomeworksByStudent(hw);
  }

  Future<Map<String, List<HomeworkModel>>> _getAllHomeworkNextLesson(ClassModel aclass, CurriculumModel curriculum, DateTime date) async {
    var hw = await Get.find<ProxyStore>().getHomeworkNextLesson(aclass, curriculum, date);
    return _splitHomeworksByStudent(hw);
  }

  Future<List<HomeworkModel>> homeworkThisLessonForClass(DateTime date, {bool forceRefresh = false}) async {
    if (!_homeworksThisLessonLoaded || forceRefresh) {
      _homeworksThisLesson.addAll(await _getAllHomeworkThisLesson(aclass, (await curriculum)!, date));
      _homeworksThisLessonLoaded = true;
    }
    return _homeworksThisLesson['class'] ?? [];
  }

  Future<List<HomeworkModel>> homeworkThisLessonForStudent(StudentModel student, DateTime date, {bool forceRefresh = false}) async {
    if (!_homeworksThisLessonLoaded || forceRefresh) {
      _homeworksThisLesson.addAll(await _getAllHomeworkThisLesson(aclass, (await curriculum)!, date));
      _homeworksThisLessonLoaded = true;
    }
    return _homeworksThisLesson[student.id!] ?? [];
  }

  Future<Map<String, List<HomeworkModel>>> homeworkThisLessonForClassAndStudent(StudentModel student, DateTime date, {bool forceRefresh = false}) async {
    if (!_homeworksThisLessonLoaded || forceRefresh) {
      _homeworksThisLesson.addAll(await _getAllHomeworkThisLesson(aclass, (await curriculum)!, date));
      _homeworksThisLessonLoaded = true;
    }
    return {
      'student': _homeworksThisLesson[student.id] ?? [],
      'class': _homeworksThisLesson['class'] ?? [],
    };
  }

  Future<Map<String, List<HomeworkModel>>> homeworkThisLessonForClassAndAllStudents(DateTime date, {bool forceRefresh = false}) async {
    if (!_homeworksThisLessonLoaded || forceRefresh) {
      _homeworksThisLesson.addAll(await _getAllHomeworkThisLesson(aclass, (await curriculum)!, date));
      _homeworksThisLessonLoaded = true;
    }
    return _homeworksThisLesson;
  }

  Future<List<HomeworkModel>> homeworkNextLessonForClass(DateTime date, {bool forceRefresh = false}) async {
    if (!_homeworksNextLessonLoaded || forceRefresh) {
      _homeworksNextLesson.addAll(await _getAllHomeworkNextLesson(aclass, (await curriculum)!, date));
      _homeworksNextLessonLoaded = true;
    }
    return _homeworksNextLesson['class'] ?? [];
  }

  Future<List<HomeworkModel>> homeworkNextLessonForStudent(StudentModel student, DateTime date, {bool forceRefresh = false}) async {
    if (!_homeworksNextLessonLoaded || forceRefresh) {
      _homeworksNextLesson.addAll(await _getAllHomeworkNextLesson(aclass, (await curriculum)!, date));
      _homeworksNextLessonLoaded = true;
    }
    return _homeworksNextLesson[student.id!] ?? [];
  }

  Future<Map<String, List<HomeworkModel>>> homeworkNextLessonForClassAndStudent(StudentModel student, DateTime date, {bool forceRefresh = false}) async {
    if (!_homeworksNextLessonLoaded || forceRefresh) {
      _homeworksNextLesson.addAll(await _getAllHomeworkNextLesson(aclass, (await curriculum)!, date));
      _homeworksNextLessonLoaded = true;
    }
    return {
      'student': _homeworksNextLesson[student.id] ?? [],
      'class': _homeworksNextLesson['class'] ?? [],
    };
  }

  Future<Map<String, List<HomeworkModel>>> homeworkNextLessonForClassAndAllStudents(DateTime date, {bool forceRefresh = false}) async {
    if (!_homeworksNextLessonLoaded || forceRefresh) {
      _homeworksNextLesson.addAll(await _getAllHomeworkNextLesson(aclass, (await curriculum)!, date));
      _homeworksNextLessonLoaded = true;
    }
    return _homeworksNextLesson;
  }

  Future<Map<String, List<MarkModel>>> getAllMarks(DateTime date, {bool forceRefresh = false}) async {
    if (!_marksLoaded || forceRefresh) {
      var m = await Get.find<ProxyStore>().getAllLessonMarks(this, date);
      _marks.clear();
      _marks.addAll(Utils.splitMarksByStudent(m));
      _marksLoaded = true;
    }
    return _marks;
  }

  Future<List<MarkModel>> marksForStudent(StudentModel student, DateTime date, {bool forceRefresh = false}) async {
    if (!_marksLoaded || forceRefresh) {
      getAllMarks(date, forceRefresh: forceRefresh);
    }
    return _marks[student.id!] == null ? [] : _marks[student.id!]!;
  }

  Map<String, List<HomeworkModel>> _splitHomeworksByStudent(List<HomeworkModel> homework) {
    Map<String, List<HomeworkModel>> res = {};
    String key;
    for (var hw in homework) {
      hw.studentId == null ? key = 'class' : key = hw.studentId!;
      if (!res.keys.contains(key)) res[key] = [];
      res[key]!.add(hw);
    }
    return res;
  }

  Future<void> saveMark(MarkModel mark) async {
    await mark.save();
  }

  Future<String> marksForStudentAsString(StudentModel student, DateTime date) async {
    var ms = await marksForStudent(student, date);
    return ms.map((e) => e.toString()).join('; ');
  }

  Future<List<AbsenceModel>> getAllAbsences(DateTime date, {bool forceRefresh = false}) async {
    if (!_absenceLoaded || forceRefresh) {
      var a = await Get.find<ProxyStore>().getAllAbsences(this, date);
      _absence.clear();
      _absence.addAll(a);
      _absenceLoaded = true;
    }
    return _absence;
  }

  Future<void> createAbsence(AbsenceModel absence) async {
    return Get.find<ProxyStore>().createAbsence(this, absence);
  }

  Map<String, dynamic> toMap({bool withId = false, bool recursive = false}) {
    Map<String, dynamic> res = {};
    if (withId) res['_id'] = id;
    res['order'] = order;
    res['curriculum_id'] = curriculumId;
    res['venue_id'] = venueId;
    if (recursive && _venueLoaded) {
      res['venue'] = _venue!.toMap(withId: withId);
    }
    if (recursive && _curriculumLoaded) {
      res['curriculum'] = _curriculum!.toMap(withId: withId, recursive: recursive);
    }
    if (recursive && _lessontimeLoaded) {
      res['time'] = _lessontime!.toMap(withId: withId);
    }
    return res;
  }

  Future<LessonModel> save() async {
    var id = await Get.find<ProxyStore>().saveLesson(this);
    _id ??= id;
    return this;
  }

  Future<void> delete() async {
    return Get.find<ProxyStore>().deleteLesson(this);
  }
}

class ReplacementModel extends LessonModel {
  ReplacementModel.fromMap(ClassModel aclass, ClassScheduleModel schedule, String? id, Map<String, dynamic> map) : super.fromMap(aclass, schedule, id, map) {
    type = LessonType.replacment;
  }
}

class EmptyLesson extends LessonModel {
  EmptyLesson.fromMap(ClassModel aclass, ClassScheduleModel schedule, String? id, int order)
      : super.fromMap(aclass, schedule, id, {
          'order': order,
          'curriculum_id': null,
          'venue_id': null,
          'type': 3,
        });

  void setAsEmpty() {
    type == LessonType.empty;
  }
}
