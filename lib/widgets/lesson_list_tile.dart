import 'package:flutter/material.dart';
import 'package:schoosch/data/lesson_model.dart';
import 'package:schoosch/data/firestore.dart';

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
      leading: Text(widget._lesson.order.toString()),
      title: Text(widget._lesson.name),
      trailing: Text(widget._lesson.venue),
      subtitle: Text('${widget._lesson.timeFrom} - ${widget._lesson.timeTill}'),
      selected: widget._lesson.ready,
      selectedTileColor: Colors.green.shade100,
      onLongPress: _onLongPress,
    );
  }

  void _onLongPress() {
    setState(() {
      widget._lesson.ready = !widget._lesson.ready;
      FS.instance.updateLesson(widget._lesson);
    });
  }
}
