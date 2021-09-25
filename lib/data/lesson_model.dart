import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class LessonModel {
  final DocumentReference ref;
  final String id;
  final String name;
  final int order;
  final String venue;
  final String timeFrom;
  final String timeTill;
  bool ready;

  LessonModel(
    this.ref,
    this.id,
    this.name,
    this.order,
    this.venue, [
    this.timeFrom = '',
    this.timeTill = '',
    this.ready = false,
  ]);

  LessonModel.fromMap(DocumentReference ref, String id, Map<String, Object?> map)
      : this(
          ref,
          id,
          map['name']! as String,
          map['order']! as int,
          map['venue']! as String,
          map['timeFrom']! as String,
          map['timeTill']! as String,
          map['ready'] != null ? map['ready'] as bool : false,
        );

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'order': order,
      'venue': venue,
      'ready': ready,
    };
  }
}
