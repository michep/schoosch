import 'package:flutter/material.dart';
import 'package:schoosch/data/lesson_model.dart';

@immutable
class ScheduleModel {
  final String id;
  final int day;
  final List<LessonModel> lessons;

  const ScheduleModel(
    this.id,
    this.day, [
    this.lessons = const [],
  ]);

  ScheduleModel.fromMap(String id, Map<String, Object?> map, [List<LessonModel> lessons = const []])
      : this(
          id,
          map['day']! as int,
          lessons,
        );
}
