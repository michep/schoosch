import 'package:flutter/material.dart';

@immutable
class WeekdataModel {
  final String order;
  final DateTime start;
  final DateTime end;

  const WeekdataModel(
    this.order,
    this.start,
    this.end,
  );

  WeekdataModel.fromMap(String order, Map<String, Object?> map)
      : this(
          order,
          map['start']! as DateTime,
          map['end']! as DateTime,
        );
}
