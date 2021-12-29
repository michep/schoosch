import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/person_model.dart';

class CurriculumModel {
  String? id;
  late String name;
  late String? alias;
  late String? masterId;
  final List<String> studentIds = [];
  PersonModel? _master;
  final List<StudentModel> _students = [];
  bool _studentsLoaded = false;

  CurriculumModel.empty()
      : this.fromMap(null, <String, dynamic>{
          'name': '',
          'alias': '',
          'master_id': '',
          'student_ids': <String>[],
        });

  CurriculumModel.fromMap(this.id, Map<String, dynamic> map) {
    name = map['name'] != null ? map['name'] as String : throw 'need name key in curriculum $id';
    alias = map['alias'] != null ? map['alias'] as String : null;
    masterId = map['master_id'] != null ? map['master_id'] as String : throw 'need master_id key in curriculum $id';
    map['student_ids'] != null ? studentIds.addAll((map['student_ids'] as List<dynamic>).map((e) => e as String)) : null;
  }

  String get aliasOrName => alias ?? name;

  Future<TeacherModel?> get master async {
    if (_master == null && masterId != null) {
      var store = Get.find<FStore>();
      _master = await store.getPerson(masterId!);
    }
    return _master?.asTeacher;
  }

  Future<List<StudentModel>> get students async {
    if (!_studentsLoaded) {
      _students.addAll((await Get.find<FStore>().getPeopleByIds(studentIds)).map((e) => e.asStudent!).toList());
      _studentsLoaded = true;
    }
    return _students;
  }

  bool isAvailableForStudent(String studentId) => studentIds.isEmpty || studentIds.contains(studentId);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['name'] = name;
    res['alias'] = alias;
    res['master_id'] = masterId;
    res['student_ids'] = studentIds;
    return res;
  }

  Future<void> save() async {
    return Get.find<FStore>().saveCurriculum(this);
  }
}
