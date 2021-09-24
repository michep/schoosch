import 'package:flutter/material.dart';

@immutable
class LessonModel {
  final String id;
  final String name;
  final int order;
  final String venue;
  final String timeFrom;
  final String timeTill;

  const LessonModel(
    this.id,
    this.name,
    this.order,
    this.venue, [
    this.timeFrom = '',
    this.timeTill = '',
  ]);

  LessonModel.fromMap(String id, Map<String, Object?> map)
      : this(
          id,
          map['name']! as String,
          map['order']! as int,
          map['venue']! as String,
          map['timeFrom']! as String,
          map['timeTill']! as String,
        );
}
