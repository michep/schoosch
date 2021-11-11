import 'package:flutter/material.dart';

@immutable
class VenueModel {
  final String id;
  late final String name;

  VenueModel.fromMap(this.id, Map<String, Object?> map) {
    name = map['name'] != null ? map['name'] as String : '';
  }
}
