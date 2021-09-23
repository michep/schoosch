import 'package:flutter/material.dart';

@immutable
class LessonModel {
  final String id;
  final String name;
  final int order;
  final String venue;

  const LessonModel(
    this.id,
    this.name,
    this.order,
    this.venue,
  );

  LessonModel.fromMap(String id, Map<String, Object?> map)
      : this(
          id,
          map['name']! as String,
          map['order']! as int,
          map['venue']! as String,
        );
}
