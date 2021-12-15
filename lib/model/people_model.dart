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
  late final String type;
  late final DateTime? birthday;
  late final String email;

  factory PeopleModel(String id, Map<String, dynamic> map) {
    var type = map['type'] != null ? map['type'] as String : throw 'need type key in people';
    if (!['teacher', 'student', 'parent', ''].contains(type)) throw 'incorrect type in people';
    switch (type) {
      case 'teacher':
        return TeacherModel.fromMap(id, map);
      case 'parent':
        return ParentModel.fromMap(id, map);
      default:
        return StudentModel.fromMap(id, map);
    }
  }

  PeopleModel._fromMap(this.id, Map<String, dynamic> map) {
    firstname = map['firstname'] != null ? map['firstname'] as String : throw 'need firstname key in people';
    middlename = map['middlename'] != null ? map['middlename'] as String : '';
    lastname = map['lastname'] != null ? map['lastname'] as String : throw 'need lastname key in people';
    type = map['type'] != null ? map['type'] as String : throw 'need type key in people';
    if (!['teacher', 'student', 'parent', ''].contains(type)) throw 'incorrect type in people';
    birthday = map['birthday'] != null ? DateTime.fromMillisecondsSinceEpoch((map['birthday'] as Timestamp).millisecondsSinceEpoch) : null;
    email = map['email'] != null ? map['email'] as String : ''; //TODO: throw
  }

  static PeopleModel? get currentUser => Get.find<FStore>().currentUser;

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

  StudentModel.fromMap(String id, Map<String, dynamic> map) : super._fromMap(id, map);

  Future<ClassModel> get studentClass async {
    if (!_studentClassLoaded) {
      _studentClass = await Get.find<FStore>().getStudentClass(this);
      _studentClassLoaded = true;
    }
    return _studentClass;
  }
}

class TeacherModel extends PeopleModel {
  TeacherModel.fromMap(String id, Map<String, dynamic> map) : super._fromMap(id, map);

  Future<double> get averageRating async {
    return Get.find<FStore>().getAverageTeacherRating(this);
  }

  Future<List<DayScheduleModel>> getTeacherDaySchedules(Week week) async {
    // Get.find<FStore>().getSchedulesModelCurrentTeacher(week);
    return [];
  }
}

class ParentModel extends PeopleModel {
  ParentModel.fromMap(String id, Map<String, dynamic> map) : super._fromMap(id, map);
}
