import 'package:schoosch/data/people_model.dart';

class CurriculumModel {
  final String id;
  final String name;
  final String? alias;
  final PeopleModel? master;

  CurriculumModel(
    this.id,
    this.name,
    this.alias,
    this.master,
  );

  CurriculumModel.fromMap(String id, Map<String, Object?> map, PeopleModel? master)
      : this(
          id,
          map['name'] as String,
          map['alias'] != null ? map['alias'] as String : null,
          master,
        );
}
