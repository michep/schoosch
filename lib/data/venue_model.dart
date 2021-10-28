class VenueModel {
  final String id;
  final String name;

  VenueModel(
    this.id,
    this.name,
  );

  VenueModel.fromMap(String id, Map<String, Object?> map)
      : this(
          id,
          map['name'] as String,
        );
}
