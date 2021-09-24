import 'package:flutter/material.dart';

@immutable
class LessontimeModel {
  final String order;
  final String from;
  final String till;

  const LessontimeModel(
    this.order,
    this.from,
    this.till,
  );

  LessontimeModel.fromMap(String id, Map<String, Object?> map)
      : this(
          id,
          map['from']! as String,
          map['to']! as String,
        );
}
