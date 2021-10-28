import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/data/firestore.dart';
import 'package:schoosch/data/lesson_model.dart';

class LessonListTile extends StatefulWidget {
  final LessonModel _lesson;

  const LessonListTile(this._lesson, {Key? key}) : super(key: key);

  @override
  State<LessonListTile> createState() => _LessonListTileState();
}

class _LessonListTileState extends State<LessonListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(widget._lesson.id),
      title: Text(widget._lesson.curriculum.name),
      trailing: Text(widget._lesson.venue.name),
      subtitle: Text('${widget._lesson.lessontime.from} - ${widget._lesson.lessontime.till}'),
      selected: widget._lesson.ready,
      selectedTileColor: Colors.green.shade100,
      onLongPress: _onLongPress,
    );
  }

  void _onLongPress() {
    setState(() {
      final fs = Get.find<FStore>();
      widget._lesson.ready = !widget._lesson.ready;
      fs.updateLesson(widget._lesson);
    });
  }
}
