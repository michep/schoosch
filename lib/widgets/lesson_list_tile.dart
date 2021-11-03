import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/data/curriculum_model.dart';
import 'package:schoosch/data/fire_store.dart';
import 'package:schoosch/data/lesson_model.dart';
import 'package:schoosch/data/lessontime_model.dart';
import 'package:schoosch/data/venue_model.dart';

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
      title: FutureBuilder<CurriculumModel>(
          future: widget._lesson.curriculum,
          builder: (context, curriculum) {
            return curriculum.hasData ? Text(curriculum.data!.name) : const Text('');
          }),
      trailing: FutureBuilder<VenueModel>(
          future: widget._lesson.venue,
          builder: (context, venue) {
            return venue.hasData ? Text(venue.data!.name) : const Text('');
          }),
      subtitle: FutureBuilder<LessontimeModel>(
          future: widget._lesson.lessontime,
          builder: (context, lessontime) {
            return lessontime.hasData
                ? Text('${lessontime.data!.from.hour.toString().padLeft(2, '0')}:${lessontime.data!.from.minute.toString().padLeft(2, '0')}'
                    '\u2014 ${lessontime.data!.till.hour.toString().padLeft(2, '0')}:${lessontime.data!.till.minute.toString().padLeft(2, '0')}')
                : const Text('');
          }),
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
