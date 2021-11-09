import 'package:cloud_firestore/cloud_firestore.dart';

enum personType { student, teacher }

class PeopleModel {
  final String id;
  final String firstname;
  final String middlename;
  final String lastname;
  final String type;
  final DateTime? birthday;
  final String email;

  PeopleModel(
    this.id,
    this.firstname,
    this.middlename,
    this.lastname,
    this.type,
    this.birthday,
    this.email,
  );

  PeopleModel.fromMap(String id, Map<String, dynamic> map)
      : this(
          id,
          map['firstname'] != null ? map['firstname'] as String : '',
          map['middlename'] != null ? map['middlename'] as String : '',
          map['lastname'] != null ? map['lastname'] as String : '',
          map['type'] != null && map['type'] == 'teacher' ? 'teacher' : 'student',
          map['birthday'] != null ? DateTime.fromMillisecondsSinceEpoch((map['birthday'] as Timestamp).millisecondsSinceEpoch) : null,
          map['email'] != null ? map['email'] as String : '',
        );
}
