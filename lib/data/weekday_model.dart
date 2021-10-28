import 'package:flutter/material.dart';

@immutable
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
          map['order'] as int,
          map['name'] as String,
        );
}
