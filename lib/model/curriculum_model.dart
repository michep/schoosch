import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/widgets/utils.dart';

class CurriculumModel {
  String? _id;
  late final String name;
  late final String? alias;
  late final String _masterId;
  final List<String> _studentIds = [];
  final List<StudentModel> _specificStudents = [];
  final List<StudentModel> _students = [];
  final List<ClassModel> _classes = [];
  bool _specificStudentsLoaded = false;
  bool _studentsLoaded = false;
  bool _classesLoaded = false;
  TeacherModel? _master;

  String? get id => _id;

  @override
  String toString() {
    return name;
  }

  CurriculumModel.empty()
      : this.fromMap(null, <String, dynamic>{
          'name': '',
          'alias': '',
          'master_id': '',
          'student_ids': <String>[],
        });

  CurriculumModel.fromMap(this._id, Map<String, dynamic> map) {
    name = map['name'] != null ? map['name'] as String : throw 'need name key in curriculum $id';
    alias = map['alias'] != null ? map['alias'] as String : null;
    _masterId = map['master_id'] != null ? map['master_id'] as String : throw 'need master_id key in curriculum $id';
    map['student_ids'] != null ? _studentIds.addAll((map['student_ids'] as List<dynamic>).map((e) => e as String)) : null;

    if (map.containsKey('master') && map['master'] is Map) {
      _master = TeacherModel.fromMap((map['master'] as Map<String, dynamic>)['_id'] as String, map['master'] as Map<String, dynamic>);
    }
  }

  String get aliasOrName => alias ?? name;

  Future<TeacherModel?> get master async {
    if (_masterId.isEmpty) return null;
    _master ??= (await Get.find<ProxyStore>().getPerson(_masterId)).asTeacher;
    return _master;
  }

  Future<List<StudentModel>> specificStudents({bool forceRefresh = false}) async {
    if (!_specificStudentsLoaded || forceRefresh) {
      _specificStudents.clear();
      _specificStudents.addAll((await Get.find<ProxyStore>().getPeopleByIds(_studentIds)).map((e) => e.asStudent!));
      _specificStudentsLoaded = true;
    }
    return _specificStudents;
  }

  Future<List<ClassModel>> classes({bool forceRefresh = false}) async {
    if (!_classesLoaded || forceRefresh) {
      _classes.clear();
      _classes.addAll((await Get.find<ProxyStore>().getCurriculumClasses(this)));
      _classesLoaded = true;
    }
    return _classes;
  }

  Future<List<StudentModel>> classStudents(ClassModel aclass) async {
    var s = await aclass.students();
    return s.where((element) => isAvailableForStudent(element)).toList();
  }

  Future<List<StudentModel>> students({bool forceRefresh = false}) async {
    if (!_studentsLoaded || forceRefresh) {
      _students.clear();
      _students.addAll((await Get.find<ProxyStore>().getCurriculumStudents(this)));
      _studentsLoaded = true;
    }
    return _students;
  }

  bool isAvailableForStudent(StudentModel student) {
    return _studentIds.isEmpty || _studentIds.contains(student.id);
  }

  Future<Map<StudentModel, List<LessonMarkModel>>> getLessonMarksByStudents(List<StudentModel> students, StudyPeriodModel period) async {
    Map<StudentModel, List<LessonMarkModel>> res = {};
    var marks = await Get.find<ProxyStore>().getCurriculumLessonMarksByStudents(this, students, period);
    var splitted = Utils.splitLessonMarksByStudent(marks);
    for (var studid in splitted.keys) {
      res[await splitted[studid]![0].student] = splitted[studid]!;
    }
    return res;
  }

  Future<Map<StudentModel, PeriodMarkModel>> getPeriodMarksByStudents(List<StudentModel> students, StudyPeriodModel period) async {
    Map<StudentModel, PeriodMarkModel> res = {};
    var marks = await Get.find<ProxyStore>().getCurriculumPeriodMarksByStudents(this, students, period);
    var splitted = Utils.splitPeriodMarksByStudent(marks);
    for (var studid in splitted.keys) {
      res[await splitted[studid]!.student] = splitted[studid]!;
    }
    return res;
  }

  Future<Map<StudentModel, List<PeriodMarkModel?>>> getAllPeriodsMarksByStudents(
    List<StudentModel> students,
    List<StudyPeriodModel> periods,
  ) async {
    Map<StudentModel, List<PeriodMarkModel?>> res = {};
    var marks = await Get.find<ProxyStore>().getPeriodsMarksByStudents(students, periods, this);
    for (StudentModel stud in students) {
      List<PeriodMarkModel> studmarks = marks.where((element) => element.studentId == stud.id).toList();
      List<PeriodMarkModel?> vals = [];
      for (StudyPeriodModel per in periods) {
        PeriodMarkModel permark = studmarks.firstWhere(
          (element) => element.periodId == per.id,
          orElse: () => PeriodMarkModel.empty(
            '',
            _id!,
            per.id!,
          ),
        );
        if (permark.mark != 0) {
          vals.add(permark);
        } else {
          vals.add(null);
        }
      }
      res[stud] = vals;
    }
    return res;
  }

  Map<String, dynamic> toMap({bool withId = false, bool recursive = false}) {
    Map<String, dynamic> res = {};
    if (withId) res['_id'] = id;
    res['name'] = name;
    res['alias'] = alias;
    res['master_id'] = _masterId;
    res['student_ids'] = _studentIds;
    if (recursive && _master != null) {
      res['master'] = _master!.toMap(withId: withId);
    }
    return res;
  }

  Future<CurriculumModel> save() async {
    var id = await Get.find<ProxyStore>().saveCurriculum(this);
    _id ??= id;
    return this;
  }

  @override
  operator ==(other) {
    if (other is CurriculumModel) {
      return id == other.id;
    }
    return this == other;
  }

  @override
  int get hashCode => Object.hash(id, '');
}
