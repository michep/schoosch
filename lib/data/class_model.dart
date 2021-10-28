import 'package:flutter/material.dart';
import 'package:schoosch/data/people_model.dart';
import 'package:schoosch/data/schedule_model.dart';

@immutable
class ClassModel {
  final String _id;
  final String _name;
  final int _grade;
  final PeopleModel? _master;
  final List<ScheduleModel>? _schedule;

  const ClassModel(
    this._id,
    this._name,
    this._grade,
    this._master,
    this._schedule,
  );

  ClassModel.fromMap(String id, Map<String, Object?> map, PeopleModel master, List<ScheduleModel> schedule)
      : this(
          id,
          map['name'] as String,
          map['grade'] as int,
          master,
          schedule,
        );

  ClassModel.fromMapOld(String id, Map<String, Object?> map)
      : this(
          id,
          map['name'] as String,
          map['grade'] as int,
          null,
          null,
        );

  String get id => _id;
  String get name => _name;
  int get grade => _grade;

  PeopleModel get master {
    return _master!;
  }

  Future<List<ScheduleModel>> get schedule async {
    return _schedule!;
  }
}
