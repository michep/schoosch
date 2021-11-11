import 'package:flutter/material.dart';

@immutable
class WeekdaysModel {
  final String id;
  late final int order;
  late final String name;

  WeekdaysModel.fromMap(this.id, Map<String, Object?> map) {
    order = map['order'] != null ? map['order'] as int : -1;
    name = map['name'] != null ? map['name'] as String : '';
  }
}
