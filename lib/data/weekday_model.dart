class WeekdaysModel {
  final String id;
  final int order;
  final String name;

  const WeekdaysModel(
    this.id,
    this.order,
    this.name,
  );

  WeekdaysModel.fromMap(String id, Map<String, Object?> map)
      : this(
          id,
          map['order'] != null ? map['order'] as int : -1,
          map['name'] != null ? map['name'] as String : '',
        );
}
