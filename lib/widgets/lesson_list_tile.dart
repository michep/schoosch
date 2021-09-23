import 'package:flutter/material.dart';
import 'package:schoosch/data/lesson_model.dart';

class LessonListTile extends StatelessWidget {
  final LessonModel _lesson;

  const LessonListTile(this._lesson, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(_lesson.order.toString()),
      title: Text(_lesson.name),
      trailing: Text(_lesson.venue),
    );
  }
}
