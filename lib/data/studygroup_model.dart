import 'package:schoosch/data/people_model.dart';

class StudyGroupModel {
  final String id;
  final String name;
  final List<PeopleModel> people;

  StudyGroupModel(
    this.id,
    this.name,
    this.people,
  );

  StudyGroupModel.fromMap(String id, Map<String, Object?> map, List<PeopleModel> people)
      : this(
          id,
          map['name'] as String,
          people,
        );
}
