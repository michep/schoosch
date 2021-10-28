import 'package:flutter/material.dart';

@immutable
class LessontimeModel {
  final String id;
  final int order;
  final String from;
  final String till;

  const LessontimeModel(
    this.id,
    this.order,
    this.from,
    this.till,
  );

  LessontimeModel.fromMap(String id, Map<String, Object?> map)
      : this(
          id,
          map['order'] as int,
          map['from'] as String,
          map['till'] as String,
        );
}
