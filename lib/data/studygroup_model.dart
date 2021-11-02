class StudyGroupModel {
  final String id;
  final String name;
  final List<String>? peopleIds;

  StudyGroupModel(
    this.id,
    this.name,
    this.peopleIds,
  );

  StudyGroupModel.fromMap(String id, Map<String, Object?> map)
      : this(
          id,
          map['name'] != null ? map['name'] as String : '',
          map['people_ids'] != null ? map['people_ids'] as List<String> : [],
        );
}
