import 'package:cloud_firestore/cloud_firestore.dart';

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
    firstname = map['firstname'] != null ? map['firstname'] as String : '';
    middlename = map['middlename'] != null ? map['middlename'] as String : '';
    lastname = map['lastname'] != null ? map['lastname'] as String : '';
    type = map['type'] != null && map['type'] == 'teacher' ? 'teacher' : 'student';
    birthday = map['birthday'] != null ? DateTime.fromMillisecondsSinceEpoch((map['birthday'] as Timestamp).millisecondsSinceEpoch) : null;
    email = map['email'] != null ? map['email'] as String : '';
  }
}
