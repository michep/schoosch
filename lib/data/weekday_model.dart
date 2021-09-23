import 'package:flutter/material.dart';

@immutable
class WeekdaysModel {
  final String order;
  final String name;

  const WeekdaysModel(
    this.order,
    this.name,
  );

  WeekdaysModel.fromMap(String id, Map<String, Object?> map)
      : this(
          id,
          map['name']! as String,
        );
}
