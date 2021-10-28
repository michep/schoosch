import 'package:flutter/material.dart';
import 'package:schoosch/data/lesson_model.dart';

@immutable
class ScheduleModel {
  final String _id;
  final int _day;
  final List<LessonModel>? _lessons;

  const ScheduleModel(
    this._id,
    this._day, [
    this._lessons = const [],
  ]);

  ScheduleModel.fromMap(String id, Map<String, Object?> map, [List<LessonModel> lessons = const []])
      : this(
          id,
          map['day'] as int,
          lessons,
        );

  String get id => _id;
  int get day => _day;

  List<LessonModel> get lessons {
    return _lessons!;
  }
}
