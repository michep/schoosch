import 'package:flutter/material.dart';

@immutable
class YearweekModel {
  final String id;
  final int order;
  final DateTime start;
  final DateTime end;

  const YearweekModel(
    this.id,
    this.order,
    this.start,
    this.end,
  );

  YearweekModel.fromMap(String id, Map<String, Object?> map)
      : this(
          id,
          map['order'] as int,
          map['start'] as DateTime,
          map['end'] as DateTime,
        );
}
