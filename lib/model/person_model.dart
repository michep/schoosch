import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/fire_store_controller.dart';

import 'package:schoosch/model/dayschedule_model.dart';

import 'class_model.dart';

class PersonModel {
  late String? id;
  late String firstname;
  late String? middlename;
  late String lastname;
  late List<String> types = [];
  late String _currentType;
  late DateTime? birthday;
  late String email;
  ParentModel? _asParent;
  StudentModel? _asStudent;
  TeacherModel? _asTeacher;

  PersonModel.fromMap(this.id, Map<String, dynamic> map, [bool _recursive = true]) {
    firstname = map['firstname'] != null ? map['firstname'] as String : throw 'need firstname key in people $id';
    middlename = map['middlename'] != null ? map['middlename'] as String : null;
    lastname = map['lastname'] != null ? map['lastname'] as String : throw 'need lastname key in people $id';
    birthday = map['birthday'] != null ? DateTime.fromMillisecondsSinceEpoch((map['birthday'] as Timestamp).millisecondsSinceEpoch) : null;
    email = map['email'] != null ? map['email'] as String : throw 'need email key in people $id';
    map['type'] != null ? types.addAll((map['type'] as List<dynamic>).map((e) => e as String)) : throw 'need type key in people $id';
    if (_recursive) {
      for (var t in types) {
        switch (t) {
          case 'parent':
            _asParent = ParentModel.fromMap(id, map);
            _currentType = t;
            break;
          case 'student':
            _asStudent = StudentModel.fromMap(id, map);
            _currentType = t;
            break;
          case 'teacher':
            _asTeacher = TeacherModel.fromMap(id, map);
            _currentType = t;
            break;
          case 'admin':
            _currentType = t;
            break;
          default:
            throw 'incorrect type in people $id';
        }
      }
    }
  }

  static PersonModel? get currentUser => Get.find<FStore>().currentUser;
  static StudentModel? get currentStudent => currentUser?._asStudent;
  static TeacherModel? get currentTeacher => currentUser?._asTeacher;
  static ParentModel? get currentParent => currentUser?._asParent;

  StudentModel? get asStudent => _asStudent;
  TeacherModel? get asTeacher => _asTeacher;
  ParentModel? get asParent => _asParent;

  String get currentType => _currentType;
  void setType(String val) => _currentType = val;

  @override
  operator ==(other) {
    if (other is PersonModel) {
      return id == other.id;
    }
    return this == other;
  }

  @override
  int get hashCode => hashValues(id, '');

  String get fullName => middlename != null ? '$lastname $firstname $middlename' : '$lastname $firstname';
  String get abbreviatedName => middlename != null ? '$lastname ${firstname[0]}. ${middlename![0]}.' : '$lastname ${firstname[0]}.';

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['firstname'] = firstname;
    res['middlename'] = middlename;
    res['lastname'] = lastname;
    res['birthday'] = birthday != null ? Timestamp.fromDate(birthday!) : null;
    res['email'] = email;
    res['type'] = types;
    return res;
  }

  Future<void> save() async {
    Get.find<FStore>().savePerson(this);
  }
}

class StudentModel extends PersonModel {
  late final ClassModel _studentClass;
  ParentModel? parent;
  bool _studentClassLoaded = false;

  StudentModel.empty()
      : super.fromMap(null, <String, dynamic>{
          'firstname': '',
          'middlename': '',
          'lastname': '',
          'email': '',
          'type': <String>['student'],
        });

  StudentModel.fromMap(String? id, Map<String, dynamic> map) : super.fromMap(id, map, false);

  Future<ClassModel> get studentClass async {
    if (!_studentClassLoaded) {
      _studentClass = await Get.find<FStore>().getClassForStudent(this);
      _studentClassLoaded = true;
    }
    return _studentClass;
  }

  @override
  Future<void> save() async {
    return Get.find<FStore>().savePerson(this);
  }
}

class TeacherModel extends PersonModel {
  final Map<Week, List<TeacherScheduleModel>> _schedule = {};

  TeacherModel.empty()
      : super.fromMap(null, <String, dynamic>{
          'firstname': '',
          'middlename': '',
          'lastname': '',
          'email': '',
          'type': <String>['teacher'],
        });

  TeacherModel.fromMap(String? id, Map<String, dynamic> map) : super.fromMap(id, map, false);

  Future<double> get averageRating async {
    return Get.find<FStore>().getAverageTeacherRating(this);
  }

  Future<void> createRating(PersonModel user, int rating, String comment) async {
    return Get.find<FStore>().saveTeacherRating(this, user, DateTime.now(), rating, comment);
  }

  Future<List<TeacherScheduleModel>> getSchedulesWeek(Week week) async {
    return _schedule[week] ??= await Get.find<FStore>().getTeacherWeekSchedule(this, week);
  }
}

class ParentModel extends PersonModel {
  final List<String> studentIds = [];
  final List<StudentModel> _students = [];
  bool _studentsLoaded = false;
  StudentModel? _selectedChild;

  ParentModel.empty()
      : super.fromMap(null, <String, dynamic>{
          'firstname': '',
          'middlename': '',
          'lastname': '',
          'email': '',
          'type': <String>['parent'],
          'student_ids': <String>[],
        });

  ParentModel.fromMap(String? id, Map<String, dynamic> map) : super.fromMap(id, map, false) {
    map['student_ids'] != null
        ? studentIds.addAll((map['student_ids'] as List<dynamic>).map((e) => e as String))
        : throw 'need student_ids key in people for parent $id';
  }

  Future<List<StudentModel>> get children async {
    if (!_studentsLoaded) {
      var store = Get.find<FStore>();
      for (var id in studentIds) {
        var p = await store.getPerson(id);
        if (p.currentType == 'student') {
          p.asStudent!.parent = this;
          _students.add(p.asStudent!);
        }
      }
      _studentsLoaded = true;
    }
    return _students;
  }

  Future<StudentModel> get currentChild async {
    return _selectedChild ??= (await children)[0];
  }

  void setChild(StudentModel val) => _selectedChild = val;

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = super.toMap();
    res['student_ids'] = studentIds;
    return res;
  }
}