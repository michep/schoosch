// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoosch/old/controller/proxy_controller.dart';
import 'package:schoosch/old/model/absence_model.dart';
import 'package:schoosch/old/model/class_model.dart';
import 'package:schoosch/old/model/curriculum_model.dart';
import 'package:schoosch/old/model/dayschedule_model.dart';
import 'package:schoosch/old/model/homework_model.dart';
import 'package:schoosch/old/model/lessontime_model.dart';
import 'package:schoosch/old/model/mark_model.dart';
import 'package:schoosch/old/model/person_model.dart';
import 'package:schoosch/old/model/venue_model.dart';
import 'package:schoosch/old/widgets/utils.dart';

enum LessonType {
  normal,
  replaced,
  replacment,
  empty;

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
  final String aclassId;
  final String scheduleId;
  String? _id;
  late int order;
  late final String? curriculumId;
  late final String? venueId;
  final Map<String, List<HomeworkModel>> _homeworksThisLesson = {};
  final Map<String, List<HomeworkModel>> _homeworksNextLesson = {};
  final Map<String, List<LessonMarkModel>> _marks = {};
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

  LessonModel.empty(String aclassId, String scheduleId, int order)
      : this.fromMap(aclassId, scheduleId, null, <String, dynamic>{
          'order': order,
          'curriculum_id': '',
          'venue_id': '',
        });

  LessonModel.fromMap(this.aclassId, this.scheduleId, this._id, Map<String, Object?> map) {
    type = map['type'] != null ? LessonType.getType((map['type'] as int)) : LessonType.normal;
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
      var m = (map['mark'] as List).map<LessonMarkModel>((e) {
        var data = e as Map<String, dynamic>;
        return LessonMarkModel.fromMap(data['_id'], data);
      }).toList();
      _marks.addAll(Utils.splitLessonMarksByStudent(m));
      _marksLoaded = true;
    }

    if (map.containsKey('thishomework') && map['thishomework'] is List) {
      var hw = (map['thishomework'] as List).map<HomeworkModel>((e) {
        var data = e as Map<String, dynamic>;
        return HomeworkModel.fromMap(data['_id'], data);
      }).toList();
      _homeworksThisLesson.addAll(_splitHomeworksByStudent(hw));
    }

    if (map.containsKey('nexthomework') && map['nexthomework'] is List) {
      var hw = (map['nexthomework'] as List).map<HomeworkModel>((e) {
        var data = e as Map<String, dynamic>;
        return HomeworkModel.fromMap(data['_id'], data);
      }).toList();
      _homeworksNextLesson.addAll(_splitHomeworksByStudent(hw));
    }

    if (map.containsKey('absence') && map['absence'] is List) {
      var abs = (map['absence'] as List).map<AbsenceModel>((e) {
        var data = e as Map<String, dynamic>;
        return AbsenceModel.fromMap(data['_id'], data);
      }).toList();
      _absence.addAll(abs);
      _absenceLoaded = true;
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

  // Future<LessontimeModel?> get lessontime async {
  //   if (!_lessontimeLoaded) {
  //     _lessontime = await aclass.getLessontime(order);
  //     _lessontimeLoaded = true;
  //   }
  //   return _lessontime;
  // }

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

  // Future<void> saveMark(LessonMarkModel mark) async {
  //   await mark.save();
  // }

  // Future<String> marksForStudentAsString(StudentModel student, DateTime date) async {
  //   var ms = await lessonMarksForStudent(student, date);
  //   return ms.map((e) => e.toString()).join('; ');
  // }

  // Future<List<AbsenceModel>> getAllAbsences(DateTime date, {bool forceRefresh = false}) async {
  //   if (!_absenceLoaded || forceRefresh) {
  //     var a = await Get.find<ProxyStore>().getAllAbsences(this, date);
  //     _absence.clear();
  //     _absence.addAll(a);
  //     _absenceLoaded = true;
  //   }
  //   return _absence;
  // }

  // Future<void> createAbsence(AbsenceModel absence) async {
  //   return Get.find<ProxyStore>().createAbsence(this, absence);
  // }

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
}

class ReplacementLessonModel extends LessonModel {
  ReplacementLessonModel.fromMap(super.aclassId, super.scheduleId, super.id, Map<String, dynamic> super.map) : super.fromMap() {
    type = LessonType.replacment;
  }
}

class EmptyLessonModel extends LessonModel {
  EmptyLessonModel.fromMap(String aclassId, String scheduleId, String? id, int order)
      : super.fromMap(aclassId, scheduleId, id, {
          'order': order,
          'curriculum_id': null,
          'venue_id': null,
          'type': 3,
        });

  void setAsEmpty() {
    type == LessonType.empty;
  }
}
