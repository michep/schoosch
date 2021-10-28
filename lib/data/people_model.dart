class PeopleModel {
  final String id;
  final String firstname;
  final String middlename;
  final String lastname;
  final String type;
  final DateTime birthday;
  final String uid;

  PeopleModel(
    this.id,
    this.firstname,
    this.middlename,
    this.lastname,
    this.type,
    this.birthday,
    this.uid,
  );

  PeopleModel.fromMap(String id, Map<String, Object?> map)
      : this(
          id,
          map['firstname'] as String,
          map['middlename'] as String,
          map['lastname'] as String,
          map['type'] as String,
          map['birthday'] as DateTime,
          map['uid'] as String,
        );
}
