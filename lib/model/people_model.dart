import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/fire_store_controller.dart';

import 'package:schoosch/model/dayschedule_model.dart';

import 'class_model.dart';

class PeopleModel {
  late final String id;
  late final String firstname;
  late final String middlename;
  late final String lastname;
  late final List<String> types = [];
  late String _currentType;
  late final DateTime? birthday;
  late final String email;
  late final ParentModel? _parent;
  late final StudentModel? _student;
  late final TeacherModel? _teacher;

  PeopleModel.fromMap(this.id, Map<String, dynamic> map, {bool recursive = true}) {
    firstname = map['firstname'] != null ? map['firstname'] as String : throw 'need firstname key in people';
    middlename = map['middlename'] != null ? map['middlename'] as String : '';
    lastname = map['lastname'] != null ? map['lastname'] as String : throw 'need lastname key in people';
    birthday = map['birthday'] != null ? DateTime.fromMillisecondsSinceEpoch((map['birthday'] as Timestamp).millisecondsSinceEpoch) : null;
    email = map['email'] != null ? map['email'] as String : ''; //TODO: throw
    map['type'] != null ? types.addAll((map['type'] as List<dynamic>).map((e) => e as String)) : throw 'need type key in people';
    if (recursive) {
      for (var t in types) {
        switch (t) {
          case 'student':
            _student = StudentModel.fromMap(id, map);
            _currentType = t;
            break;
          case 'teacher':
            _teacher = TeacherModel.fromMap(id, map);
            _currentType = t;
            break;
          case 'parent':
            _parent = ParentModel.fromMap(id, map);
            _currentType = t;
            break;
          case 'admin':
            UnimplementedError;
            break;
          default:
            throw 'incorrect type in people';
        }
      }
      currentType$.value = _currentType;
    }
  }

  static PeopleModel? get currentUser => Get.find<FStore>().currentUser;

  StudentModel? get asStudent => _student;
  TeacherModel? get asTeacher => _teacher;
  ParentModel? get asParent => _parent;

  String get fullName => middlename != '' ? '$firstname $middlename $lastname' : '$firstname $lastname';
  String get abbreviatedName => middlename != '' ? '${firstname[0]} ${middlename[0]} $lastname' : '$firstname $lastname';

  String get currentType => _currentType;
  // set setType(String val) => _currentType = val;

  RxString get currentType$ => _currentType.obs;
  void setType(String val) => _currentType = val;

  @override
  operator ==(other) {
    if (other is PeopleModel) {
      return id == other.id;
    }
    return this == other;
  }

  @override
  int get hashCode => hashValues(id, '');
}

class StudentModel extends PeopleModel {
  late ClassModel _studentClass;
  bool _studentClassLoaded = false;

  StudentModel.fromMap(String id, Map<String, dynamic> map) : super.fromMap(id, map, recursive: false);

  Future<ClassModel> get studentClass async {
    if (!_studentClassLoaded) {
      _studentClass = await Get.find<FStore>().getClassForStudent(this);
      _studentClassLoaded = true;
    }
    return _studentClass;
  }
}

class TeacherModel extends PeopleModel {
  final Map<Week, List<TeacherScheduleModel>> _schedule = {};

  TeacherModel.fromMap(String id, Map<String, dynamic> map) : super.fromMap(id, map, recursive: false);

  Future<double> get averageRating async {
    return Get.find<FStore>().getAverageTeacherRating(this);
  }

  Future<void> createRating(PeopleModel user, int rating, String comment) async {
    return Get.find<FStore>().saveTeacherRating(this, user, DateTime.now(), rating, comment);
  }

  Future<List<TeacherScheduleModel>> getSchedulesWeek(Week week) async {
    return _schedule[week] ??= await Get.find<FStore>().getTeacherWeekSchedule(this, week);
  }
}

class ParentModel extends PeopleModel {
  final List<String> _studentIds = [];
  final List<StudentModel> _students = [];
  bool _studentsLoaded = false;
  StudentModel? _selectedChild;

  ParentModel.fromMap(String id, Map<String, dynamic> map) : super.fromMap(id, map, recursive: false) {
    map['student_ids'] != null
        ? _studentIds.addAll((map['student_ids'] as List<dynamic>).map((e) => e as String))
        : throw 'need student_ids key in people for parent';
  }

  Future<List<StudentModel>> get children async {
    if (!_studentsLoaded) {
      var store = Get.find<FStore>();
      for (var id in _studentIds) {
        // _students.add(await store.getPeople(id) as StudentModel);
        _students.add((await store.getPeople(id)).asStudent!);
      }
      _studentsLoaded = true;
    }
    return _students;
  }

  Future<StudentModel> get currentChild async {
    return _selectedChild ??= (await children)[0];
  }

  void setChild(StudentModel val) => _selectedChild = val;
}
