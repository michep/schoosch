import 'package:flutter/material.dart';

@immutable
class ClassModel {
  final String id;
  final String name;
  final int grade;
  final List<String> scheduleIds;

  const ClassModel(
    this.id,
    this.name,
    this.grade, {
    this.scheduleIds = const [],
  });

  ClassModel.fromMap(String id, Map<String, Object?> map)
      : this(
          id,
          map['name']! as String,
          map['grade']! as int,
        );
}
