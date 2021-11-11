class StudyGroupModel {
  final String id;
  late final String name;
  late final List<String>? peopleIds;

  StudyGroupModel.fromMap(this.id, Map<String, Object?> map) {
    name = map['name'] != null ? map['name'] as String : '';
    peopleIds = map['people_ids'] != null ? map['people_ids'] as List<String> : [];
  }
}
