import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:schoosch/controller/mongo_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/person_model.dart';

class CurriculumModel {
  ObjectId? id;
  late final String name;
  late final String? alias;
  late final ObjectId _masterId;
  final List<ObjectId> _studentIds = [];
  final List<StudentModel> _students = [];
  final List<ClassModel> _classes = [];
  bool _studentsLoaded = false;
  bool _classesLoaded = false;
  TeacherModel? _master;

  @override
  String toString() {
    return name;
  }

  CurriculumModel.empty()
      : this.fromMap(null, <String, dynamic>{
          'name': '',
          'alias': '',
          'master_id': ObjectId().empty(),
          'student_ids': <ObjectId>[],
        });

  CurriculumModel.fromMap(this.id, Map<String, dynamic> map) {
    name = map['name'] != null ? map['name'] as String : throw 'need name key in curriculum $id';
    alias = map['alias'] != null ? map['alias'] as String : null;
    _masterId = map['master_id'] != null ? map['master_id'] as ObjectId : throw 'need master_id key in curriculum $id';
    map['student_ids'] != null ? _studentIds.addAll((map['student_ids'] as List).map((e) => e as ObjectId)) : null;
  }

  String get aliasOrName => alias ?? name;

  Future<TeacherModel?> get master async {
    if (_masterId.isEmpty) return null;
    if (_master == null) {
      var store = Get.find<MStore>();
      _master = (await store.getPerson(_masterId)).asTeacher;
    }
    return _master;
  }

  Future<List<StudentModel>> students({bool forceRefresh = false}) async {
    if (!_studentsLoaded || forceRefresh) {
      _students.clear();
      _students.addAll((await Get.find<MStore>().getPeopleByIds(_studentIds)).map((e) => e.asStudent!));
      _studentsLoaded = true;
    }
    return _students;
  }

  Future<List<ClassModel>> classes({bool forceRefresh = false}) async {
    if (!_classesLoaded || forceRefresh) {
      _classes.clear();
      _classes.addAll((await Get.find<MStore>().getCurriculumClasses(this)));
      _classesLoaded = true;
    }
    return _classes;
  }

  Future<List<StudentModel>> allStudents({ClassModel? aclass}) async {
    List<StudentModel> res = [];
    var cl = await classes();
    for (var c in cl) {
      var s = await c.students();
      if (aclass != null) {
        res.addAllIf(c.grade == aclass.grade, s);
      } else {
        res.addAll(s);
      }
    }
    return res;
  }

  Future<bool> isAvailableForStudent(StudentModel student) async {
    return _studentIds.isEmpty || _studentIds.contains(student.id);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['name'] = name;
    res['alias'] = alias;
    res['master_id'] = _masterId;
    res['student_ids'] = _studentIds;
    return res;
  }

  Future<CurriculumModel> save() async {
    var nid = await Get.find<MStore>().saveCurriculum(this);
    id ??= nid;
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
