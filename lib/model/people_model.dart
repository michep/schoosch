import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';

enum personType { student, teacher }

class PeopleModel {
  late final String id;
  late final String firstname;
  late final String middlename;
  late final String lastname;
  late final String type;
  late final DateTime? birthday;
  late final String email;

  PeopleModel.fromMap(this.id, Map<String, dynamic> map) {
    firstname = map['firstname'] != null ? map['firstname'] as String : throw 'need firstname key in people';
    middlename = map['middlename'] != null ? map['middlename'] as String : '';
    lastname = map['lastname'] != null ? map['lastname'] as String : throw 'need lastname key in people';
    type = map['type'] != null ? map['type'] as String : throw 'need type key in people';
    if (!['teacher', 'student'].contains(type)) throw 'incorrect type in people';
    birthday = map['birthday'] != null ? DateTime.fromMillisecondsSinceEpoch((map['birthday'] as Timestamp).millisecondsSinceEpoch) : null;
    email = map['email'] != null ? map['email'] as String : ''; //TODO: throw
  }

  @override
  operator ==(other) {
    if (other is PeopleModel) {
      return id == other.id;
    }
    return this == other;
  }

  @override
  int get hashCode => hashValues(id, '');

  Future<double> getTeacherAverageRating() async {
    if (type == 'teacher') {
      return Get.find<FStore>().getAverageTeacherRating(id);
    }
    return 0;
  }
}
